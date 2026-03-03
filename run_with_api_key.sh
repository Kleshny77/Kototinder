#!/bin/bash
# Запуск приложения с API-ключом из .env (ключ не попадает в git)
set -e
cd "$(dirname "$0")"
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi
if [ -z "$CAT_API_KEY" ]; then
  echo "CAT_API_KEY не задан. Скопируйте .env.example в .env и добавьте ключ."
  exit 1
fi
exec flutter run --dart-define=CAT_API_KEY="$CAT_API_KEY" "$@"
