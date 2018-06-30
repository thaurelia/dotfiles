set fish_greeting

set -gx EDITOR /usr/local/bin/code
set -gx PATH $PATH /usr/local/sbin /opt/metasploit-framework/bin
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"

function proj
    if not test -d /Volumes/projects
        hdiutil attach -quiet ~/Documents/projects.dmg
    end
    cd /Volumes/projects
end

# Custom shell prompt based on Robyrussel
function fish_prompt
    set -l __last_command_exit_status $status

    if not set -q -g __fish_robbyrussell_functions_defined
        set -g __fish_robbyrussell_functions_defined
        function _git_branch_name
            set -l branch (git symbolic-ref --quiet HEAD ^/dev/null)
            if set -q branch[1]
                echo (string replace -r '^refs/heads/' '' $branch)
            else
                echo (git rev-parse --short HEAD ^/dev/null)
            end
        end

        function _is_git_dirty
            echo (git status -s --ignore-submodules=dirty ^/dev/null)
        end

        function _is_git_repo
            type -q git
            or return 1
            git status -s >/dev/null ^/dev/null
        end

        function _hg_branch_name
            echo (hg branch ^/dev/null)
        end

        function _is_hg_dirty
            echo (hg status -mard ^/dev/null)
        end

        function _is_hg_repo
            type -q hg
            or return 1
            hg summary >/dev/null ^/dev/null
        end

        function _repo_branch_name
            eval "_$argv[1]_branch_name"
        end

        function _is_repo_dirty
            eval "_is_$argv[1]_dirty"
        end

        function _repo_type
            if _is_hg_repo
                echo 'hg'
            else if _is_git_repo
                echo 'git'
            end
        end
    end

    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l green (set_color -o green)
    set -l blue (set_color -o blue)
    set -l normal (set_color normal)

    set -l arrow_color "$green"
    set -l arrow "$arrow_color➜ "
    if test $__last_command_exit_status != 0
        set arrow_color "$red"
        set arrow "$arrow_color($__last_command_exit_status) ➜ "
    end

    set user "$green$USER"
    if test "$USER" = 'root'
        set user "$red$USER"
        set arrow "$arrow_color# "
    end

    set -l cwd $cyan(basename (prompt_pwd))

    set -l repo_type (_repo_type)
    if [ $repo_type ]
        set -l repo_branch $red(_repo_branch_name $repo_type)
        set repo_info "$blue $repo_type:($repo_branch$blue)"

        if [ (_is_repo_dirty $repo_type) ]
            set -l dirty "$yellow ✘"
            set repo_info "$repo_info$dirty"
        else
            set -l clean "$green ✔"
            set repo_info "$repo_info$clean"
        end
    end
    if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end

    set -l virtual_env ''
    if test $VIRTUAL_ENV
        set venv_name (basename $VIRTUAL_ENV)
        set virtual_env "$yellow ($venv_name)"
    end

    if not set -q __fish_prompt_hostname
        set short_hostname (hostname|cut -d . -f 1)
        set -g __fish_prompt_hostname "$green$short_hostname"
    end
    echo -s $user $normal '@' $__fish_prompt_hostname ' ' $cwd $virtual_env $repo_info
    echo -s $arrow ' ' $normal
end
