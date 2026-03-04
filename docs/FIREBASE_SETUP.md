# Полная настройка Firebase (без заглушек)

**Важно:** Файлы с ключами (`firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`) в репозиторий не коммитятся. После клона скопируй пример: `cp lib/firebase_options.example.dart lib/firebase_options.dart`, затем при необходимости выполни `flutterfire configure`.

После выполнения этих шагов в проекте будет реальный конфиг Firebase, аналитика заработает.

---

## 1. Установить инструменты (один раз)

В терминале:

```bash
# Войти в аккаунт Google/Firebase
firebase login

# Установить FlutterFire CLI глобально
dart pub global activate flutterfire_cli
```

Убедись, что `dart pub global activate` доступен в PATH. Если команда `flutterfire` не находится, добавь в PATH папку, где лежат глобальные пакеты Dart (обычно что-то вроде `$HOME/.pub-cache/bin` или через `dart pub global activate` подскажет путь).

---

## 2. Создать проект в Firebase (если ещё нет)

1. Открой [Firebase Console](https://console.firebase.google.com/).
2. Нажми **«Создать проект»** (или выбери существующий).
3. Укажи название (например, `Kototinder`), при необходимости отключи Google Analytics для самого проекта — потом включим только в приложении.
4. Дождись создания проекта.

---

## 3. Привязать Flutter-проект к Firebase (FlutterFire Configure)

В **корне проекта** (там, где `pubspec.yaml`):

```bash
cd /Users/sass-artem/hse/flutter_hw1/flutter_hw1

# Вариант 1: если flutterfire в PATH
flutterfire configure

# Вариант 2: через dart run (без глобальной установки)
dart run flutterfire_cli:flutterfire
```

Что произойдёт:

- Появится выбор/создание Firebase-проекта.
- Выбери платформы: **Android** и **iOS** (можно обе).
- CLI:
  - создаст приложения Android/iOS в выбранном проекте Firebase (если ещё нет);
  - сгенерирует **`lib/firebase_options.dart`** (заменит текущую заглушку);
  - положит **`android/app/google-services.json`**;
  - положит **`ios/Runner/GoogleService-Info.plist`** и при необходимости подскажет добавить его в Xcode.

После этого **заглушка в `firebase_options.dart` больше не используется** — там будет реальный конфиг.

---

## 4. Проверка

1. Убедись, что появились файлы:
   - `lib/firebase_options.dart` (содержит `DefaultFirebaseOptions` с реальными `apiKey`, `appId`, `projectId` и т.д.);
   - `android/app/google-services.json`;
   - `ios/Runner/GoogleService-Info.plist`.

2. Запуск приложения:

```bash
flutter run
# или с API-ключом котиков:
./run_with_api_key.sh
```

3. Войди в приложении (логин/регистрация). В [Firebase Console](https://console.firebase.google.com/) → твой проект → **Analytics** → **DebugView** (включи отладку на устройстве/эмуляторе при необходимости) — должны появиться события входа/регистрации.

---

## 5. Если что-то пошло не так

- **«Plugin com.google.gms.google-services not found»**  
  В проекте уже добавлен плагин в `android/settings.gradle.kts` и `android/app/build.gradle.kts`. Выполни `flutter clean` и снова `flutter pub get` и собери проект.

- **iOS: «GoogleService-Info.plist not found»**  
  После `flutterfire configure` файл должен лежать в `ios/Runner/`. Если Xcode не подхватывает его, открой `ios/Runner.xcworkspace` в Xcode и вручную добавь `GoogleService-Info.plist` в target Runner (перетащи в дерево проекта и отметь «Copy items if needed»).

- **События не видны в Analytics**  
  Включи [режим отладки Analytics](https://firebase.google.com/docs/analytics/debugview) на устройстве/эмуляторе и проверь DebugView в консоли Firebase; события могут появляться с задержкой несколько минут.

---

После успешного `flutterfire configure` заглушки убраны: используется только сгенерированный конфиг Firebase.
