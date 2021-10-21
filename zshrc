# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit promptinit
compinit
# End of lines added by compinstall

# Key bindings
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" history-beginning-search-forward

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey ";5C" forward-word
bindkey ";5D" backward-word

bindkey "^R" history-incremental-search-backward
bindkey "^K" kill-line

# End Of key bindings


promptinit
prompt adam1
alias ls='ls --color'
alias ll='ls -l'
alias l='ls --color'

source ~/tools/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/tools/zsh/mvn-in-colors/mvn-in-colors.zsh
alias mvn=mvn-in-colors
source ~/tools/zsh/zsh-git-prompt/zshrc.sh

alias sbt8='PATH="/usr/lib/jvm/java-8-openjdk/jre/bin/:$PATH" sbt'

RPROMPT='$(git_super_status)'

M2_HOME="/usr/local/apache-maven/apache-maven-3.3.9"
M2=$M2_HOME/bin
export SBT_OPTS="${SBT_OPTS} -Dsbt.jse.engineType=Node -Dsbt.jse.command=$(which node)"

# Enable 4 Threads in compression
export XZ_OPT="-T 4"

path+=$M2
path+=~/.local/bin
path+=~/.local/share/coursier/bin

fpath=(~/.zsh/functions $fpath)

alias debian='docker run -it --rm --user "`id -u`:`id -g`" -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -v /etc/shadow:/etc/shadow:ro -v "$HOME":"$HOME" -v /tmp/.X11-unix:/tmp/.X11-unix --device /dev/snd -v /dev/shm:/dev/shm -e QT_GRAPHICSSYSTEM="native" -e DOCKERIZED=true -e DISPLAY=$DISPLAY -e DEBFULLNAME="`git config user.name`" -e DEBEMAIL="`git config user.email`" -w "`pwd`" jpthomasset/debian-builder:jessie zsh'
alias clemacs='emacs -nw -q --load ~/.emacs.d/vimacs-init.el'
alias vimacs='clemacs'
alias vemacs='clemacs'


function chrome-remote() {
    SOCKSSRV="janine.avencall.com"
    if [ -n "$2" ]; then
        SOCKSSRV=$2
    fi
    if [ -n "$1" ]; then
        chromium --temp-profile --no-default-browser-check --no-first-run --proxy-server="socks5://$SOCKSSRV:$1" --host-resolver-rules="MAP * ~NOTFOUND,EXCLUDE ${SOCKSSRV},EXCLUDE www.google.com,EXCLUDE gstatic.com,EXCLUDE 127.0.0.1,EXCLUDE 127.0.0.53"
    else
        echo "Socks port argument missing, try 'chrome-remote 42040' to use port 42040"
    fi

}



function gitc() {
	local ticketid=$(git branch --show-current 2>/dev/null| cut -d'_' -d'-' -f1)
	if [[ -z "$ticketid" ]]; then
		echo "Error: No branch name found"
		return
	fi
	if [[ ! "$ticketid" = <-> ]]; then
		echo "Error: Impossible to detect ticket number"
		return
	fi
	
	local comment=$*
	if [[  -z  "$comment"  ]]; then
		echo "Error: Missing commit message"
	    return
	fi
	local message="${ticketid} - ${comment}"
	#echo "message: \e[33m'${message}'\e[0m"
	git commit -m $message
}
