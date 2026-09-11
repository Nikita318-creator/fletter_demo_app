# Flutter Clean Architecture Example Project

Приложение для демонстрации подходов Clean Architecture, SOLID и DI.

## Архитектура

Приложение разбито на 3 ключевых слоя согласно правилу направленности зависимостей:
`Presentation -> Domain <- Data`

1. **Domain Layer**: 
   - Не содержит зависимостей от Flutter, Dio, Hive, JSON-библиотек.
   - Содержит бизнес-сущности (`PostEntity`), абстракции репозиториев и UseCases.
   - Возврат данных производится через `Result<T>` (`Success` / `Failure`).

2. **Data Layer**:
   - Реализует интерфейсы из Domain.
   - Содержит DTO (`PostDto`, `UserDto`), мапперы (`PostDtoMapper`) и источники данных (`Remote`, `Local`).
   - Исключения `DioException` трансформируются в `ServerException` в Interceptor и оборачиваются в `Failure` внутри репозитория.

3. **Presentation Layer**:
   - Отвечает за отображение и реакцию на действия пользователя.
   - Логика управляется BLoC/Cubit.
   - Виджеты используют только BLoC/Cubit, не обращаясь к репозиториям напрямую.

## Запуск

1. Установка зависимостей:
   ```bash
   flutter pub get
