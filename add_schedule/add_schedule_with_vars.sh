#!/bin/bash

# Проверка на количество аргументов
if [ "$#" -lt 4 ]; then
    echo "Использование: $0 <gitlab_url> <project_id> <access_token> <description> [<cron_schedule> <variable_key=value> ...]"
    exit 1
fi

GITLAB_URL="$1"
PROJECT_ID="$2"
ACCESS_TOKEN="$3"
DESCRIPTION="$4"  # Описание
CRON_SCHEDULE="${5:-'0 * * * *'}"  # По умолчанию каждый час

# Добавление расписания
create_schedule() {
    curl --request POST "$GITLAB_URL/api/v4/projects/$PROJECT_ID/pipeline_schedules" \
        --header "PRIVATE-TOKEN: $ACCESS_TOKEN" \
        --header "Content-Type: application/json" \
        --data '{
            "description": "'"$DESCRIPTION"'",
            "cron": "'"$CRON_SCHEDULE"'",
            "active": true,
            "ref": "master"
        }'
}

# Получение ID нового расписания
SCHEDULE_RESPONSE=$(create_schedule)
SCHEDULE_ID=$(echo "$SCHEDULE_RESPONSE" | jq -r '.id')

if [ "$SCHEDULE_ID" == "null" ]; then
    echo "Ошибка при создании расписания: $SCHEDULE_RESPONSE"
    exit 1
fi

echo "Расписание создано с ID: $SCHEDULE_ID"

# Добавление переменных к расписанию
shift 5  # Удаляем первые пять аргументов
if [ "$#" -gt 0 ]; then
    for VAR in "$@"; do
        IFS='=' read -r KEY VALUE <<< "$VAR"
        if [ -z "$KEY" ] || [ -z "$VALUE" ]; then
            echo "Переменная должна иметь формат key=value: $VAR"
            continue
        fi

        # Добавление переменной
        curl --request POST "$GITLAB_URL/api/v4/projects/$PROJECT_ID/pipeline_schedules/$SCHEDULE_ID/variables" \
            --header "PRIVATE-TOKEN: $ACCESS_TOKEN" \
            --header "Content-Type: application/json" \
            --data '{
                "key": "'"$KEY"'",
                "value": "'"$VALUE"'"
            }'
        echo "Переменная $KEY добавлена к расписанию $SCHEDULE_ID"
    done
else
    echo "Переменные не указаны."
fi
