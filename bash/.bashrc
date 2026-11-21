# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -la'
alias I='doas xbps-install -S'
alias U='I;doas xbps-install -u xbps; doas xbps-install -Su'
alias R='doas xbps-remove -R'
alias Q='doas xbps-query -Rs'
alias grep='grep --color=auto'
alias get_idf='. $HOME/Code/esp/esp-idf/export.sh'
alias get_py='source $HOME/Code/Py_Main/py/bin/activate'
alias vimpy='get_py ; cd $HOME/Code/Py_Main'
alias vimesp='get_idf ; cd $HOME/Code/esp '
# data show
alias data_show='xrandr --output HDMI-1 --same-as eDP-1 --auto'
# Latex automation aliases
alias init_tex='. $HOME/Notes/scripts/init_note.sh'
alias vimtex='. $HOME/.scripts/Latex.sh' # first argument is file type ex: report, article .

alias vimconf='cd $HOME/.config/nvim/ ; nvim '
alias blue='bluetoothctl connect CA:D8:8C:05:72:76'
# Network Manager aliases
alias hotspot='HOTSPOT_PASS="12345678910" ~/.local/bin/hotspot'
alias wifi='nmcli d wifi list'
alias connect='doas nmcli device wifi connect'
#alias Robot='. $HOME/esp/robot_fight/external_control/command.sh'

alias arab='trans -b -no-ansi :ar'

export EDITOR=nvim
#PS1='[\u@\h \W]\$ '
#PS1='\[\e[38;5;250m\][\u@\h \W]     \[\e[0m\] '
# Created by `pipx` on 2025-10-27 09:57:36
export PATH="$PATH:/home/geto/.local/bin"
export PICO_SDK_PATH=~/pico/pico-sdk
export PICO_SDK_PATH=~/pico/pico-sdk
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/opt/gcc-arm-none-eabi-10.3-2021.10/bin:$PATH"

[ -f ~/.scripts/gruvbox.sh ] && . ~/.scripts/gruvbox.sh
