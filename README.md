# Тестовое задание Медузы

## Первый запуск в режиме разработки

```bash
docker-compose up -d db
docker-compose run --rm backend rake db:setup
COMMAND="rails s -b 0.0.0.0" docker-compose up -d
```

## Дальнейшие запуски

```bash
COMMAND="rails s -b 0.0.0.0" docker-compose up -d
```

## Запуск юнит-тестов

```bash
docker-compose run --rm backend rspec 
```

## Запуск миграций БД (development & test)

```bash
docker-compose run --rm backend rake db:migrate 
```