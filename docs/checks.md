# Завдання №3 — CI для UI

Workflow `.github/workflows/ci.yml` запускається на pull_request і push у main. Це перевірка фронтенду: API, PostgreSQL і Redis для неї не потрібні.

## Послідовність

1. **UI lint (ESLint)** — `npm run lint`: перевірка src/**/*.ts, src/**/*.vue та JavaScript. ESLint використовує рекомендовані правила JavaScript і TypeScript та essential-правила Vue. Жодних warnings не допускається. Для наявних однослівних назв Login/Register/Welcome/Wishlists задано явні винятки лише з правила імен компонентів.
2. **UI types (vue-tsc)** — `npm run typecheck` перевіряє TypeScript і Vue SFC. Запускається після lint.
3. **UI build (Vite)** — `npm run build` створює dist; цей наявний скрипт також повторно перевіряє типи. Запускається після typecheck. Папка dist завантажується як артефакт **wishlist-ui-dist**, строк зберігання — 14 днів. Відсутність dist є помилкою.

Усі job використовують Ubuntu 24.04, Node.js 24.21.0 із .nvmrc, `npm ci` та кеш npm через setup-node з ключем за package-lock.json. Самі node_modules не кешуються. Версії checkout v4.2.2, setup-node v4.4.0 та upload-artifact v4.6.2 закріплені точними SHA. Дозволи workflow — contents: read.

Для проходження ESLint прибрано невикористані catch-змінні та замінено явні any на типізовані дані відповіді й unknown з перевіркою Axios-помилки. Виправлення не вимикають перевірку no-explicit-any. Валідаційні відповіді без текстового detail показують резервне повідомлення.

## Повторення локально

```bash
nvm install
nvm use
npm ci
npm run lint
npm run typecheck
npm run build
```

Node.js має відповідати .nvmrc. Збірка не потребує запущеного API. VITE_API_BASE задається під час збірки; без нього діє адреса localhost:8000, передбачена src/api.ts. Артефакт — готова статична збірка, це не автоматичне розгортання сайту.

## Перевірка

Локально lint, typecheck та build пройшли. Результат GitHub Actions і наявність артефакту буде записано після фактичного запуску.

Тести UI не додано відповідно до умови. Rulesets, демонстрація блокування merge та вимірювання часу кешу належать до завдань №4–5 і тут не виконуються.
