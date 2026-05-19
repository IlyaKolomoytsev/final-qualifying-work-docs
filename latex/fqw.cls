% Final qualifying work document class.
%
% The class centralizes layout rules for the explanatory note, statement of
% work, and related documents. It is intended for LuaLaTeX or XeLaTeX.
\NeedsTeXFormat{LaTeX2e}[2023-06-01]
\ProvidesExplClass
{fqw}
{2026-05-19}
{0.1.0}
{Final qualifying work class}

\RequirePackage{expl3}
\RequirePackage{l3keys2e}

\ExplSyntaxOn
\bool_new:N \g_fqw_number_within_section_bool
\bool_gset_false:N \g_fqw_number_within_section_bool
\tl_new:N \g_fqw_document_code_tl
\tl_gset:Nn \g_fqw_document_code_tl { ВКРБ-09.03.04-10.19-XX-XX-81 }

\keys_define:nn { fqw / class }
{
    numbers .choice:,
    numbers / continuous .code:n =
        { \bool_gset_false:N \g_fqw_number_within_section_bool },
    numbers / section .code:n =
        { \bool_gset_true:N \g_fqw_number_within_section_bool },
    numbers .initial:n = continuous,
    document-code .tl_gset:N = \g_fqw_document_code_tl,
    document-code .initial:n = ВКРБ-09.03.04-10.19-XX-XX-81,
    unknown .code:n =
        { \PassOptionsToClass { \CurrentOption } { article } }
}
\ProcessKeysOptions { fqw / class }
\ExplSyntaxOff

\LoadClass[14pt,a4paper,oneside]{extarticle}

\RequirePackage{iftex}
\ifPDFTeX
\ClassError{fqw}
{Use LuaLaTeX or XeLaTeX}
{This class uses fontspec for Times New Roman-compatible Cyrillic text.}
\fi

\newlength{\FqwTopMargin}
\newlength{\FqwHeaderDistance}
\newlength{\FqwHeaderHeight}
\newlength{\FqwHeaderSeparation}
\setlength{\FqwTopMargin}{20mm}
\setlength{\FqwHeaderDistance}{12.5mm}
\setlength{\FqwHeaderHeight}{17pt}
\setlength{\FqwHeaderSeparation}{\dimexpr\FqwTopMargin-\FqwHeaderDistance-\FqwHeaderHeight\relax}

\RequirePackage[
    a4paper,
    left=30mm,
    right=15mm,
    top=\FqwTopMargin,
    bottom=20mm,
    headheight=\FqwHeaderHeight,
    headsep=\FqwHeaderSeparation
]{geometry}
\RequirePackage{fontspec}
\RequirePackage[english,russian]{babel}
\RequirePackage{microtype}
\RequirePackage{setspace}
\RequirePackage{indentfirst}
\RequirePackage{ragged2e}
\RequirePackage{titlesec}
\RequirePackage{tocloft}
\RequirePackage{caption}
\RequirePackage{float}
\RequirePackage{graphicx}
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{tabularx}
\RequirePackage{multirow}
\RequirePackage{makecell}
\RequirePackage{amsmath}
\RequirePackage{mathtools}
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{xcolor}
\RequirePackage{csquotes}
\RequirePackage{etoolbox}
\RequirePackage{hyperref}

\defaultfontfeatures{Ligatures=TeX,Scale=MatchLowercase}
\IfFontExistsTF{Times New Roman}
{\setmainfont{Times New Roman}}
{%
    \ClassError{fqw}
    {Times New Roman is not installed}
    {%
        This template requires the system font "Times New Roman".\MessageBreak
        Install it and rerun XeLaTeX/LuaLaTeX.\MessageBreak
        No font fallbacks are allowed for this project.
    }%
}
\IfFontExistsTF{Arial}
{\setsansfont{Arial}}
{
    \IfFontExistsTF{Arimo}
    {\setsansfont{Arimo}}
    {
        \IfFontExistsTF{Liberation Sans}
        {\setsansfont{Liberation Sans}}
        {\setsansfont{DejaVu Sans}}
    }
}
\IfFontExistsTF{Courier New}
{\setmonofont{Courier New}}
{
    \IfFontExistsTF{Cousine}
    {\setmonofont{Cousine}}
    {
        \IfFontExistsTF{Liberation Mono}
        {\setmonofont{Liberation Mono}}
        {\setmonofont{DejaVu Sans Mono}}
    }
}
\IfFontExistsTF{STIX Two Math}
{\RequirePackage{unicode-math}\setmathfont{STIX Two Math}}
{
    \IfFontExistsTF{TeX Gyre Termes Math}
    {\RequirePackage{unicode-math}\setmathfont{TeX Gyre Termes Math}}
    {}
}

\onehalfspacing
\setlength{\parindent}{1.25cm}
\setlength{\parskip}{0pt}
\justifying
\AtBeginDocument{\justifying\color{black}}

\hypersetup{
    unicode=true,
    hidelinks,
    colorlinks=false,
    pdfborder={0 0 0}
}

\pagestyle{fancy}
\fancyhf{}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\ExplSyntaxOn
\cs_new:Npn \fqwDocumentCodeToken { \tl_use:N \g_fqw_document_code_tl }
\ExplSyntaxOff
\newcommand{\FqwDocumentCode}{\fqwDocumentCodeToken}
\newcommand{\FqwEnableDocumentCodeHeader}{%
    \fancyhead[C]{\normalfont\normalsize\FqwDocumentCode}%
    \renewcommand{\headrulewidth}{0pt}%
}
\newcommand{\FqwDisableDocumentCodeHeader}{\fancyhead[C]{}}

\setcounter{secnumdepth}{4}
\setcounter{tocdepth}{3}
\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}
\renewcommand{\theparagraph}{\thesubsubsection.\arabic{paragraph}}

\titleformat{\section}
{\normalfont\bfseries\raggedright}
{\thesection}
{0.7em}
{}
\titleformat{name=\section,numberless}
{\normalfont\bfseries\raggedright}
{}
{0pt}
{}
\titleformat{\subsection}
{\normalfont\bfseries\raggedright}
{\thesubsection}
{0.7em}
{}
\titleformat{\subsubsection}
{\normalfont\bfseries\raggedright}
{\thesubsubsection}
{0.7em}
{}
\titleformat{\paragraph}
{\normalfont\bfseries\raggedright}
{\theparagraph}
{0.7em}
{}

\titlespacing*{\section}{1.25cm}{0pt}{1\baselineskip}
\titlespacing*{\subsection}{1.25cm}{1\baselineskip}{0.5\baselineskip}
\titlespacing*{\subsubsection}{1.25cm}{1\baselineskip}{0.5\baselineskip}
\titlespacing*{\paragraph}{1.25cm}{1\baselineskip}{0.5\baselineskip}

\newcommand{\FqwUnnumberedSection}[1]{%
    \phantomsection%
    \section*{#1}%
    \addcontentsline{toc}{section}{#1}%
}

\renewcommand{\contentsname}{Содержание}
\renewcommand{\cfttoctitlefont}{\normalfont\bfseries}
\renewcommand{\cftaftertoctitle}{\hfill}
\setlength{\cftbeforesecskip}{0pt}
\setlength{\cftbeforesubsecskip}{0pt}
\renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftsecfont}{\normalfont}
\renewcommand{\cftsecpagefont}{\normalfont}
\renewcommand{\cftsubsecfont}{\normalfont}
\renewcommand{\cftsubsecpagefont}{\normalfont}

\DeclareCaptionLabelSeparator{fqwsep}{\space\textendash\space}
\captionsetup{
    font=normalsize,
    labelfont=normalfont,
    labelsep=fqwsep,
    justification=centering,
    singlelinecheck=false,
    skip=0.5\baselineskip
}
\captionsetup[figure]{
    name=Рисунок,
    position=bottom,
    justification=centering,
    singlelinecheck=true
}
\captionsetup[table]{
    name=Таблица,
    position=top,
    labelsep=fqwsep,
    justification=raggedright,
    singlelinecheck=false,
    margin=0pt,
    skip=0.5\baselineskip
}
\setlength{\abovecaptionskip}{0.5\baselineskip}
\setlength{\belowcaptionskip}{0.5\baselineskip}
\setlength{\textfloatsep}{1\baselineskip}
\setlength{\intextsep}{1\baselineskip}
\floatstyle{plain}
\restylefloat{figure}
\floatstyle{plaintop}
\restylefloat{table}

\ExplSyntaxOn
\bool_if:NT \g_fqw_number_within_section_bool
{
    \numberwithin{figure}{section}
    \numberwithin{table}{section}
    \numberwithin{equation}{section}
}
\ExplSyntaxOff

\newenvironment{FqwFigureNote}
{\par\begingroup\fontsize{12pt}{14pt}\selectfont\justifying}
{\par\endgroup}

\AtBeginEnvironment{figure}{\setlength{\parindent}{0pt}}
\AtBeginEnvironment{table}{\setlength{\parindent}{0pt}}
\AtBeginEnvironment{longtable}{\setlength{\parindent}{0pt}\justifying}
\AtBeginEnvironment{tabular}{\fontsize{12pt}{14pt}\selectfont}
\AtBeginEnvironment{tabularx}{\fontsize{12pt}{14pt}\selectfont}
\AtBeginEnvironment{longtable}{\fontsize{12pt}{14pt}\selectfont}

\NewDocumentCommand{\FqwTableCaption}{o m}{%
    \IfNoValueTF{#1}{\caption{#2}}{\caption[#1]{#2}}%
}
\NewDocumentCommand{\FqwContinuedTableCaption}{m}{%
    \caption*{Продолжение таблицы~#1}%
}
\NewDocumentCommand{\FqwContinuedLongTableCaption}{m m}{%
    \multicolumn{#1}{@{}l}{Продолжение таблицы~#2}\\[0.5\baselineskip]%
}

\setlist[itemize,1]{
    label={-},
    leftmargin=1.25cm,
    itemindent=0pt,
    labelsep=0.45em,
    topsep=0pt,
    itemsep=0pt,
    parsep=0pt
}
\setlist[enumerate,1]{
    label=\arabic*.,
    leftmargin=1.25cm,
    itemindent=0pt,
    labelsep=0.45em,
    topsep=0pt,
    itemsep=0pt,
    parsep=0pt
}
\setlist[enumerate,2]{
    label=\asbuk*.,
    leftmargin=1.25cm,
    itemindent=0pt,
    labelsep=0.45em,
    topsep=0pt,
    itemsep=0pt,
    parsep=0pt
}

\setlength{\abovedisplayskip}{1\baselineskip}
\setlength{\belowdisplayskip}{1\baselineskip}
\setlength{\abovedisplayshortskip}{1\baselineskip}
\setlength{\belowdisplayshortskip}{1\baselineskip}

\newlength{\FqwWhereLabelWidth}
\setlength{\FqwWhereLabelWidth}{1.7em}

\newenvironment{FqwWhere}
{%
    \par
    \begin{list}{}{%
        \setlength{\leftmargin}{\FqwWhereLabelWidth}%
        \setlength{\labelwidth}{\FqwWhereLabelWidth}%
        \setlength{\labelsep}{0pt}%
        \setlength{\itemindent}{0pt}%
        \setlength{\listparindent}{0pt}%
        \setlength{\parsep}{0pt}%
        \setlength{\topsep}{0pt}%
        \setlength{\partopsep}{0pt}%
        \setlength{\itemsep}{0pt}%
    }%
    \item[где\hspace{0.35em}]%
}
{%
    \end{list}%
    \par
    \noindent\ignorespacesafterend
}

\renewcommand{\appendix}{%
    \par
    \setcounter{section}{0}%
    \setcounter{subsection}{0}%
    \setcounter{figure}{0}%
    \setcounter{table}{0}%
    \setcounter{equation}{0}%
    \gdef\thesection{\Asbuk{section}}%
    \gdef\thesubsection{\thesection.\arabic{subsection}}%
    \gdef\thefigure{\thesection.\arabic{figure}}%
    \gdef\thetable{\thesection.\arabic{table}}%
    \gdef\theequation{\thesection.\arabic{equation}}%
    \gdef\theHsection{appendix.\Asbuk{section}}%
    \gdef\theHsubsection{appendix.\Asbuk{section}.\arabic{subsection}}%
    \gdef\theHfigure{appendix.\Asbuk{section}.\arabic{figure}}%
    \gdef\theHtable{appendix.\Asbuk{section}.\arabic{table}}%
    \gdef\theHequation{appendix.\Asbuk{section}.\arabic{equation}}%
}
\newcommand{\FqwAppendix}[1]{%
    \refstepcounter{section}%
    \clearpage
    \begin{center}
    \bfseries Приложение \thesection\par
    \vspace{\baselineskip}
    #1
    \end{center}
    \addcontentsline{toc}{section}{Приложение \thesection\space - #1}%
}
\newcommand{\FqwSubAppendix}[1]{%
    \refstepcounter{subsection}%
    \begin{flushright}
    Приложение \thesubsection
    \end{flushright}
    \vspace{\baselineskip}
    \begin{center}
    \bfseries #1
    \end{center}
}

\newcommand{\FqwSetupBibliography}[1]{%
    \RequirePackage[
        backend=biber,
        bibstyle=gost-numeric,
        citestyle=numeric-comp,
        sorting=none,
        autolang=other
    ]{biblatex}%
    \addbibresource{#1}%
    \DeclareFieldFormat{labelnumberwidth}{#1}%
    \defbibheading{bibliography}{\FqwUnnumberedSection{Список использованных источников}}%
}

\endinput
