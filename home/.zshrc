# ~/.zshrc  (rice: 43PR's zsh + Caelestia colours + LeyzS fetch)
# Your own additions go in ~/.zshrc.local so re-running the installer never wipes them.

export PATH="$HOME/.local/bin:$HOME/opt/go/bin:$PATH"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt AUTO_CD INTERACTIVE_COMMENTS NO_BEEP

# Completion: Tab menu, case-insensitive
autoload -Uz compinit && compinit -d "$HOME/.cache/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{8}-- %d --%f'

# Keys: emacs style, Up/Down search history by what you already typed
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Aliases
if command -v eza >/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lah --icons --git --group-directories-first'
    alias la='eza -a --icons'
    alias lt='eza --tree --level=2 --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -lah --color=auto'
    alias la='ls -A --color=auto'
fi
alias grep='grep --color=auto'
alias update='sudo dnf upgrade --refresh'

# Prompt
if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
else
    PROMPT='%F{blue}%~%f %F{magenta}❯%f '
fi

# Greeting (not inside the HUD panels or nested shells)
if [[ -o interactive && -z "$RICE_NO_FETCH" && $SHLVL -le 1 ]] && command -v fastfetch >/dev/null; then
    fastfetch
fi

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Autosuggestions (grey ghost text, accept with →) and syntax highlighting (keep last)
for f in /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
         /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh; do
    [ -r "$f" ] && { source "$f"; break; }
done
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
for f in /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
         /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
    [ -r "$f" ] && { source "$f"; break; }
done
export PATH=$PATH:$HOME/go/bin
