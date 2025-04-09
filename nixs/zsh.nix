{ config, lib, pkgs, programs, ... }:

{
  programs.go.enable = true;
  programs.go.goPath = "projects/go";
  #programs.rbenv.enable = true;
  programs.pyenv.enable = true;

  # ensure aws directory exists
  home.file.".aws/.keep".text = "";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs"; # or vim
    
    history = {
      path = "$HOME/.histfile";
      size = 1000000;
      save = 100000;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    profileExtra = ''
      setopt histfindnodups
      setopt histverify
      setopt incappendhistory
      unsetopt autocd
      unsetopt beep
      unsetopt extendedglob
      unsetopt notify
    '';

    initExtra = ''
      # Customize prompt with VCS branch info
      setopt promptsubst
      autoload -Uz vcs_info
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:git*' formats "(%F{yellow}@%b%f)"
      precmd() {
        vcs_info
      }
      prompt='%F{green}%2/%f''${vcs_info_msg_0_} %(?.%F{#00ff00}√.%F{#ff0000}%?)%f>'

      bindkey "^[[H" beginning-of-line # home key
      bindkey "^[[F" end-of-line # end key
      
      # Autocomplete compatibility for zsh
      autoload -U +X bashcompinit && bashcompinit
      
      if [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
        export BREW_PATH="/opt/homebrew/"
      else
        export BREW_PATH="/usr/local/"
      fi

      # Load AWS CLI completion
      if [ -x "$(command -v aws)" ]; then
        complete -C "$(which aws_completer)" aws
      fi
      # AWS profile helper function
      aws-profile() {
        if [ -z "$1" ]; then
          echo "Current AWS Profile: $AWS_PROFILE"
          return
        fi
        export AWS_PROFILE="$1"
        echo "AWS Profile set to: $AWS_PROFILE"
      }
      
      # List available AWS profiles
      aws-profiles() {
        if [ -f ~/.aws/config ]; then
          grep '\[profile' ~/.aws/config | sed -e 's/\[profile \(.*\)\]/\1/g'
        else
          echo "No AWS config file found."
        fi
      }
      
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

      if command -v direnv &> /dev/null; then
        eval "$(direnv hook zsh)"
      fi

      # Optional: Add a direnv status indicator to your prompt
      # This shows an indicator when direnv is active in your prompt
      _direnv_hook() {
        if [[ -n $DIRENV_DIR ]]; then
          echo -n " %F{cyan}⟨env⟩%f"
        fi
      }
      
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
    
    sessionVariables = {
      PS1 = "%10F%m%f:%11F%1~%f \\$ ";
      CLICOLOR = 1;
      TERM = "xterm-256color";
      EDITOR = "nvim";
      
      # Path additions
      PATH = lib.concatStringsSep ":" [
        "$HOME/bin"
        "/usr/local/sbin"
        "$BREW_PATH/opt/libpq/bin"
        "$BREW_PAth/bin/python3"
        "$PATH"
      ];
      
      # Homebrew configuration
      HOMEBREW_NO_ANALYTICS = 1;
      HOMEBREW_NO_AUTO_UPDATE = 1;
      
      # Docker configuration
      DOCKER_ID_USER = "levinology";
      
      # Ruby/Rails configuration
      OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";

      # quiet direnv log format
      DIRENV_LOG_FORMAT = "";
    };
    
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
      #"update_rbenv" = "brew update && brew upgrade ruby-build";
      #"old_ruby" = "RUBYOPT=\"\"";
      "be" = "bundle exec";
      #"ptest" = "PARALLELIZE_TESTS=true be rails test";
      #"stest" = "PARALLELIZE_TESTS=true be rails test:system";
      "cap" = "be cap";
      "rake" = "be rake";
      "rspec" = "be rspec";
      "guard" = "be guard";
      "killpuma" = "pgrep puma 3 | xargs kill -9";
      "killruby" = "pgrep ruby 3 | xargs kill -9";
      #"flushredis" = "redis-cli flushall";
      
      # VSCode
      #"editvscode" = "vim \"/Users/$(whoami)/Library/Application Support/Code/User/settings.json\"";
      
      # AWS
      "aws-ident" = "aws sts get-caller-identity";
      "aws-unset" = "unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_DEFAULT_REGION && echo 'Cleared AWS Credentials'";

      # direnv
      "da" = "direnv allow";
    };
  };
}
