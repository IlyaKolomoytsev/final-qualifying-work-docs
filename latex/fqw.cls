% Final qualifying work document class.                         % краткое описание назначения класса: оформление ВКР и связанных документов
%                                                                    % пустая строка комментария для визуального отделения вводного описания
% The class centralizes layout rules for the explanatory note, statement of % описание: класс централизует правила верстки пояснительной записки и ТЗ
% work, and related documents. It is intended for LuaLaTeX or XeLaTeX.      % указание поддерживаемых движков: LuaLaTeX или XeLaTeX
\NeedsTeXFormat{LaTeX2e}[2023-06-01]                         % требовать формат LaTeX2e не старее версии от 2023-06-01
\ProvidesExplClass                                             % объявить expl3-совместимый класс документа
{fqw}                                                          % задать имя класса, используемое в \documentclass{fqw}
{2026-05-19}                                                   % задать дату версии класса
{0.1.0}                                                        % задать номер версии класса
{Final qualifying work class}                                  % задать краткое текстовое описание класса

\RequirePackage{expl3}                                         % подключить ядро LaTeX3 для работы с bool, token list, keys и expl-синтаксисом
\RequirePackage{l3keys2e}                                      % подключить обработку опций класса через механизм l3keys

\ExplSyntaxOn                                                  % включить синтаксис expl3 с двоеточиями и подчеркиваниями в именах команд
\bool_new:N \g_fqw_number_within_section_bool                  % создать глобальную булеву переменную для режима нумерации внутри разделов
\bool_gset_false:N \g_fqw_number_within_section_bool           % по умолчанию выключить нумерацию рисунков, таблиц и формул внутри разделов
\tl_new:N \g_fqw_document_code_tl                              % создать глобальную token list-переменную для шифра/кода документа
\tl_gset:Nn \g_fqw_document_code_tl { ВКРБ-09.03.04-10.19-XX-XX-81 } % записать значение шифра документа по умолчанию

\keys_define:nn { fqw / class }                                % начать описание пользовательских опций класса в пространстве ключей fqw/class
{                                                              % открыть список ключей и обработчиков опций класса
    numbers .choice:,                                          % объявить опцию numbers как выбор из предопределенных значений
    numbers / continuous .code:n =                             % определить значение numbers=continuous для сквозной нумерации
        { \bool_gset_false:N \g_fqw_number_within_section_bool }, % при numbers=continuous выключить привязку нумерации к разделам
    numbers / section .code:n =                                % определить значение numbers=section для нумерации внутри разделов
        { \bool_gset_true:N \g_fqw_number_within_section_bool }, % при numbers=section включить привязку нумерации к разделам
    numbers .initial:n = continuous,                           % задать значение опции numbers по умолчанию: continuous
    document-code .tl_gset:N = \g_fqw_document_code_tl,         % связать опцию document-code с token list-переменной шифра документа
    document-code .initial:n = ВКРБ-09.03.04-10.19-XX-XX-81,    % задать значение document-code по умолчанию
    unknown .code:n =                                          % описать обработку неизвестных опций класса
        { \PassOptionsToClass { \CurrentOption } { article } }  % передавать неизвестные опции базовому классу article/extarticle
}                                                              % закрыть список ключей и обработчиков опций класса
\ProcessKeysOptions { fqw / class }                            % обработать опции, переданные пользователем в \documentclass
\ExplSyntaxOff                                                 % выключить expl3-синтаксис и вернуть обычный синтаксис LaTeX

\LoadClass[14pt,a4paper,oneside]{extarticle}                  % загрузить базовый класс extarticle с кеглем 14 pt, A4 и односторонней версткой

\RequirePackage{iftex}                                         % подключить проверку используемого TeX-движка
\ifPDFTeX                                                      % начать условие: если документ собирается через pdfTeX/pdfLaTeX
\ClassError{fqw}                                               % сформировать ошибку класса fqw
{Use LuaLaTeX or XeLaTeX}                                      % краткое сообщение ошибки: требуется LuaLaTeX или XeLaTeX
{This class uses fontspec for Times New Roman-compatible Cyrillic text.} % подробное пояснение: fontspec требует Unicode-движок
\fi                                                            % завершить условие проверки pdfTeX

\newlength{\FqwTopMargin}                                      % объявить длину для верхнего поля страницы
\newlength{\FqwHeaderDistance}                                 % объявить длину для расстояния от верхнего края страницы до колонтитула
\newlength{\FqwHeaderHeight}                                   % объявить длину для высоты верхнего колонтитула
\newlength{\FqwHeaderSeparation}                               % объявить длину для расстояния между верхним колонтитулом и текстовым блоком
\setlength{\FqwTopMargin}{20mm}                                % установить верхнее поле страницы равным 20 мм
\setlength{\FqwHeaderDistance}{12.5mm}                         % установить расстояние до верхнего колонтитула равным 12,5 мм
\setlength{\FqwHeaderHeight}{17pt}                             % установить высоту верхнего колонтитула равной 17 pt
\setlength{\FqwHeaderSeparation}{\dimexpr\FqwTopMargin-\FqwHeaderDistance-\FqwHeaderHeight\relax} % вычислить headsep из верхнего поля, положения и высоты колонтитула

\RequirePackage[                                               % начать подключение пакета geometry с параметрами страницы
    a4paper,                                                   % установить формат бумаги A4
    left=30mm,                                                 % установить левое поле 30 мм
    right=15mm,                                                % установить правое поле 15 мм
    top=\FqwTopMargin,                                         % установить верхнее поле из переменной \FqwTopMargin
    bottom=20mm,                                               % установить нижнее поле 20 мм
    headheight=\FqwHeaderHeight,                               % установить высоту верхнего колонтитула из переменной \FqwHeaderHeight
    headsep=\FqwHeaderSeparation                               % установить расстояние от колонтитула до текста из вычисленной переменной
]{geometry}                                                    % подключить geometry для управления размерами страницы и полями
\RequirePackage{fontspec}                                      % подключить fontspec для системных шрифтов в XeLaTeX/LuaLaTeX
\RequirePackage[english,russian]{babel}                        % подключить переносы и локализацию для английского и русского языков
\RequirePackage{microtype}                                     % подключить микротипографику для улучшения межбуквенных и межсловных интервалов
\RequirePackage{setspace}                                      % подключить управление межстрочным интервалом
\RequirePackage{indentfirst}                                   % включить абзацный отступ у первого абзаца после заголовка
\RequirePackage{ragged2e}                                      % подключить улучшенное выравнивание текста, включая \justifying
\RequirePackage{titlesec}                                      % подключить настройку формата и интервалов заголовков
\RequirePackage{tocloft}                                       % подключить настройку оглавления
\RequirePackage{caption}                                       % подключить настройку подписей к рисункам и таблицам
\RequirePackage{float}                                         % подключить расширенное управление плавающими объектами
\RequirePackage{graphicx}                                      % подключить вставку графических файлов
\RequirePackage{array}                                         % расширить возможности табличных колонок
\RequirePackage{booktabs}                                      % подключить качественные горизонтальные линии для таблиц
\RequirePackage{longtable}                                     % подключить таблицы с переносом на несколько страниц
\RequirePackage{tabularx}                                      % подключить таблицы с автоматически растягиваемыми колонками X
\RequirePackage{multirow}                                      % подключить объединение ячеек таблицы по вертикали
\RequirePackage{makecell}                                      % подключить удобное форматирование многострочных ячеек таблиц
\RequirePackage{amsmath}                                       % подключить расширенные математические окружения AMS
\RequirePackage{mathtools}                                     % подключить дополнительные инструменты для amsmath
\RequirePackage{enumitem}                                      % подключить тонкую настройку списков itemize/enumerate
\RequirePackage{fancyhdr}                                      % подключить настройку верхних и нижних колонтитулов
\RequirePackage{xcolor}                                        % подключить поддержку цветов
\RequirePackage{csquotes}                                      % подключить корректные кавычки и интеграцию с babel/biblatex
\RequirePackage{etoolbox}                                      % подключить хуки и патчи команд/окружений
\RequirePackage{hyperref}                                      % подключить гиперссылки, закладки PDF и внутренние ссылки

\defaultfontfeatures{Ligatures=TeX,Scale=MatchLowercase}       % задать общие свойства системных шрифтов: TeX-лигатуры и масштабирование по строчным буквам
\IfFontExistsTF{Times New Roman}                               % проверить наличие системного шрифта Times New Roman
{\setmainfont{Times New Roman}}                                % если Times New Roman найден, назначить его основным шрифтом документа
{%                                                             % открыть ветку ошибки, если Times New Roman отсутствует
    \ClassError{fqw}                                           % сформировать ошибку класса fqw
    {Times New Roman is not installed}                         % краткое сообщение ошибки об отсутствии Times New Roman
    {%                                                         % открыть подробное сообщение ошибки
        This template requires the system font "Times New Roman".\MessageBreak % пояснить, что шаблон требует установленный Times New Roman
        Install it and rerun XeLaTeX/LuaLaTeX.\MessageBreak    % предложить установить шрифт и повторить сборку Unicode-движком
        No font fallbacks are allowed for this project.         % указать, что резервные основные шрифты в проекте запрещены
    }%                                                         % закрыть подробное сообщение ошибки
}                                                              % закрыть ветку ошибки для отсутствующего Times New Roman

\IfFontExistsTF{STIX Two Math}                                 % проверить наличие математического шрифта STIX Two Math
{\RequirePackage{unicode-math}\setmathfont{STIX Two Math}}     % если шрифт найден, подключить unicode-math и назначить STIX Two Math
{                                                              % открыть ветку подбора резервного математического шрифта
    \IfFontExistsTF{TeX Gyre Termes Math}                      % проверить наличие TeX Gyre Termes Math
    {\RequirePackage{unicode-math}\setmathfont{TeX Gyre Termes Math}} % если шрифт найден, подключить unicode-math и назначить TeX Gyre Termes Math
    {}                                                         % если математические шрифты не найдены, не выполнять дополнительных действий
}                                                              % закрыть ветку проверки STIX Two Math

\newcommand{\fqw@SetupBaseTextStype}{%
    \hyphenpenalty=10000                                       % Запрещает автоматические переносы слов по слогам.
    \exhyphenpenalty=10000                                     % Запрещает переносы после явных дефисов.
    \sloppy                                                    % Разрешает LaTeX сильнее растягивать межсловные пробелы,
    \setstretch{1.5}                                           % установить межстрочный интервал 1,5
    \justifying                                                % включить выравнивание текста по ширине
    \setlength{\parskip}{0pt}                                  % убрать дополнительный вертикальный интервал между абзацами
    \setlength{\parindent}{1.25cm}                             % установить абзацный отступ 1,25 см
    \color{black}                                              % установить основной цвет текста черным
}
\fqw@SetupBaseTextStype
% после начала документа
\AtBeginDocument{\fqw@SetupBaseTextStype}

\newcommand{\nbspace}{\nobreak\kern0.333em\ignorespaces}

\hypersetup{                                                   % начать настройку параметров пакета hyperref
    unicode=true,                                              % включить Unicode в PDF-закладках и метаданных
    hidelinks,                                                 % скрыть визуальное оформление ссылок
    colorlinks=false,                                          % отключить цветные ссылки
    pdfborder={0 0 0}                                          % убрать рамки вокруг ссылок в PDF
}                                                              % завершить настройку hyperref

\pagestyle{fancy}                                              % установить стиль страниц fancyhdr
\fancyhf{}                                                     % очистить все верхние и нижние колонтитулы
\fancyfoot[C]{\thepage}                                        % поставить номер страницы по центру нижнего колонтитула
\renewcommand{\headrulewidth}{0pt}                             % убрать горизонтальную линию верхнего колонтитула
\renewcommand{\footrulewidth}{0pt}                             % убрать горизонтальную линию нижнего колонтитула

\ExplSyntaxOn                                                  % включить expl3-синтаксис для доступа к token list-переменной
\cs_new:Npn \fqwDocumentCodeToken { \tl_use:N \g_fqw_document_code_tl } % создать команду, возвращающую текущий шифр документа из token list
\ExplSyntaxOff                                                 % выключить expl3-синтаксис

\newcommand{\FqwDocumentCode}{\fqwDocumentCodeToken}           % создать пользовательскую команду для вывода шифра документа
\newcommand{\FqwEnableDocumentCodeHeader}{%                    % объявить команду включения шифра документа в верхнем колонтитуле
    \fancyhead[C]{\normalfont\normalsize\FqwDocumentCode}%     % поместить шифр документа по центру верхнего колонтитула обычным шрифтом
    \renewcommand{\headrulewidth}{0pt}%                        % гарантированно убрать линию верхнего колонтитула
}                                                              % закрыть определение команды включения шифра в колонтитуле
\newcommand{\FqwDisableDocumentCodeHeader}{\fancyhead[C]{}}    % объявить команду отключения центрального верхнего колонтитула

\setcounter{secnumdepth}{4}                                    % включить нумерацию структурных уровней до paragraph включительно
\setcounter{tocdepth}{3}                                       % включить в оглавление уровни до subsubsection включительно
\renewcommand{\thesection}{\arabic{section}}                   % задать арабскую нумерацию разделов: 1, 2, 3
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}} % задать нумерацию подразделов через номер раздела: 1.1
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}} % задать нумерацию пунктов третьего уровня: 1.1.1
\renewcommand{\theparagraph}{\thesubsubsection.\arabic{paragraph}} % задать нумерацию paragraph как четвертого уровня: 1.1.1.1

\titleformat{\section}[block]                                         % начать настройку формата нумерованного заголовка \section
{\normalfont}                                                  % задать обычный шрифт заголовка раздела без жирного начертания
{\hspace*{1.25cm}\thesection}                                                  % выводить номер раздела в формате \thesection
{0.7em}                                                        % задать горизонтальный интервал между номером и текстом заголовка
{}                                                             % не добавлять дополнительный код перед текстом заголовка
\titleformat{name=\section,numberless}[block]                         % начать настройку формата ненумерованного заголовка \section*
{\normalfont}                                                  % задать обычный шрифт ненумерованного заголовка
{\hspace*{1.25cm}}                                                             % не выводить номер у ненумерованного заголовка
{0pt}                                                          % задать нулевой интервал между отсутствующим номером и текстом
{}                                                             % не добавлять дополнительный код перед текстом ненумерованного заголовка
\titleformat{\subsection}[block]                                      % начать настройку формата заголовка \subsection
{\normalfont}                                                  % задать обычный шрифт заголовка подраздела
{\hspace*{1.25cm}\thesubsection}                                               % выводить номер подраздела в формате \thesubsection
{0.7em}                                                        % задать интервал между номером подраздела и текстом заголовка
{}                                                             % не добавлять дополнительный код перед текстом заголовка подраздела
\titleformat{name=\subsection,numberless}[block]                                      % начать настройку формата заголовка \subsection
{\normalfont}                                                  % задать обычный шрифт заголовка подраздела
{\hspace*{1.25cm}}                                               % выводить номер подраздела в формате \thesubsection
{0em}                                                        % задать интервал между номером подраздела и текстом заголовка
{}
\titleformat{\subsubsection}[block]                                   % начать настройку формата заголовка \subsubsection
{\normalfont}                                                  % задать обычный шрифт заголовка пункта третьего уровня
{\hspace*{1.25cm}\thesubsubsection}                                            % выводить номер пункта в формате \thesubsubsection
{0.7em}                                                        % задать интервал между номером и текстом заголовка
{}                                                             % не добавлять дополнительный код перед текстом заголовка
\titleformat{\paragraph}[block]                                       % начать настройку формата заголовка \paragraph
{\normalfont}                                                  % задать обычный шрифт заголовка четвертого уровня
{\hspace*{1.25cm}\theparagraph}                                                % выводить номер четвертого уровня в формате \theparagraph
{0.7em}                                                        % задать интервал между номером и текстом заголовка
{}                                                             % не добавлять дополнительный код перед текстом заголовка

\titlespacing*{\section}                                       % начать настройку отступов для заголовка \section
{0 pt}                                                       % задать левый отступ заголовка раздела 1,25 см
{1\baselineskip}                                               % задать вертикальный отступ перед заголовком в одну строку
{1\baselineskip}                                               % задать вертикальный отступ после заголовка в одну строку

\titlespacing*{\subsection}                                    % начать настройку отступов для заголовка \subsection
{0 pt}                                                       % задать левый отступ заголовка подраздела 1,25 см
{1\baselineskip}                                               % задать вертикальный отступ перед заголовком в одну строку
{1\baselineskip}                                               % задать вертикальный отступ после заголовка в одну строку

\titlespacing*{\subsubsection}                                 % начать настройку отступов для заголовка \subsubsection
{0 pt}                                                       % задать левый отступ заголовка третьего уровня 1,25 см
{1\baselineskip}                                               % задать вертикальный отступ перед заголовком в одну строку
{1\baselineskip}                                               % задать вертикальный отступ после заголовка в одну строку

\titlespacing*{\paragraph}                                     % начать настройку отступов для заголовка \paragraph
{0 pt}                                                       % задать левый отступ заголовка четвертого уровня 1,25 см
{1\baselineskip}                                               % задать вертикальный отступ перед заголовком в одну строку
{1\baselineskip}                                               % задать вертикальный отступ после заголовка в одну строку

\newcommand{\FqwUnnumberedSection}[1]{%                       % объявить команду для ненумерованного раздела с добавлением в оглавление
    \phantomsection%                                           % создать корректную гиперссылочную точку для hyperref
    \section*{#1}%                                             % вывести ненумерованный заголовок раздела с переданным текстом
    \addcontentsline{toc}{section}{#1}%                        % добавить этот заголовок в оглавление как раздел
}                                                              % закрыть определение команды \FqwUnnumberedSection

%% Настройки содержания                                        % заголовок блока настройки оглавления
\renewcommand{\contentsname}{Содержание}                       % переименовать заголовок оглавления на русский
\renewcommand{\cfttoctitlefont}{\normalfont}                   % использовать обычный шрифт для заголовка оглавления
\setlength{\cftaftertoctitleskip}{2\baselineskip}              % отступ снизу после заголовка оглавления в 2 строки
\setlength{\cftbeforesecskip}{0pt}                             % убрать вертикальный отступ перед пунктами разделов в оглавлении
\setlength{\cftbeforesubsecskip}{0pt}                          % убрать вертикальный отступ перед пунктами подразделов в оглавлении
\renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}}          % включить точки-лидеры между названием раздела и номером страницы
\renewcommand{\cftsecfont}{\normalfont}                        % использовать обычный шрифт для названий разделов в оглавлении
\renewcommand{\cftsecpagefont}{\normalfont}                    % использовать обычный шрифт для номеров страниц разделов
\renewcommand{\cftsubsecfont}{\normalfont}                     % использовать обычный шрифт для названий подразделов в оглавлении
\renewcommand{\cftsubsecpagefont}{\normalfont}                 % использовать обычный шрифт для номеров страниц подразделов


\DeclareCaptionLabelSeparator{fqwsep}{\space\textendash\space} % объявить разделитель подписи вида " — " между меткой и текстом
\captionsetup{                                                 % начать общую настройку подписей caption
    font=normalsize,                                           % установить обычный размер шрифта подписи
    labelfont=normalfont,                                      % установить обычное начертание метки подписи
    labelsep=fqwsep,                                           % использовать пользовательский разделитель " — "
    justification=centering,                                   % центрировать текст подписи по умолчанию
    singlelinecheck=false,                                     % не применять специальное центрирование только для однострочных подписей
    skip=0.5\baselineskip                                      % задать интервал между объектом и подписью в половину строки
}                                                              % завершить общую настройку подписей
\captionsetup[figure]{                                         % начать настройку подписей только для рисунков
    name=Рисунок,                                              % заменить стандартное имя figure на "Рисунок"
    position=bottom,                                           % размещать подпись рисунка снизу
    justification=centering,                                   % центрировать подпись рисунка
    singlelinecheck=true                                       % применять стандартную обработку однострочной подписи рисунка
}                                                              % завершить настройку подписей рисунков
\captionsetup[table]{                                          % начать настройку подписей только для таблиц
    name=Таблица,                                              % заменить стандартное имя table на "Таблица"
    position=top,                                              % размещать подпись таблицы сверху
    labelsep=fqwsep,                                           % использовать разделитель " — " в подписи таблицы
    justification=raggedright,                                 % выравнивать подпись таблицы по левому краю
    singlelinecheck=false,                                     % не центрировать автоматически однострочные подписи таблиц
    margin=0pt,                                                % убрать дополнительный отступ подписи таблицы
    skip=0.5\baselineskip                                      % задать интервал между подписью и таблицей в половину строки
}                                                              % завершить настройку подписей таблиц
\setlength{\abovecaptionskip}{0.5\baselineskip}                % установить отступ над подписью в половину строки
\setlength{\belowcaptionskip}{0.5\baselineskip}                % установить отступ под подписью в половину строки
\setlength{\textfloatsep}{1\baselineskip}                      % установить расстояние между плавающим объектом и текстом в одну строку
\setlength{\intextsep}{1\baselineskip}                         % установить расстояние вокруг плавающего объекта внутри текста в одну строку
\floatstyle{plain}                                             % выбрать стиль plain для последующих плавающих объектов
\restylefloat{figure}                                          % применить текущий float-стиль к рисункам
\floatstyle{plaintop}                                          % выбрать стиль plaintop для последующих плавающих объектов
\restylefloat{table}                                           % применить текущий float-стиль к таблицам

\ExplSyntaxOn                                                  % включить expl3-синтаксис для проверки булевой переменной
\bool_if:NT \g_fqw_number_within_section_bool                  % если включена опция нумерации внутри разделов, выполнить следующий блок
{                                                              % открыть блок команд для режима numbers=section
    \numberwithin{figure}{section}                             % нумеровать рисунки внутри разделов: 1.1, 1.2
    \numberwithin{table}{section}                              % нумеровать таблицы внутри разделов: 1.1, 1.2
    \numberwithin{equation}{section}                           % нумеровать формулы внутри разделов: 1.1, 1.2
}                                                              % закрыть блок команд для режима numbers=section
\ExplSyntaxOff                                                 % выключить expl3-синтаксис

\newenvironment{FqwFigureNote}                                 % объявить окружение для примечания под рисунком
{\par\begingroup\fontsize{12pt}{14pt}\selectfont\justifying}  % при входе: новый абзац, локальная группа, шрифт 12/14 pt, выравнивание по ширине
{\par\endgroup}                                                % при выходе: завершить абзац и локальную группу

\AtBeginEnvironment{figure}{\setlength{\parindent}{0pt}}       % при входе в figure убрать абзацный отступ
\AtBeginEnvironment{table}{\setlength{\parindent}{0pt}}        % при входе в table убрать абзацный отступ
\AtBeginEnvironment{longtable}{\setlength{\parindent}{0pt}\justifying} % при входе в longtable убрать абзацный отступ и выравнять текст по ширине
\AtBeginEnvironment{tabular}{\fontsize{12pt}{14pt}\selectfont} % при входе в tabular установить шрифт таблицы 12/14 pt
\AtBeginEnvironment{tabularx}{\fontsize{12pt}{14pt}\selectfont} % при входе в tabularx установить шрифт таблицы 12/14 pt
\AtBeginEnvironment{longtable}{\fontsize{12pt}{14pt}\selectfont} % при входе в longtable установить шрифт таблицы 12/14 pt

\NewDocumentCommand{\FqwTableCaption}{o m}{%                   % объявить команду подписи таблицы с необязательным коротким вариантом
    \IfNoValueTF{#1}{\caption{#2}}{\caption[#1]{#2}}%          % если короткая подпись не передана, вывести обычную; иначе задать short title для списка
}                                                              % закрыть определение команды \FqwTableCaption
\NewDocumentCommand{\FqwContinuedTableCaption}{m}{%            % объявить команду подписи продолжения обычной таблицы
    \caption*{Продолжение таблицы~#1}%                         % вывести ненумерованную подпись "Продолжение таблицы N"
}                                                              % закрыть определение команды \FqwContinuedTableCaption
\NewDocumentCommand{\FqwContinuedLongTableCaption}{m m}{%      % объявить команду строки продолжения для longtable
    \multicolumn{#1}{@{}l}{Продолжение таблицы~#2}\\[0.5\baselineskip]% объединить заданное число колонок и вывести "Продолжение таблицы N"
}                                                              % закрыть определение команды \FqwContinuedLongTableCaption

\setlist[itemize,1]{                                           % начать настройку маркированного списка первого уровня
    label={--},                                                 % использовать дефис как маркер списка
    leftmargin=1.25cm,                                         % задать левый отступ списка 1,25 см
    itemindent=0pt,                                            % убрать дополнительный отступ первой строки элемента
    labelsep=0.45em,                                           % задать расстояние между маркером и текстом элемента
    topsep=0pt,                                                % убрать вертикальный отступ до и после списка
    itemsep=0pt,                                               % убрать вертикальный интервал между элементами списка
    parsep=0pt                                                 % убрать интервал между абзацами внутри элемента списка
}                                                              % завершить настройку itemize первого уровня
\setlist[enumerate,1]{                                         % начать настройку нумерованного списка первого уровня
    label=\arabic*.,                                           % использовать арабские номера с точкой: 1., 2., 3.
    leftmargin=1.25cm,                                         % задать левый отступ списка 1,25 см
    itemindent=0pt,                                            % убрать дополнительный отступ первой строки элемента
    labelsep=0.45em,                                           % задать расстояние между номером и текстом элемента
    topsep=0pt,                                                % убрать вертикальный отступ до и после списка
    itemsep=0pt,                                               % убрать вертикальный интервал между элементами списка
    parsep=0pt                                                 % убрать интервал между абзацами внутри элемента списка
}                                                              % завершить настройку enumerate первого уровня
\setlist[enumerate,2]{                                         % начать настройку нумерованного списка второго уровня
    label=\asbuk*.,                                            % использовать строчные русские буквы с точкой: а., б., в.
    leftmargin=1.25cm,                                         % задать левый отступ списка 1,25 см
    itemindent=0pt,                                            % убрать дополнительный отступ первой строки элемента
    labelsep=0.45em,                                           % задать расстояние между буквой и текстом элемента
    topsep=0pt,                                                % убрать вертикальный отступ до и после списка
    itemsep=0pt,                                               % убрать вертикальный интервал между элементами списка
    parsep=0pt                                                 % убрать интервал между абзацами внутри элемента списка
}                                                              % завершить настройку enumerate второго уровня

\setlength{\abovedisplayskip}{1\baselineskip}                  % задать отступ перед выключной формулой в одну строку
\setlength{\belowdisplayskip}{1\baselineskip}                  % задать отступ после выключной формулы в одну строку
\setlength{\abovedisplayshortskip}{1\baselineskip}             % задать отступ перед короткой выключной формулой в одну строку
\setlength{\belowdisplayshortskip}{1\baselineskip}             % задать отступ после короткой выключной формулы в одну строку

\AtBeginDocument{%                                             % начать блок команд, выполняемых при начале документа
    \setlength{\abovedisplayskip}{\baselineskip}%              % повторно задать отступ перед выключной формулой после загрузки всех пакетов
    \setlength{\belowdisplayskip}{\baselineskip}%              % повторно задать отступ после выключной формулы после загрузки всех пакетов
    \setlength{\abovedisplayshortskip}{\baselineskip}%         % повторно задать отступ перед короткой выключной формулой
    \setlength{\belowdisplayshortskip}{\baselineskip}%         % повторно задать отступ после короткой выключной формулы
}                                                              % закрыть блок \AtBeginDocument

\newlength{\FqwWhereLabelWidth}                                % объявить длину для ширины метки "где" в пояснении к формуле
\setlength{\FqwWhereLabelWidth}{1.7em}                         % установить ширину метки "где" равной 1,7 em

\newenvironment{FqwWhere}                                      % объявить окружение для блока расшифровки обозначений после формулы
{%                                                             % открыть код, выполняемый при входе в окружение
    \par                                                        % начать новый абзац перед блоком "где"
    \begin{list}{}{%                                           % начать внутренний список без стандартной метки
        \setlength{\leftmargin}{\FqwWhereLabelWidth}%          % задать левое поле списка по ширине метки "где"
        \setlength{\labelwidth}{\FqwWhereLabelWidth}%          % задать ширину области метки
        \setlength{\labelsep}{0pt}%                            % убрать расстояние между меткой и текстом списка
        \setlength{\itemindent}{0pt}%                          % убрать дополнительный отступ элемента списка
        \setlength{\listparindent}{0pt}%                       % убрать абзацный отступ внутри элементов списка
        \setlength{\parsep}{0pt}%                              % убрать интервал между абзацами внутри элемента
        \setlength{\topsep}{0pt}%                              % убрать вертикальный отступ сверху и снизу списка
        \setlength{\partopsep}{0pt}%                           % убрать дополнительный отступ списка после пустой строки
        \setlength{\itemsep}{0pt}%                             % убрать интервал между элементами списка
    }%                                                         % закрыть настройки внутреннего списка
    \item[где\hspace{0.35em}]%                                 % вывести метку "где" с небольшим горизонтальным отступом
}                                                              % закрыть код входа в окружение FqwWhere
{%                                                             % открыть код, выполняемый при выходе из окружения
    \end{list}%                                                % завершить внутренний список
    \par                                                       % завершить абзац после блока пояснений
    \noindent\ignorespacesafterend                             % убрать отступ и игнорировать пробелы после окружения
}                                                              % закрыть код выхода из окружения FqwWhere

\renewcommand{\appendix}{%                                     % переопределить стандартную команду перехода к приложениям
    \par                                                       % завершить текущий абзац перед началом приложений
    \setcounter{section}{0}%                                   % сбросить счетчик разделов для приложений
    \setcounter{subsection}{0}%                                % сбросить счетчик подразделов для приложений
    \setcounter{figure}{0}%                                    % сбросить счетчик рисунков для приложений
    \setcounter{table}{0}%                                     % сбросить счетчик таблиц для приложений
    \setcounter{equation}{0}%                                  % сбросить счетчик формул для приложений
    \gdef\thesection{\Asbuk{section}}%                         % задать буквенную русскую нумерацию приложений: А, Б, В
    \gdef\thesubsection{\thesection.\arabic{subsection}}%      % задать нумерацию подразделов приложений: А.1
    \gdef\thefigure{\thesection.\arabic{figure}}%              % задать нумерацию рисунков в приложениях: А.1
    \gdef\thetable{\thesection.\arabic{table}}%                % задать нумерацию таблиц в приложениях: А.1
    \gdef\theequation{\thesection.\arabic{equation}}%          % задать нумерацию формул в приложениях: А.1
    \gdef\theHsection{appendix.\Asbuk{section}}%               % задать уникальный hyperref-идентификатор приложения
    \gdef\theHsubsection{appendix.\Asbuk{section}.\arabic{subsection}}% задать уникальный hyperref-идентификатор подраздела приложения
    \gdef\theHfigure{appendix.\Asbuk{section}.\arabic{figure}}% % задать уникальный hyperref-идентификатор рисунка приложения
    \gdef\theHtable{appendix.\Asbuk{section}.\arabic{table}}%  % задать уникальный hyperref-идентификатор таблицы приложения
    \gdef\theHequation{appendix.\Asbuk{section}.\arabic{equation}}% задать уникальный hyperref-идентификатор формулы приложения
}                                                              % закрыть переопределение команды \appendix
\newcommand{\FqwAppendix}[1]{%                                 % объявить команду создания основного приложения
    \refstepcounter{section}%                                  % увеличить счетчик приложений и создать ссылочную точку
    \clearpage                                                 % начать приложение с новой страницы
    \begin{center}                                             % начать центрирование заголовка приложения
    \bfseries Приложение \thesection\par                       % вывести жирный заголовок "Приложение А/Б/В"
    \vspace{\baselineskip}                                     % добавить вертикальный отступ в одну строку
    #1                                                         % вывести название приложения, переданное аргументом команды
    \end{center}                                               % завершить центрирование заголовка приложения
    \addcontentsline{toc}{section}{Приложение \thesection\space - #1}% добавить приложение в оглавление
}                                                              % закрыть определение команды \FqwAppendix
\newcommand{\FqwSubAppendix}[1]{%                              % объявить команду создания подраздела внутри приложения
    \refstepcounter{subsection}%                               % увеличить счетчик подразделов приложения и создать ссылочную точку
    \begin{flushright}                                         % начать блок с выравниванием вправо
    Приложение \thesubsection                                  % вывести номер подраздела приложения, например "Приложение А.1"
    \end{flushright}                                           % завершить блок с выравниванием вправо
    \vspace{\baselineskip}                                     % добавить вертикальный отступ в одну строку
    \begin{center}                                             % начать центрирование названия подраздела приложения
    \bfseries #1                                               % вывести название подраздела приложения жирным начертанием
    \end{center}                                               % завершить центрирование названия подраздела приложения
}                                                              % закрыть определение команды \FqwSubAppendix

\newcommand{\FqwSetupBibliography}[1]{%                        % объявить команду настройки библиографии с переданным bib-файлом
    \RequirePackage[                                           % начать подключение biblatex с параметрами
        backend=biber,                                         % использовать biber как backend обработки библиографии
        bibstyle=gost-numeric,                                 % использовать числовой библиографический стиль ГОСТ
        citestyle=numeric-comp,                                % использовать компактный числовой стиль цитирования
        sorting=none,                                          % не сортировать источники, сохранить порядок цитирования
        autolang=other                                         % автоматически учитывать язык записи библиографии
    ]{biblatex}%                                               % подключить пакет biblatex с заданными параметрами
    \addbibresource{#1}%                                       % добавить bib-файл, переданный аргументом команды
    \DeclareFieldFormat{labelnumberwidth}{#1}%                 % настроить формат ширины поля номера в списке литературы
    \defbibheading{bibliography}{\FqwUnnumberedSection{Список использованных источников}}% задать заголовок библиографии как ненумерованный раздел
}                                                              % закрыть определение команды \FqwSetupBibliography

\endinput                                                      % остановить чтение класса и игнорировать все, что находится ниже этой строки
