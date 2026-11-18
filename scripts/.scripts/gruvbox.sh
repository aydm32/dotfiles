#!/usr/bin/env bash
# ~/.config/bash/gruvbox.sh
# Gruvbox prompt + terminal niceties for bash + st + Void.
# Source from ~/.bashrc:
#   [ -f ~/.config/bash/gruvbox.sh ] && . ~/.config/bash/gruvbox.sh

# ---------- Gruvbox palette (256-color) ----------
GB_FG=223 GB_GRAY=244 GB_DGRAY=245
GB_RED=167 GB_GREEN=142 GB_YELLOW=214
GB_BLUE=109 GB_PURPLE=175 GB_AQUA=108 GB_ORANGE=208

PROMPT_DIRTRIM=2 # shorten long paths to "…/a/b"

# ---------- git segment ----------
__gb_git() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local br
  br=$(git symbolic-ref --short HEAD 2>/dev/null ||
    git rev-parse --short HEAD 2>/dev/null)
  [ -z "$br" ] && return

  local dirty=""
  git diff --quiet --ignore-submodules -- 2>/dev/null || dirty=" ●"
  git diff --cached --quiet --ignore-submodules -- 2>/dev/null || dirty=" ●"

  local ab="" counts
  counts=$(git rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null) && {
    local behind ahead
    read -r behind ahead <<<"$counts"
    [ "$ahead" -gt 0 ] 2>/dev/null && ab+="↑${ahead}"
    [ "$behind" -gt 0 ] 2>/dev/null && ab+="↓${behind}"
    [ -n "$ab" ] && ab=" ${ab}"
  }

  printf '%s%s%s' "$br" "$dirty" "$ab"
}

# ---------- prompt builder ----------
__gb_prompt() {
  local exit=$? # must be first: captures last command's status

  local reset='\[\e[0m\]'
  local cG='\[\e[38;5;'"$GB_GRAY"'m\]'
  local cDG='\[\e[38;5;'"$GB_DGRAY"'m\]'
  local cU='\[\e[38;5;'"$GB_GREEN"'m\]'
  local cH='\[\e[38;5;'"$GB_ORANGE"'m\]'
  local cP='\[\e[38;5;'"$GB_BLUE"'m\]'
  local cB='\[\e[38;5;'"$GB_PURPLE"'m\]'
  local cT='\[\e[38;5;'"$GB_AQUA"'m\]'
  local cOK='\[\e[38;5;'"$GB_GREEN"'m\]'
  local cER='\[\e[38;5;'"$GB_RED"'m\]'

  local arrow="$cOK"
  [ "$exit" -ne 0 ] && arrow="$cER"

  local git_seg="" br
  br=$(__gb_git)
  [ -n "$br" ] && git_seg=" ${cDG}─${cB}[${br}]"

  # Layout:
  #   ╭─ geto@void ─ ~/Code/esp ─ [main ●↑1] ─ 14:02
  #   ╰─❯
  PS1="\n${cDG}╭─${cU}\u${cG}@${cH}\h${cDG}─${cP}\w${git_seg}${cDG}─${cT}\A${reset}\n${cDG}╰─${arrow}❯${reset} "
}

PROMPT_COMMAND=__gb_prompt

# ---------- terminal / shell extras ----------
export COLORTERM=truecolor
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend checkwinsize

# Gruvbox LS_COLORS (dirs blue, execs green, archives red, media purple…)
export LS_COLORS="di=38;5;${GB_BLUE}:ln=38;5;${GB_AQUA}:so=38;5;${GB_PURPLE}:pi=38;5;${GB_YELLOW}:ex=38;5;${GB_GREEN}:bd=38;5;${GB_YELLOW}:cd=38;5;${GB_YELLOW}:su=38;5;${GB_RED}:sg=38;5;${GB_RED}:tw=38;5;${GB_BLUE}:ow=38;5;${GB_BLUE}:*.tar=38;5;${GB_RED}:*.tgz=38;5;${GB_RED}:*.zip=38;5;${GB_RED}:*.gz=38;5;${GB_RED}:*.xz=38;5;${GB_RED}:*.bz2=38;5;${GB_RED}:*.7z=38;5;${GB_RED}:*.jpg=38;5;${GB_PURPLE}:*.jpeg=38;5;${GB_PURPLE}:*.png=38;5;${GB_PURPLE}:*.gif=38;5;${GB_PURPLE}:*.svg=38;5;${GB_PURPLE}:*.pdf=38;5;${GB_RED}:*.mp3=38;5;${GB_AQUA}:*.mp4=38;5;${GB_AQUA}:*.mkv=38;5;${GB_AQUA}:*.c=38;5;${GB_BLUE}:*.h=38;5;${GB_BLUE}:*.cpp=38;5;${GB_BLUE}:*.hpp=38;5;${GB_BLUE}:*.py=38;5;${GB_YELLOW}:*.rs=38;5;${GB_ORANGE}:*.go=38;5;${GB_AQUA}:*.js=38;5;${GB_YELLOW}:*.ts=38;5;${GB_BLUE}:*.lua=38;5;${GB_BLUE}:*.md=38;5;${GB_FG}:*.toml=38;5;${GB_GRAY}:*.yml=38;5;${GB_GRAY}:*.yaml=38;5;${GB_GRAY}"

# Colorized man pages (works in st via less)
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;35m'
