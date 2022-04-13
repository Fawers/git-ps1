# use it like this on .bashrc:
# PS1=${your leading PS1 stuff}\[$(git_ps1)\]${your trailing PS1 stuff}
function git_ps1() {
    local branch=$(git_branch)
    local modifs=$(git_modif_count)

    [[ -z "$branch" ]] && return

    if [[ $modifs =~ 0,0 ]]; then
        printf -v branch "\\001\\x1b[36m\\002%s\\001\\x1b[0m\\002" "$branch"
        #                       ~~~~~~^~ cyan
    else
        printf -v branch "\\001\\x1b[35m\\002%s\\001\\x1b[0m\\002" "$branch"
        #                       ~~~~~~^~ magenta
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

    [[ $additions -gt 0 ]] && printf -v additions "\\001\\x1b[32m\\002%d\\001\\x1b[0m\\002" $additions
    #                                                    ~~~~~~^~ green
    [[ $deletions -gt 0 ]] && printf -v deletions "\\001\\x1b[31m\\002%d\\001\\x1b[0m\\002" $deletions
    #                                                    ~~~~~~^~ red

    printf "%s,%s" $additions $deletions
}
