#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <document-type> <project-name>"
    echo "Document types: article, report"
    exit 1
fi

doc_type=$1
project_name=$2
latex_dir="$HOME/Latex"
project_dir="$latex_dir/$project_name"

# Create project directory
mkdir -p "$project_dir"

# Check if project directory was created successfully
if [ ! -d "$project_dir" ]; then
    echo "Error: Could not create project directory '$project_dir'"
    exit 1
fi

tex_file="$project_dir/$project_name.tex"

# Define templates
article_template='\documentclass{article}
\usepackage[utf8]{inputenc}
\usepackage{amsmath}
\usepackage{amsfonts}
\usepackage{amssymb}
\usepackage{graphicx}
\usepackage{hyperref}

\title{'"$project_name"'}
\author{Your Name}
\date{\today}

\begin{document}

\maketitle

\section{Introduction}

Your introduction here.

\end{document}'

report_template='\documentclass{report}
\usepackage[utf8]{inputenc}
\usepackage{amsmath}
\usepackage{amsfonts}
\usepackage{amssymb}
\usepackage{graphicx}
\usepackage{hyperref}

\title{'"$project_name"'}
\author{Your Name}
\date{\today}

\begin{document}

\maketitle

\chapter{Introduction}

Your introduction here.

\end{document}'

# Create .tex file with appropriate template
case $doc_type in
    article)
        echo "$article_template" > "$tex_file"
        ;;
    report)
        echo "$report_template" > "$tex_file"
        ;;
    *)
        echo "Error: Unknown document type '$doc_type'"
        echo "Supported types: article, report"
        exit 1
        ;;
esac

# Check if .tex file was created successfully
if [ ! -f "$tex_file" ]; then
    echo "Error: Could not create .tex file '$tex_file'"
    exit 1
fi

echo "Successfully created $doc_type template: $tex_file"

# Change to project directory and open with neovim
cd "$project_dir" || exit 1
nvim "$project_name.tex"
