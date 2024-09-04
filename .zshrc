export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_RUNTIME_DIR="$HOME/Library/Caches/TemporaryItems"

# (( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# (( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

export EDITOR=nvim
export RIPGREP_CONFIG_PATH=~/.config/ripgreprc

export LANG=en_SE.UTF-8
export LC_CTYPE=en_SE.UTF-8
export LC_COLLATE=en_SE.UTF-8
export LC_CTYPE=en_SE.UTF-8
export LC_MESSAGES=en_SE.UTF-8
export LC_MONETARY=sv_SE.UTF-8
export LC_NUMERIC=sv_SE.UTF-8
export LC_TIME=sv_SE.UTF-8

source ~/.secrets.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

### End of Zinit's installer chunk
#
# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Setup how history is working
{
  bindkey '^p' history-search-backward
  bindkey '^n' history-search-forward

  HISTSIZE=5000
  HISTFILE=~/.zsh_history
  SAVEHIST=$HISTSIZE
  HISTDUP=erase
  setopt appendhistory
  setopt sharehistory
  setopt hist_ignore_space
  setopt hist_ignore_all_dups
  setopt hist_find_no_dups
}


zinit ice wait'0' 
zi for \
    from'gh-r'  \
    as'null' \
    sbin'fzf'   \
  junegunn/fzf

# zinit ice wait'0' 

# zinit ice wait'0' lucid src'asdf.sh' mv'completions/_asdf -> .'
# zinit light asdf-vm/asdf

zinit ice wait'0' lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait'0' lucid
zinit light zsh-users/zsh-completions

alias lisa="mr lisa"
alias lisad="mr lisad"

alias vim=nvim
alias resource="source ~/.zshrc"
# alias ls='n -de'
alias gitlog='git log --date=short --pretty=format:"%C(auto)%h %cd %<(10,trunc)%an %d %s" --all --graph'
alias gitll="watch --color -n 1 'git --no-pager log -n 30 --pretty=format:\"%Cred%h %Creset% %<(10,trunc)%cn %Cgreen% %d %Creset% %s\" --all --graph'"
alias gf='git fetch --prune'
alias gfo='gf && git checkout origin/main'
alias gr="git rev-parse --show-toplevel | xargs cd"
alias c='cd "$(xplr --print-pwd-as-result)"'
alias gs="nvim +Neogit -c \"lua vim.keymap.set('', 'q', '<cmd>qa<cr>', { buffer = true})\""

alias tb="tunnelblickctl"
alias tbc="op item get --otp nufdlnsmdnedtbzxqfnnerpwhq | tr -d '\\n' | pbcopy; tb connect LeanOn"
alias ops="eval \$(op signin)"

alias bankid-prod="ln -shf ~/Library/Application\\ Support/BankID_prod ~/Library/Application\\ Support/BankID"
alias bankid-test="ln -shf ~/Library/Application\\ Support/BankID_test ~/Library/Application\\ Support/BankID"

# TaskWarrior
alias t="task"
alias to="taskopen"
alias ton="to --include=notes"
alias tol="to --include=url"
alias tw="timew"
alias work="t +work"
function tjid {
    t _get "$1.jiraid"
}
export PATH="$PATH:/Users/anton/development/applications/py/bin"

# Add go lang path
export PATH="/Users/anton/.asdf/installs/golang/1.20.4/packages/bin:$PATH"


# Jira
alias jirame='jira issue list -q "project IS NOT EMPTY AND (issue in watchedIssues() or assignee = currentUser()) and status != Closed and status != Resolved"'
alias get-jira-proj='jira project list | fzf | awk "{print \$1}"'
alias jira-c='jira -p $(get-jira-proj) issue create --web'

# Created by `pipx` on 2024-03-17 22:21:20
export PATH="/Users/anton/.local/bin:/Users/anton/.local/bin/go:$PATH"


function redraw-prompt() {
  local f
  for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
    [[ "${+functions[$f]}" == 0 ]] || "$f" &>/dev/null || true
  done
  p10k display -r
}

function _goto-parent() {
    cd ..
    redraw-prompt
}
zvm_define_widget _goto-parent

# The plugin will auto execute this zvm_after_lazy_keybindings function
function zvm_after_init() {
    zvm_bindkey viins '^O' _goto-parent
    zi for \
        https://github.com/junegunn/fzf/raw/master/shell/{'completion','key-bindings'}.zsh


    zvm_bindkey viins '^O' _goto-parent
}

# Enter copy mode
function _wez_enter_copy() {
    wezterm cli send-text --no-paste "i^p"
}

# The plugin will auto execute this zvm_after_lazy_keybindings function
function zvm_after_lazy_keybindings() {
  # Here we define the custom widget
  zvm_define_widget _wez_enter_copy

  # In normal mode, press Ctrl-E to invoke this widget
  zvm_bindkey vicmd 'k' _wez_enter_copy
}


export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


source ~/.zoxide-init.zsh
eval "$(/opt/homebrew/bin/mise activate zsh)"
alias mr="mise run --"


