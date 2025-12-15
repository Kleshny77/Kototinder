# Кототиндер

Flutter приложение для просмотра котиков и изучения пород кошек.

## Описание

Приложение в стиле Tinder для просмотра котиков. Позволяет свайпать изображения, лайкать понравившихся, изучать информацию о породах и просматривать список всех доступных пород.

## Реализованные функции

### Главный экран (Свайп котиков)

- Случайное изображение котика с названием породы
- Свайп влево/вправо или кнопки лайк/дизлайк
- Счетчик лайкнутых котиков
- Тап на изображение открывает детальную информацию
- Плавная анимация смены карточек
- Предзагрузка очереди из 5 котиков

### Экран детального описания

- Изображение котика (полноразмерное)
- Информация о породе: название, происхождение, продолжительность жизни
- Описание породы
- Темперамент в виде чипов
- 4 характеристики с прогресс-барами: адаптивность, привязанность, дружелюбие к детям, уровень энергии

### Экран "Список пород"

- Таб-бар с переключением между экранами
- Список всех пород с краткой информацией
- Тап на породу открывает детальную информацию
- Pull-to-refresh для обновления

## Технические требования

- Использован пакет `http` для запросов к [The Cat API](https://thecatapi.com)
- Endpoints: `/images/search?has_breeds=1` и `/breeds`
- Использован `CachedNetworkImage` для отображения изображений
- Сетевые ошибки обрабатываются с показом диалогов
- Код отформатирован с помощью `dart format`
- Подключен `flutter_lints`, `flutter analyze` выполняется без ошибок

## Установка и запуск

```bash
git clone <repository-url>
cd flutter_hw1
flutter pub get
flutter run
```

### Сборка APK

```bash
flutter build apk --release
```

APK: `build/app/outputs/flutter-apk/app-release.apk`

## Зависимости

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.0
  cached_network_image: ^3.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

## Структура проекта

```
lib/
├── models/
│   ├── breed.dart
│   └── cat_image.dart
├── screens/
│   ├── swipe_screen.dart
│   ├── breed_detail_screen.dart
│   └── breeds_list_screen.dart
├── services/
│   └── cat_api_service.dart
└── main.dart
```

## Скриншоты

Для добавления скриншотов:

1. Сделайте скриншоты приложения на разных экранах
2. Сохраните их в папку `screenshots/` в корне проекта
3. Добавьте их в README используя следующий формат:

```markdown
### Главный экран
![Главный экран](screenshots/main_screen.png)

### Детальная информация
![Детальная информация](screenshots/detail_screen.png)

### Список пород
![Список пород](screenshots/breeds_list.png)
```

Пример структуры:
- `screenshots/main_screen.png` - главный экран со свайпом
- `screenshots/detail_screen.png` - экран детальной информации
- `screenshots/breeds_list.png` - список пород

## Ссылка на APK

APK файл находится по пути: `build/app/outputs/flutter-apk/app-release.apk`

Для публикации APK:

1. Загрузите APK на файлообменник (Google Drive, Dropbox, GitHub Releases и т.д.)
2. Получите прямую ссылку на скачивание
3. Добавьте ссылку в README:

```markdown
[Скачать APK](https://your-link-to-apk.com/app-release.apk)
```

**Текущая версия APK:** `build/app/outputs/flutter-apk/app-release.apk` (44 MB)
