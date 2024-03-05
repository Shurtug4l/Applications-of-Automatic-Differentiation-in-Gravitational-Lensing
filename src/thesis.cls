%*******************************************************
%%% Thesis for Astrophysics & Cosmology thesis
%%% Alma Mater Studiorum - University of Bologna
%%% Author: Simone La Porta
%%% Created: March 2024
%*******************************************************

%*******************************************************
\NeedsTeXFormat{LaTeX2e}[1995/12/01]    % LaTeX2e is required
\ProvidesClass{thesis}[2024 Master Thesis (Simone La Porta)]

\RequirePackage{xcolor}


%%%%%%%%%%%%%%% PROCESS OPTIONS %%%%%%%%%%%%%%%
% set boolean: draft or final
\newif\ifmrdraft\mrdraftfalse   % draft mode: (def=false)
\newif\ifthumb\thumbfalse       % thumb index main matter (def=false)
\newif\ifthumbpre\thumbprefalse % thumb index front matter (def=false)
\newif\ifprint\printfalse       % print mode: +5mm inner margin (def=false)

% declare options
\DeclareOption{draft}{\mrdrafttrue}     % draft mode true
\DeclareOption{final}{\mrdraftfalse}    % draft mode false
\DeclareOption{thumbmain}{\thumbtrue}   % thumb indexes true
\DeclareOption{print}{\printtrue}       % print mode true

\ProcessOptions\relax


%%%%%%%%%%%%%%% LOAD REPORT CLASS %%%%%%%%%%%%%%%
\LoadClass[11pt, oneside, openright]{report}


%%%%%%%%%%%%%%% SET UP GEOMETRY PACKAGE %%%%%%%%%%%%%%%
% \geometryoptions macro defined as [twoside] if draft mode is not enabled or defined as [twoside,driver=none] if draft mode is enabled
\edef\geometryoptions{[%twoside%
\ifmrdraft
    ,driver=none
\fi]}


% Load geometry package with options
\expandafter\RequirePackage\geometryoptions{geometry}
\geometry{
    paperwidth  = 210mm,    % paper width (A4)
    paperheight = 297mm,    % paper height (A4)
    top         =  40mm,    % top margin
    bottom      =  45mm,    % bottom margin
    inner       =  35mm,    % inner margin
    outer       =  30mm,    % outer margin
    headsep     =   7mm,    % header separation
    headheight  =  14.5pt,  % header height
    footskip    =  50pt     % footer skip
}


%%%%%%%%%%%%%%% THUMB INDEX DEFINITIONS %%%%%%%%%%%%%%%
\RequirePackage{tikz}
\usetikzlibrary{calc}

\newcounter{letternum}              % chapter counter
\newlength{\thumbheight}            % height of the thumb index tags
\newlength{\thumbtopmargin}         % margin between top of page and first thumb index tag
\newlength{\thumbsep}               % separation between edge of page and start of semi-circle

% print version
\ifprint
\setlength{\thumbsep}{9mm}          % add 5mm inner margin
\setlength{\thumbheight}{15mm}      % thumb height
\setlength{\thumbtopmargin}{13mm}   % thumb top margin

\else

% electronic version
\setlength{\thumbsep}{4mm}          % separation between edge of page and start of semi-circle
\setlength{\thumbheight}{15mm}      % height of the thumb index tags
\setlength{\thumbtopmargin}{13mm}   % margin between top of page and first thumb index tag
\fi

% visual thumb indexes on the edges of even-numbered pages
\newcommand{\thumbeven}[1]{%
    \begin{tikzpicture}[remember picture, overlay]
            \fill[thumbcolor] ($%
            (current page.north west)-%
            (0,{\thumbtopmargin+(\value{letternum}-1)*\thumbheight})$) -- ++ (\thumbsep,0) arc (90:-90:0.5*\thumbheight) -- ++(-\thumbsep,0);
            \node[text=white,font=\sffamily\bfseries] at ($%
                (current page.north west)-%
                (-0.15*\thumbheight-\thumbsep,{\thumbtopmargin+(\value{letternum}-0.5)*\thumbheight})%
                $) {#1};
    \end{tikzpicture}}

% visual thumb indexes on the edges of odd-numbered pages
\newcommand{\thumbodd}[1]{
    \begin{tikzpicture}[remember picture, overlay]
            \fill[thumbcolor] ($%
            (current page.north east)-%
            (0,{\thumbtopmargin+(\value{letternum}-1)*\thumbheight})$) -- ++ (-\thumbsep,0) arc (90:270:0.5*\thumbheight) -- ++(\thumbsep,0);
            \node[text=white,font=\sffamily\bfseries] at ($%
                (current page.north east)-%
                (0.15*\thumbheight+\thumbsep,{\thumbtopmargin+(\value{letternum}-0.5)*\thumbheight})%
                $) {#1};
    \end{tikzpicture}}

% Conditional: chapter starred (def=true)
\newif\ifisstarredchapter\isstarredchaptertrue

% If starred chapter is false create thumb index on even/odd pages
\newcommand{\evenpageletterthumb}[1]{%
    \ifisstarredchapter
    \ifthumbpre
        \thumbeven{}
    \fi
    \else
        \thumbeven{#1}
    \fi
}
\newcommand{\oddpageletterthumb}[1]{%
    \ifisstarredchapter
        \ifthumbpre
            \thumbodd{}
        \fi
    \else
        \thumbodd{#1}
    \fi
}


%%%%%%%%%%%%%%% DEFINE HEADERS/FOOTERS %%%%%%%%%%%%%%%
\RequirePackage{fancyhdr}
\RequirePackage{etoolbox}

% Increment thumb numbers
\apptocmd{\@chapter}{\ifthumb\stepcounter{letternum}\fi}{}{}
\apptocmd{\@schapter}{\ifthumb\ifthumbpre\stepcounter{letternum}\fi\fi}{}{}

% Set headers and footers
\pagestyle{fancy}
\fancyhf{}

% Page number centered in the footer
\fancyfoot[C]{\thepage}

% Chapter and section in the header + thumb index
\ifthumb
    \fancyhead[LO]{\slshape\footnotesize\rightmark\oddpageletterthumb{\thechapter}}
    \fancyhead[RO]{\slshape\footnotesize\leftmark}
    \fancyhead[RE]{\slshape\footnotesize\leftmark\evenpageletterthumb{\thechapter}}
    \fancyhead[LE]{\slshape\footnotesize\rightmark}
\else
    \fancyhead[L]{\slshape\footnotesize\rightmark}
    \fancyhead[R]{\slshape\footnotesize\leftmark}
\fi

% Remove header on plain pages
\fancypagestyle{plain}{%
\fancyhead{}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0pt}
}


% Ensure that chapters or sections start on a new right-hand (odd) page. It inserts a blank page.
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
\hbox{}
\vspace{\fill}
\thispagestyle{empty}
\newpage
\if@twocolumn\hbox{}\newpage\fi\fi\fi}


%%%%%%%%%%%%%%% CHAPTER LAYOUT %%%%%%%%%%%%%%%
\RequirePackage[T1]{fontenc}
\RequirePackage{titlesec}
\def\@chapnumfont{              % define font for chapter number
    \usefont{T1}{qbk}{b}{n}       % choose Gyre Bonum, bold, normal shape
    \fontsize{90}{100}            % font size 90pt, baselineskip 100pt
    \selectfont                   % activate font
}

\def\@partnumfont{%             % define font for part number
    \usefont{T1}{qbk}{m}{n}%      % choose Gyre Bonum, normal, normal shape
    \fontsize{40}{40}%            % font size 40pt, baselineskip 40pt
    \selectfont%                  % activate font
}

% Formatting of chapter titles
\titleformat{\chapter}[display]
{\filleft\bfseries}
{\filleft\vspace*{-65mm}\@chapnumfont\textcolor{titlecolor}{\thechapter}}
{-24pt}
{\Huge\textcolor{titlecolor}}

\titleformat{\part}[display]
{\centering\bfseries}
{\@partnumfont\textcolor{titlecolor}{\thepart}}
{24pt}
{\Huge\textcolor{titlecolor}}


%%%%%%%%%%%%%%% CHANGE FORMAT FIGURE CAPTIONS %%%%%%%%%%%%%%%
\RequirePackage[format=plain, labelsep=period, labelfont=bf]{caption}