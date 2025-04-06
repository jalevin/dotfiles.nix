{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    
    history = {
      path = "$HOME/.histfile";
      size = 1000000;
      save = 100000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      share = true;
    };
    
    shellInit = ''
      # Setup CPU detection
      if [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
        export BREW_PATH="/opt/homebrew/"
      else
        export BREW_PATH="/usr/local/"
      fi
    '';
    
    interactiveShellInit = ''
      # ZSH options
      setopt hist_find_no_dups
      setopt hist_verify
      setopt inc_append_history
      
      unsetopt autocd beep extendedglob notify
      
      # Key bindings
      bindkey -e
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
      
      # Enabling and setting git info in prompt
      autoload -Uz vcs_info
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:git*' formats "(%F{yellow}@%b%f)"
      precmd() {
        vcs_info
      }
      
      # Enable substitution in the prompt
      setopt prompt_subst
      
      # Autocomplete
      autoload -Uz compinit && compinit
      autoload -U +X bashcompinit && bashcompinit
      
      # For terraform completion
      if [ -x "$(command -v terraform)" ]; then
        complete -o nospace -C $(which terraform) terraform
      fi
      
      # Load AWS completions if they exist
      if [ -f ''${BREW_PATH}/share/zsh/site-functions/aws_zsh_completer.sh ]; then
        source ''${BREW_PATH}/share/zsh/site-functions/aws_zsh_completer.sh
      fi
      
      # iTerm2 integration if present
      if [ -e "$HOME/.iterm2_shell_integration.zsh" ]; then
        source "$HOME/.iterm2_shell_integration.zsh"
      fi
      
      # Load 1Password plugins if they exist
      if [ -f "$HOME/.config/op/plugins.sh" ]; then
        source "$HOME/.config/op/plugins.sh"
      fi
      
      # Load gcloud completion if it exists
      if [ -f '/Users/jeff/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then
        source '/Users/jeff/Downloads/google-cloud-sdk/completion.zsh.inc'
      fi
    '';
    
    profileExtra = ''
      # pyenv initialization
      if [ -x "$(command -v pyenv)" ]; then
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
      fi
      
      # rbenv initialization
      if [ -x "$(command -v rbenv)" ]; then
        eval "$(rbenv init -)"
      fi
    '';
    
    # Your prompt configuration
    promptInit = ''
      prompt='%F{green}%2/%f''${vcs_info_msg_0_} %(?.%F{#00ff00}√.%F{#ff0000}%?)%f>'
    '';
    
    # Environment variables
    envExtra = ''
      # Path additions
      export PATH="$HOME/bin:$PATH"
      export PATH="$HOME/.rbenv/shims:/usr/local/sbin:$PATH"
      export PATH="''${BREW_PATH}/opt/libpq/bin:$PATH"
      export PATH="''${BREW_PATH}/bin/python3:$PATH"
      export PATH="''${BREW_PATH}/opt/awscli:$PATH"
      
      # Go configuration
      export GOPATH="$HOME/projects/go"
      export PATH="$PATH:$GOPATH/bin"
      
      # pnpm configuration
      export PNPM_HOME="/Users/jeff/Library/pnpm"
      if [[ ! ":$PATH:" == *":$PNPM_HOME:"* ]]; then
        export PATH="$PNPM_HOME:$PATH"
      fi
      
      # General environment variables
      export PS1="%10F%m%f:%11F%1~%f \$ "
      export CLICOLOR=1
      export TERM=xterm-256color
      export EDITOR="nvim"
      
      # Homebrew configuration
      export HOMEBREW_NO_ANALYTICS=1
      export HOMEBREW_NO_AUTO_UPDATE=1
      
      # Docker configuration
      export DOCKER_ID_USER="levinology"
      
      # Ruby/Rails configuration
      export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
    '';
    
    # Your aliases
    shellAliases = {
      # Git aliases
      "git_loc" = "git ls-files | while read f; do git blame -w -M -C -C --line-porcelain \"$f\" | grep -I '^author '; done | sort -f | uniq -ic | sort -n";
      "gdiff" = "git --no-pager diff";
      "g" = "git";
      "gm" = "git commit";
      "gmm" = "git checkout $(git_main_branch) && git pull && git checkout - && git merge main";
      "gback" = "git checkout -";
      
      # System aliases
      "reload" = "source ~/.zshrc";
      "rl" = "source ~/.zshrc";
      "cat" = "bat";
      "top" = "htop";
      "grep" = "rg";
      "ogrep" = "grep";
      "less" = "less -N";
      "vim" = "nvim";
      "vi" = "vi";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "cpu_usage" = "watch \"ps -Ao user,uid,comm,pid,pcpu,tty -r | head -n 6\"";
      "sudo" = "sudo env PATH=\"$PATH\"";
      "export_brew" = "brew leaves > brews_all.txt";
      "whitespace" = "/bin/cat -e -t -v";
      "projects" = "cd ~/projects";
      
      # Docker aliases
      "cleandocker" = "docker system prune -f";
      
      # Ruby/Rails aliases
      "update_rbenv" = "brew update && brew upgrade ruby-build";
      "old_ruby" = "RUBYOPT=\"\"";
      "be" = "bundle exec";
      "ptest" = "PARALLELIZE_TESTS=true be rails test";
      "stest" = "PARALLELIZE_TESTS=true be rails test:system";
      "cap" = "be cap";
      "rake" = "be rake";
      "rspec" = "be rspec";
      "guard" = "be guard";
      "killpuma" = "pgrep puma 3 | xargs kill -9";
      "killruby" = "pgrep ruby 3 | xargs kill -9";
      "flushredis" = "redis-cli flushall";
      
      # VSCode
      "editvscode" = "vim \"/Users/$(whoami)/Library/Application Support/Code/User/settings.json\"";
      
      # AWS
      "aws-ident" = "aws sts get-caller-identity";
      "aws-unset" = "unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_DEFAULT_REGION && echo 'Cleared AWS Credentials'";
    };
    
    # Custom functions
    initExtra = ''
      # Go doc functions
      godoc() {
        go doc -u "$@" | bat -l go
      }
      
      gosrc() {
        go doc -u -src "$@" | bat -l go
      }
      
      # Serve current directory function
      serve() {
        if [ -n "$1" ]; then
          ruby -run -ehttpd . -p$1
        else
          ruby -run -ehttpd . -p8080
        fi
      }
      
      # Pretty print JSON
      pj() {
        echo $1 | jq
      }
    '';
  };
}
