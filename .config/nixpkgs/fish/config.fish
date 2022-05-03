# setup autojump for fish shell
# begin
#     set --local AUTOJUMP_PATH $HOME/.autojump/share/autojump/autojump.fish
#     if test -e $AUTOJUMP_PATH
#         source $AUTOJUMP_PATH
#     end
# end

# setup any fish plugins
fish_vi_key_bindings
set fish_greeting

# setup starship 
starship init fish | source

# ALIASES
alias config='/home/zach/.nix-profile/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias exa='exa --group-directories-first'
alias l='exa'
alias la='exa -la'
alias a='exa -a'

# alias nf='fdfind . /home/zach/.config -H --changed-within 1d -E Code -E chromium -x /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME ls-files --others {} | sort | uniq'
# alias nfa='fdfind . /home/zach/.config -H --changed-within 1d -E chromium -x /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME ls-files --others {} | uniq | rargs /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add {0}'

