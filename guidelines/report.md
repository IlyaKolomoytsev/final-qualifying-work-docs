# Контроль покрытия

Этот файл фиксирует, что исходный PDF был разложен на LLM-ready документы без намеренного пропуска смысловых разделов.

Источник: [doc.pdf](sources/guidelines-for-the-2022-final-qualification-project/doc.pdf), извлечен в 70 текстовых страниц.

## Проверка страниц

| Страницы | Содержимое | Покрытие |
| --- | --- | --- |
| 1-4 | Обложка, аннотация издания, оглавление | [README.md](README.md), [toc.txt](sources/guidelines-for-the-2022-final-qualification-project/extracted/toc.txt), [001](sources/guidelines-for-the-2022-final-qualification-project/extracted/pages/001.txt)-[004](sources/guidelines-for-the-2022-final-qualification-project/extracted/pages/004.txt) |
| 5-6 | Общие сведения | [00-vkr-package.md](00-vkr-package.md) |
| 7-13 | Пояснительная записка | [01-poyasnitelnaya-zapiska.md](01-poyasnitelnaya-zapiska.md) |
| 14-22 | Техническое задание | [02-technical-assignment.md](02-technical-assignment.md) |
| 22-25 | Руководство системного программиста | [03-system-programmer-guide.md](03-system-programmer-guide.md) |
| 25-26 | Требования к программе, объем, апробация | [04-software-requirements-and-verification.md](04-software-requirements-and-verification.md) |
| 27-34 | Мероприятия, предзащиты, презентации, допуск | [05-events-and-predefenses.md](05-events-and-predefenses.md) |
| 34-37 | Верификация, аттестация, передача тестировщику | [04-software-requirements-and-verification.md](04-software-requirements-and-verification.md) |
| 38-40 | Нормоконтроль, антиплагиат, Dump | [06-normcontrol-antiplagiat-dump.md](06-normcontrol-antiplagiat-dump.md) |
| 40-42 | Прошивка и диск | [07-binding-and-disk.md](07-binding-and-disk.md) |
| 42-44 | Преддипломная практика | [08-predegree-practice.md](08-predegree-practice.md) |
| 45-59 | Форматирование | [09-formatting.md](09-formatting.md) |
| 60-68 | Титульные листы | [10-title-pages.md](10-title-pages.md) |
| 69 | Список литературы методички | Этот файл |
| 70 | Выходные данные издания | Этот файл |

## Элементы, сохраненные как ссылки на исходник

Некоторые элементы методички зависят от визуального вида PDF и оставлены с прямыми ссылками на исходные страницы:

- рисунки в приложении А;
- визуальные примеры номеров ВКРБ;
- титульные листы и листы задания;
- образец переплета.

## Список литературы исходной методички

На странице [069](<sources/guidelines-for-the-2022-final-qualification-project/extracted/pages/069.txt>) перечислены 6 источников:

1. Вигерс К. `Разработка требований к программному обеспечению`.
2. Куликов С. С. `Тестирование программного обеспечения. Базовый курс`.
3. Липаев В. В. `Тестирование компонентов и комплексов программ`.
4. Майерс Г., Баджетт Т., Сандлер К. `Искусство тестирования программ`.
5. Пышкин Е. В., Глухих М. И. `Модульное тестирование программного обеспечения`.
6. Савин Р. `Тестирование Дот Ком, или Пособие по жестокому обращению с багами в интернет-стартапах`.

## Выходные данные

На странице [070](<sources/guidelines-for-the-2022-final-qualification-project/extracted/pages/070.txt>) указано учебное издание:

`Подготовка, оформление выпускной квалификационной работы и преддипломной практики`.

## Что проверить вручную перед использованием

- [ ] Открыть исходный PDF для визуальных титульных листов.
- [ ] Проверить актуальные даты мероприятий на `edu.vstu.ru`.
- [ ] Проверить актуальные шаблоны титульных листов на `edu.vstu.ru`.
- [ ] Проверить, не появились ли новые кафедральные требования после версии методички.
