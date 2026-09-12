# Flutter Clean Architecture Example Project

Приложение для демонстрации подходов Clean Architecture, SOLID и DI на базе BLoC, Dio и Hive.

## Архитектура

Приложение разбито на 3 ключевых слоя согласно правилу направленности зависимостей:
`Presentation -> Domain <- Data`

1. **Domain Layer**: 
   - Не содержит зависимостей от Flutter framework, Dio, Hive, JSON-библиотек (Pure Dart).
   - Содержит чистые бизнес-сущности (`PostEntity`), абстракции репозиториев и атомарные Use Cases.
   - Передача результатов бизнес-операций осуществляется через обертку `Result<T>` (`Success` / `Failure`).

2. **Data Layer**:
   - Реализует абстрактные интерфейсы из Domain-слоя.
   - Содержит DTO (`PostDto`, `UserDto`), мапперы (`PostDtoMapper`) и источники данных (`RemoteDataSource`, `LocalDataSource`).
   - Исключения `DioException` трансформируются в кастомные `NetworkException` в сетевых Interceptors и оборачиваются в доменные `Failure` внутри репозитория.

3. **Presentation Layer**:
   - Отвечает за отображение интерфейса и реакцию на действия пользователя.
   - Логика управления состоянием построена на **BLoC**.
   - Виджеты зависят исключительно от BLoC и не обращаются к репозиториям напрямую.

### Особенности организации Dependency Injection (`core/DI/modules`)

Файлы `repository_module.dart`, `bloc_module.dart`, `local_module.dart` и `network_module.dart` сознательно вынесены в `core/DI/modules`, а не разнесены по отдельным фичам. 

**Архитектурное обоснование:**
- **Централизованный граф зависимостей (Layer-first / Composition Root):** Для текущего масштаба приложения сборка графа в одном месте упрощает отслеживание порядка инициализации (например, `Network -> Storage -> Repositories -> UseCases -> BLoC`).
- **Снижение избыточности:** Избавляет от необходимости плодить файлы DI-конфигураторов под каждую отдельную фичу, сохраняя точку сборки `injection.dart` максимально лаконичной и понятной.
- **Прозрачность подмены зависимостей:** Позволяет в один клик изменять реализации (например, подменить `PostsLocalDataSourceImpl` с SharedPreferences на Hive) без захода в модули Presentation или Domain.

---

## Обработка ошибок и безопасные результаты (`Result` Pattern)

В проекте не используются плавающие `try-catch` в UI или BLoC. Вместо этого применен `Result` Pattern на базе `sealed classes` (Dart 3+), обеспечивающий строгую типизацию и исчерпывающую проверку вариантов (`exhaustive matching`).

[ HTTP Ошибка ]
       │
       ▼
1. Interceptor      ───▶ Преобразует HTTP 500 / Timeout в сырой NetworkException
       │
       ▼
2. Repository       ───▶ Ловит NetworkException через try-catch и заворачивает в Result
       │
       ▼
3. Result (Failure) ───▶ Поступает в BLoC, заставляет зайти в branch switch и нарисовать UI

## Запуск

Установка зависимостей:
flutter pub get

Запуск приложения:
flutter run
