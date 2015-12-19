alias xyz='$HOME/tools/xyzzy/xyzzycli.exe'
alias vim='$HOME/tools/vim/vim.exe'
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias l.='ls -d .*'

function gvim() {
    if [ $# -eq 0 ]; then
        $HOME/tools/vim/gvim.exe &
    else
        $HOME/tools/vim/gvim.exe --remote-tab-silent $* &
    fi
}

