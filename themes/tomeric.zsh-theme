# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    # Only proceed if there is actually a commit.
    if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
      # Get the last commit.
      last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
      now=`date +%s`
      seconds_since_last_commit=$((now-last_commit))

      # Totals
      MINUTES=$((seconds_since_last_commit / 60))
      HOURS=$((seconds_since_last_commit/3600))
       
      # Sub-hours and sub-minutes
      DAYS=$((seconds_since_last_commit / 86400))
      SUB_HOURS=$((HOURS % 24))
      SUB_MINUTES=$((MINUTES % 60))
      
      if [[ -n $(git status -s 2> /dev/null) ]]; then
        if [ "$MINUTES" -gt 30 ]; then
          COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
        elif [ "$MINUTES" -gt 10 ]; then
          COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
        else
          COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
        fi
      else
        COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
      fi

      if [ "$HOURS" -gt 24 ]; then
        echo "$ZSH_THEME_GIT_TIME_SINCE_COMMIT_PREFIX$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SUFFIX"
      elif [ "$MINUTES" -gt 60 ]; then
        echo "$ZSH_THEME_GIT_TIME_SINCE_COMMIT_PREFIX$COLOR${HOURS}h${SUB_MINUTES}m$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SUFFIX"
      else
        echo "$ZSH_THEME_GIT_TIME_SINCE_COMMIT_PREFIX$COLOR${MINUTES}m$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SUFFIX"
      fi
    else
      COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
      echo "$ZSH_THEME_GIT_TIME_SINCE_COMMIT_PREFIX$COLOR~$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SUFFIX"
    fi
  fi
}

# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(git_time_since_commit)${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

ZSH_THEME_GIT_TIME_SINCE_COMMIT_PREFIX=""
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SUFFIX="%{$fg_bold[blue]%} · %{$fg[red]%}"

ZSH_THEME_GIT_PROMPT_PREFIX="git:("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

#RVM and git settings
if [[ -s ~/.rvm/scripts/rvm ]] ; then 
  RPROMPT='%{$fg_bold[white]%}` ~/.rvm/bin/rvm-prompt | sed "s/\(ruby-\)\(.*\)\(-p[0-9]*\)/\2/" `%{$reset_color%}'
fi

PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
