# add_schedule

## Как использовать

1. Сохраните этот код в файл, например, `add_schedule_with_vars.sh`.
2. Дайте ему права на выполнение:
   ```bash
   chmod +x add_schedule_with_vars.sh
   ```
3. Запустите скрипт с аргументами, например:
   ```bash
   ./add_schedule_with_vars.sh "https://gitlab.example.com" <project_id> <access_token> "My scheduled job" "0 * * * *" "VAR1=value1" "VAR2=value2"
   ```

### Аргументы
- <gitlab_url>: URL вашего GitLab-сервера.
- <project_id>: ID проекта в GitLab.
- <access_token>: Токен доступа для работы с API.
- <description>: Описание/Имя расписания.
- <cron_schedule>: (опционально) Расписание в формате cron (по умолчанию: 0 * * * *).
- <variable_key=value>: (опционально) Переменные для использования в расписании.

### Пример скрипта-обвязки
```shell
#!/bin/bash

GITLAB_URL="https://gitlab.someorg.ru"
MY_TOKEN="*******"
GITLAB_PROJECT_ID="591"

# UP (WEEKLY)
SGHEDULE_DESCRIPTION="REGION MY_PROJECT UP (WEEKLY)"

./add_schedule_with_vars.sh "${GITLAB_URL}" "${GITLAB_PROJECT_ID}" "${MY_TOKEN}" "${SGHEDULE_DESCRIPTION}" "43 11 * * 7" "ENVIRONMENT=prod" "BYPASS_MONITORING=true" "BYPASS_DEPLOY=false" "BYPASS_RESTORE=true" "BYPASS_DESTROY=true" "BYPASS_DEPLOY_SAFELOCK=true"

# MONITORING UP (RESTART)
SGHEDULE_DESCRIPTION="REGION MY_PROJECT MONITORING UP (RESTART)"

./add_schedule_with_vars.sh "${GITLAB_URL}" "${GITLAB_PROJECT_ID}" "${MY_TOKEN}" "${SGHEDULE_DESCRIPTION}" "0 21 1 1 *" "ENVIRONMENT=prod" "BYPASS_MONITORING=false" "BYPASS_DEPLOY=true" "BYPASS_RESTORE=true" "BYPASS_DESTROY=true"

# DOWN ( - )
SGHEDULE_DESCRIPTION="REGION MY_PROJECT PROD DOWN"

./add_schedule_with_vars.sh "${GITLAB_URL}" "${GITLAB_PROJECT_ID}" "${MY_TOKEN}" "${SGHEDULE_DESCRIPTION}" "0 21 1 1 *" "ENVIRONMENT=prod" "BYPASS_MONITORING=true" "BYPASS_DEPLOY=true" "BYPASS_RESTORE=true" "BYPASS_DESTROY=false"

```
