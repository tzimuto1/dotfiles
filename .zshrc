###############################################################################
# HOME BIN

export PATH="${HOME}/bin:$PATH"

###############################################################################
# SHELL CONFIG

export PROMPT='%F{cyan}%n@%m %~%f %# '

export LSCOLORS=GxFxCxDxBxegedabagaced

# OG TIMEFMT = '%J  %U user %S system %P cpu %*E total'
export TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'

###############################################################################
# JAVA

# export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
# For compilers to find openjdk@11 you may need to set:
# export CPPFLAGS="-I/usr/local/opt/openjdk@11/include"
# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"

###############################################################################
# PYTHON 

###############################################################################
# SUBLIME TEXT

export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

###############################################################################
# EXPORTS I DON'T REMEMBER

export PATH="$HOME/bin/apache-maven-3.6.3/bin:$PATH"
# PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH

###############################################################################
# UNIX ALIASES

alias ls='ls -G'
alias ll='ls -l'
alias cd..='cd ..'

###############################################################################
# ZSHELL

alias rzshrc="source ~/.zshrc"
alias rshrc="source ~/.zshrc"
alias shrc="source ~/.zshrc"

###############################################################################
# EMACS

alias emasc=emacs
alias emac=emacs
alias emas=emacs
alias e=emacs

###############################################################################
# POSTGRES

alias start-pg="postgres -D /usr/local/var/postgres"

###############################################################################
# GIT

tgbranch() {
    linenum=1
    git branch --color=always | while read line; do
        echo "$linenum : $line"
        linenum=$((linenum + 1))
    done

}
tgbranch_no_color() {
    linenum=1
    git branch --color=never | while read line; do
        echo "$linenum : $line"
        linenum=$((linenum + 1))
    done

}
gswitchto() {
    _BRANCH_ID=$1
    if [[ -z $_BRANCH_ID ]]; then
        echo "Branch ID not provided"
        return 1
    fi

    _BRANCH_NAME=`tgbranch_no_color \
        | grep -E "^${_BRANCH_ID} : \** *(.*)" -o \
        | sed "s/${_BRANCH_ID} : \* //g; s/${_BRANCH_ID} : //g;" \
        | grep -E "[a-zA-Z][a-zA-Z0-9/_-]+" -o || ${_BRANCH_ID}`

    git checkout ${_BRANCH_NAME}
}
b() {
    _BRANCH_ID=$1
    if [[ -z $_BRANCH_ID ]]; then
        tgbranch
    else
        gswitchto $_BRANCH_ID
    fi
}
bn() {
    _NEW_BRANCH=$1
    if [[ -z $_NEW_BRANCH ]]; then
        echo "No branch provided"
        return 1
    fi

    git checkout -b ${_NEW_BRANCH}
    if [[ $? != 0 ]]; then
        echo "Error creating a new branch"
        return 1
    fi

    _OLD_BRANCH=`git branch | grep -E "\* " | sed 's/* //g'`
    echo "${_OLD_BRANCH} -> ${_NEW_BRANCH}" >> .branches
}
parent-branch() {
    _CURRENT_BRANCH=`git branch | grep -E "\* " | sed 's/* //g'`
    grep -E "\-> ${_CURRENT_BRANCH}" .branches | grep -E "[a-zA-Z0-9_/-]+ \->" --color=always
}
child-branches() {
    _CURRENT_BRANCH=`git branch | grep -E "\* " | sed 's/* //g'`
    grep -E "${_CURRENT_BRANCH} \->" .branches | grep -E "\-> [a-zA-Z0-9_/-]+" --color=always
}
move2child-branch() {
    _CHILD_ID=$1
    if [[ -z $_CHILD_ID ]]; then
        echo "No child ID provided"
        return 1
    fi

    _CURRENT_BRANCH=`git branch | grep -E "\* " | sed 's/* //g'`
    _CHILD_BRANCH=`grep -E "${_CURRENT_BRANCH} \->" .branches \
        | grep -E "\->" --line-number \
        | grep "${_CHILD_ID}:" \
        | grep -E "\-> [a-zA-Z0-9_/-]+" -o \
        | grep -E "[a-zA-Z][a-zA-Z0-9_/-]+" -o`

    if [[ -z ${_CHILD_BRANCH} ]]; then
        echo "No child branch found"
        return 1
    fi

    git checkout ${_CHILD_BRANCH}
}
alias m2c=move2child-branch
move2parent-branch() {
    _CURRENT_BRANCH=`git branch | grep -E "\* " | sed 's/* //g'`
    _PARENT_BRANCH=`grep -E "\-> ${_CURRENT_BRANCH}" .branches \
        | grep -E "[a-zA-Z0-9_/-]+ \->" -o \
        | sed 's/ ->//g'`

    if [[ -z ${_PARENT_BRANCH} ]]; then
        echo "No parent branch found"
        return 1
    fi

    git checkout ${_PARENT_BRANCH}
}
alias m2p=move2parent-branch
alias gwitchto=gswitchto
alias B=b
alias d="git diff"
alias D=d
alias s="git status"
alias S=s
alias pull="git pull"
alias gpull="git pull"
alias gpush-f="git push --force-with-alias"
alias gpushf=gpush-f
alias gpushforce=gpush-f
alias gtestcommit='git commit -a -m "test commit"'
alias gtestpush="gtestcommit && git push"

gsave-unstagged() {
    file_name=diff-unstagged-$(date "+%Y.%m.%d-%H.%M.%S").diff
    echo "Saving unstagged changes to file ${file_name}"
    git diff > diff-unstaged-${file_name}
}

###############################################################################
# UTILS

sql-to-java() {
    _SQL_STRING=$1
    if [[ -z ${_SQL_STRING} ]]; then
        echo "No SQL string"
        return 1
    fi

    result=`python -  <<END
sql_string="""${_SQL_STRING}"""
java_string="\n".join('+ "' + line + '"'  for line in sql_string.split("\n"))
print java_string.lstrip("+")
END`
    echo ${result}
    echo ${result} | pbcopy
}

###############################################################################
# WORKSPACE DATA STRUCTURES

export WORKDIR="${HOME}/workspace"
export WORKSPACEROOT="${HOME}/workspace"
export TICKETS_ROOT_DIR="/fill/me/in"

typeset -A project_types
project_types=(
    [proja]="Project A"
    [projb]="Project B"
)

typeset -A project_type_to_projects_root_dir
project_type_to_projects_root_dir=(
    [proja]="${WORKSPACEROOT}/proj-a"
    [projb]="${WORKSPACEROOT}/prog-b"
)

typeset -A project_type_to_repo_name
project_type_to_repo_name=(
    [proja]="proj-a"
    [projb]="proj-b"
)

typeset -A project_type_to_remote_repo
project_type_to_remote_repo=(
    [proja]="git@abc.com:vmc/proj-a.git"
    [projb]="git@abc.com:vmc/proj-b.git" 
)

typeset -A project_type_to_jira_project
project_type_to_jira_project=(
    [proja]="PROJECTA"
    [projb]="PROJECTB" 
)

project-types() {
    for k v in "${(@kv)project_types}"; do
        echo "$k => $v"
    done
}

###############################################################################
# WORKSPACE UTILITIES

create-project() {
    _PROJECT_TYPE=$1
    _PROJECT_NAME=$2

    _PROJECTS_PATH="$project_type_to_projects_root_dir[${_PROJECT_TYPE}]/${_PROJECT_NAME}"

    mkdir $_PROJECTS_PATH
    cd $_PROJECTS_PATH
    code-clone $_PROJECT_TYPE
    cdenv $_PROJECT_TYPE $_PROJECT_NAME
}

code-clone() {
    PROJECT_TYPE=$1
    REMOTE_REPO="$project_type_to_remote_repo[$PROJECT_TYPE]"
    git clone ${REMOTE_REPO}
}

lsenv() {
    _PROJECT_TYPE=$1
    if [[ -z $_PROJECT_TYPE ]]; then
        _PROJECTS_DIR=$WORKSPACEROOT
    else
        _PROJECTS_DIR="$project_type_to_projects_root_dir[$_PROJECT_TYPE]"
    fi

    if [[ ! -d $_PROJECTS_DIR ]]; then
        echo "No projects directory to look at"
        return 1
    fi

    ls -l $_PROJECTS_DIR | grep "^d" | grep -E "[a-zA-Z0-9_-]+$" -o | sort
}

cdenv() {
    _PROJECT_TYPE=$1
    _PROJECT_NAME=$2

    # ensure project type and project name are provided
    if [[ -z $_PROJECT_TYPE || -z $_PROJECT_NAME ]]; then
        echo "No project type/name provided"
        return 1
    fi

    _PROJECTS_DIR=$project_type_to_projects_root_dir[$_PROJECT_TYPE]
    _REPO_NAME=$project_type_to_repo_name[$_PROJECT_TYPE]
    
    # check if the project of given type exists
    _WORKDIR="${_PROJECTS_DIR}/${_PROJECT_NAME}/${_REPO_NAME}"
    if [[ ! -d $_WORKDIR ]]; then
        echo "Directory $_WORKDIR doesn't exist"
        return 1
    fi

    export PROJECTROOT=$_WORKDIR
    export PROJECTSROOT=$_PROJECTS_DIR
    export PROJECT_TYPE=$_PROJECT_TYPE
    cdsrc
}

cdroot() {
    _PROJECT_TYPE=$1

    if [[ -z $_PROJECT_TYPE ]]; then
        cd $PROJECTROOT
    else
        _PROJECTS_DIR=$project_type_to_projects_root_dir[$_PROJECT_TYPE]
        cd "${_PROJECTS_DIR}"
    fi
}

cdsrc() {
    _PROJECT_TYPE=$1
    _PROJECT_NAME=$2
    if [[ -z $_PROJECT_TYPE && -z $_PROJECT_NAME ]]; then
        cd $PROJECTROOT
    elif [[ ! -z $_PROJECT_TYPE && ! -z $_PROJECT_NAME ]]; then
        _PROJECTS_DIR=$project_type_to_projects_root_dir[$_PROJECT_TYPE]
        _REPO_NAME=$project_type_to_repo_name[$_PROJECT_TYPE]
        cd "${_PROJECTS_DIR}/${_PROJECT_NAME}/${_REPO_NAME}"
    fi
}

showenv() {
    echo "PROJECTROOT = $PROJECTROOT"
}

tea() {
    _PROJECT_TYPE=$1
    _LOCAL_PROJECT_TICKET_ID=$2

    if [[ -z $_PROJECT_TYPE ]]; then
        echo "No project type provided"
        return 1
    elif [[ -z $_LOCAL_PROJECT_TICKET_ID ]]; then
        echo "No project ticket provided"
        return 1
    fi

    JIRA_PROJECT=$project_type_to_jira_project[$_PROJECT_TYPE]

    if [[ -z $JIRA_PROJECT ]]; then
        echo "Could not find jira project for provided project"
        return 1
    fi

    printf -v PROJECT_TICKET_DIR_PREFIX "%03d-${JIRA_PROJECT}" $_LOCAL_PROJECT_TICKET_ID

    PROJECT_TICKET_DIR=`find $TICKETS_ROOT_DIR -name "${PROJECT_TICKET_DIR_PREFIX}*" | grep .`
    exitcode=$?
    if [[ $exitcode -ne 0 ]]; then
        echo "Find command failed"
        return $exitcode
    fi

    OUTPUTFILE="$PROJECT_TICKET_DIR/output.txt"
    #> ${OUTPUTFILE}
    while IFS= read -r line; do
        echo "$line" | tee -a "$OUTPUTFILE"
    done
}

build() {
    if [[ $PROJECT_TYPE == "proja" ]]; then
    elif [[ $PROJECT_TYPE == "projb" ]]; then
    else
        echo "No known project type. Current: ${PROJECT_TYPE}"
    fi
}
