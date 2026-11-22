# Лабораторная работа 8 — Basic Login

Продолжение лабораторной 7 (`web7`). Методичка: `../methodical/Ch8.odt`.
Ruby 3.4.11, Rails 8.1.4, Bundler 4.0.21; SQLite в development/test.

## Запуск в Windows

В терминале из папки `web8`:

```powershell
chcp 65001
bundle install
rails db:prepare
rails dartsass:build
rails server -p 3008
```

Открыть http://localhost:3008. Регистрация: `/signup`, вход: `/login`.
Создайте аккаунт через форму регистрации — вход произойдёт автоматически.
Для выхода откройте Account → Log out. Остановка сервера: Ctrl+C.

База этой лабораторной: `storage/development.sqlite3` внутри `web8`.
Пользователи из базы `web7` автоматически не переносятся.

После изменения SCSS выполните `rails dartsass:build` либо запустите
`rails dartsass:watch` в отдельном терминале. На Windows Puma и тесты
работают в одном процессе. Для Docker предусмотрен `compose.yaml`
с портом 3000 вместо 3008.

## Проверки

```powershell
rails test
bundle exec rubocop
```

Реализованы разделы 8.1–8.3: форма входа, аутентификация через bcrypt,
`flash.now`, временная сессия, `current_user`, `logged_in?`, меню Account,
мобильное меню, вход после регистрации и выход с HTTP 303.
Перед входом и при выходе сессия сбрасывается через `reset_session`.

Ссылки Users и Settings остаются заглушками по главе 8; их реализация
относится к главе 10. Remember me относится к главе 9 и здесь не добавлен.
В production унаследованы HTTPS, Puma и PostgreSQL; развёртывание
на хостинге не выполнялось. Подробности проверки: [docs/lab8.md](docs/lab8.md).
