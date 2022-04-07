# use it like this on .bashrc:
# PS1=${your leading PS1 stuff}\[$(git_ps1)\]${your trailing PS1 stuff}
function git_ps1() {
    local branch=$(git_branch)
    local modifs=$(git_modif_count)

    [[ -z "$branch" ]] && return

    if [[ $modifs =~ 0,0 ]]; then
        printf -v branch "\x1b[36m%s\x1b[0m" "$branch"
        #                 ~~~~~~^~ cyan
    else
        printf -v branch "\x1b[35m%s\x1b[0m" "$branch"
        #                 ~~~~~~^~ magenta
    fi

    printf "(%s:%s)" $branch $modifs
}

function git_branch() {
    git branch --show-current 2> /dev/null
}

function git_modif_count() {
    (git branch --show-current 1> /dev/null 2>&1) || return
    local additions=0
    local deletions=0

    while read add del _; do
        let additions+=$add
        let deletions+=$del
    done < <(git diff --numstat)

    [[ $additions -gt 0 ]] && printf -v additions "\x1b[32m%d\x1b[0m" $additions
    #                                              ~~~~~~^~ green
    [[ $deletions -gt 0 ]] && printf -v deletions "\x1b[31m%d\x1b[0m" $deletions
    #                                              ~~~~~~^~ red

    printf "%s,%s" $additions $deletions
}
