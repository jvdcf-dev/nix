# ──────────────────╮ 
# Zsh configuration │
# ──────────────────╯
# @jvdcf
# Inspired from Dreams of Autonomy (https://www.youtube.com/watch?v=ud7YxC33Z3w)

# Locale
# =========================================================================
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8
LC_CTYPE=C.UTF-8
LANG=en_US.UTF-8 

# Zinit
# =========================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Oh My Posh 
# =========================================================================
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/ohmyposh.toml)"

# Zsh Syntax Highlighting
# =========================================================================
zinit light zsh-users/zsh-syntax-highlighting

# Zsh Completion
# =========================================================================
zinit light zsh-users/zsh-completions
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zinit cdreplay -q

# Zsh Auto Suggestions
# =========================================================================
zinit light zsh-users/zsh-autosuggestions
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Fuzzy Finder
# =========================================================================
zinit light Aloxaf/fzf-tab
eval "$(fzf --zsh)"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Zoxide
# =========================================================================
eval "$(zoxide init --cmd cd zsh)"
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Oh My Zsh Plugins 
# =========================================================================
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Aliases 
# =========================================================================
alias ls='ls --color'

# Paths 
# =========================================================================
export PATH="/usr/bin/flutter/bin:$PATH"
export PATH="~/.cargo/bin:$PATH"

# Autostart programs
# =========================================================================
fastfetch --config $HOME/.config/fastfetch/config.jsonc

