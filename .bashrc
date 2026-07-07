#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

export EDITOR=nvim

if [ -f /usr/share/git/git-prompt.sh ]; then
  source /usr/share/git/git-prompt.sh
fi
PS1='\w$(__git_ps1 " (%s)") $ '

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Unzips a file into a directory named after the file
unzip-to-folder() {
  for archive in "$@"; do
    if [[ -f "$archive" ]]; then
      local dirname="${archive%.zip}"

      echo "Extracting '$archive' to '$dirname'..."
      unzip -q "$archive" -d "$dirname"
    else
      echo "Warning: '$archive' is not a valid file." >&2
    fi
  done
}
. "$HOME/.cargo/env"
