# Лабораторна №5 — образ UI

Dockerfile має етап `build`: Node 24.21.0-alpine, npm ci за package-lock.json,
потім копіювання коду й збірка Vite. ARG VITE_API_BASE є обов’язковим.
Фінальний production етап — nginx 1.28.0-alpine, nginx.conf і dist.
Node, node_modules, вихідний TypeScript, .env і Git у фінальний образ не копіюються.
nginx try_files повертає index.html для SPA-маршрутів, /health повертає 200.

```bash
docker build --target build --build-arg VITE_API_BASE=http://localhost:8000 -t wishlist-ui:build .
docker build --build-arg VITE_API_BASE=http://localhost:8000 -t wishlist-ui:lab05-local .
docker image inspect wishlist-ui:build wishlist-ui:lab05-local --format '{{.RepoTags}} {{.Size}}'
```

## Розміри

Таблиця фактичних вимірювань буде додана після збірки; розміри ще не виміряні.
Очікувана причина різниці — Node та node_modules на build-етапі; висновок буде перевірено через du.

## Адреса API

Vite вбудовує VITE_API_BASE у JavaScript під час npm run build.
Runtime environment nginx не переписує вже створені статичні файли.
Для зміни адреси потрібна повторна збірка з новим build-arg; секрети таким способом не передаються.
Адреса призначена браузеру: localhost:8000, а не внутрішнє ім’я api:8000.

## Стек та розробка

[Повна інструкція Compose](https://github.com/KushOleks/withlist-api/blob/main/docs/containers.md).
Обидва репозиторії клонуються в сусідні папки. compose.yaml лежить у withlist-api.
Dev-профіль використовує bind mount джерел і named volume node_modules; npm ci при старті
оновлює Linux-залежності з lock-файлу. Vite відображає зміни компонентів без Docker build.

## CI та реєстр

UI image (Docker) запускається після lint, types і Vite build.
На PR виконується тільки збірка та перевірка nginx/SPA; публікація заборонена.
Main публікує main та sha-<повний SHA>, v* — semver теги й latest.
Публікація multi-arch: linux/amd64 та linux/arm64, GHCR login через GITHUB_TOKEN.
Trivy — окремий advisory job; він зберігає JSON і підсумок OS/application findings у Summary.
Доказ публічного пакета, релізу й manifest буде додано після публікації.
