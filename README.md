# Русификатор Dino Crisis 1
Перевод Dino Crisis 1 на русский язык для [патча Classic REbirth](https://classicrebirth.com/index.php/dino-crisis-classic-rebirth/). Работает только с японской версией Dino Crisis.

## Папки
* `Translation/text` - текстовый перевод (основной, обновляемый).
* `Translation/tables` - таблиц соотвествия шрифта (hex коды = буквы, необходимы для Translhextion16c).
* `Translation/font` - шрифт.
* `Translation/ViT` - предоставленный [текстовый переовод из PSX версии](https://psxplanet.ru/forum/showthread.php?t=33881) (Перевод текста: Xardion, ViT. Частичный перенос текста от "Акелла").

Огромное спасибо ViToTiV за предоставленный перевод.

## Нашли ошибку? Хотите улучшить перевод?
Ошибку можно прислать в раздел `Issues` или прислать `Pull request` (нажав форк, добавив переносом обновленный файл или git-ом) и нажав `Pull request`.

**Важно!** Большая просьба присылать ошибки и изменения маленькими кусками с обоснованиями нового перевода, чтобы их можно было легко и быстро проверить. Пожалуйста, запаситесь терпением. Необычные переносы предложений, скорее всего, связаны со спецификой бинарного перевода, поэтому прежде чем предлагать более красивый перенос, проверьте его возможность, посмотрев бинарный файл (об этом читаем ниже).

## Замена перевода в DLL
Перевод находится в патче Classic REbirth, файлы находятся в 7z контейнере, в DLL.

1. Открываем DLL, с помощью [Resource Hacker](https://www.angusj.com/resourcehacker/).
2. Выбираем в списке Data -> 107, жмем "Save *.bin resource" и сохраняем файл (можно в DATA107.7z)
3. Далее переносим наши файлы в нужную папку в архиве, с заменой.
4. Открываем повторно DLL в Resource Hacker и заменяем файл, предварительно переименовав DATA107.7z в DATA107.bin.
5. После чего можно сохранить DLL и запускать игру.

## Перевод бинарных файлов
Бинарный перевод заключается в том, чтобы заменить английский текст на русский, один к одному. В целом сокращать тексты не было необходимости, места хватает. Иногда когда места не хватает можно придумать какой-то творческий перевод. Текстовый перевод нужен для наглядности и удобства работы с переводом.

1. Открываем нужный diff файл, с помощью [HxD](https://mh-nexus.de/en/downloads.php?product=HxD20) hex редактора.
2. Открываем diff файл, с помощью Translhextion16c, выбираем Script -> Open Thingy Table -> Выбираем файл таблицы (ReadTable.tbl для работы с оригинальными английскими файлами, WriteTable.tbl для работы с уже перевёденными файлами). В открывшемся мини-окне "Table Toolbar" кликаем на "Thingy View Active", после чего видим справа перевод. Translhextion16c по сути нужен, чтобы смотреть где у нас переносы текста, специальные коды и прочее, которые мы пропускаем.
3. Открываем "Патчер". Для перевода оригинально файла выбираем нужный файл, смотрим, чтобы кусок текста был до различных переносов ("\/\/", "\\\", ####) и так далее, подставляем нужный текст наверх, а переводимый текст вниз. После чего жмем "В HEX" и получаем 2 строки hex кодов, которые можно заменить через HxD, нажав Поиск -> Заменить или CTRl + R, выбрав тип данных - "Шестандцетиричные значения" и направление поиска "Везде". Для исправления текущего перевода смотрим текущий русский перевод, пишем строку в нижнее поле, запоминаем кол-во символов, жмем "в HEX" и получаем нужную HEX строку, после чего аналогично делаем со строкой на которую нужно заменить.

Утилиты можно найти [здесь](https://github.com/REClassicRus/DC1Rus/releases).

## Шрифт
1. (Для рисования шрифта с нуля) Берем оригинальный png файл и конвертируем его правой кнопкой мыши в bmp, с помощью XnView.
2. Изменяем bmp файл.
3. Конвертируем bmp файл обратно в png, с помощью XnView.

Спасибо teamx за наводку.

## Загрузка
[Последняя версия](https://mega.nz/folder/u7YVxSCD#4wzAwaSixlJ2Rmk97uD0LA)
