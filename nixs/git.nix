{ config, ... }: {
  programs.git = {
    enable = true;
    ignores = [ "*~" ".DS_Store" ".direnv" ".env" ".rgignore" ".swo" ".swp" ];
    settings = {
      user = {
        name = "Jeff Levin";
        email = "jeff@levinology.com";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSifg2hVNreHw8bqshGDhzONFURBSViI4fIkR+e2rl6";
      };
      core = {
        autocrlf = "input";
        editor = "nvim";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        ff = "only";
      };
      push = {
        autoSetupRemote = true;
      };
      # Added from your gitconfig
      url = {
        "git@gitlab.com:" = {
          insteadOf = "https://gitlab.com/";
        };
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
      # SourceTree settings removed
      gpg = {
        format = "ssh";
      };
      "gpg.ssh" = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
      };
      commit = {
        gpgsign = true;
      };
      alias = {
        amend = "commit --amend";
        fap = "fetch --all --prune";
        pushu = "push -u origin HEAD";
        ci = "commit";
        co = "checkout";
        di = "diff";
        dc = "diff --cached";
        addp = "add -p";
        shoe = "show";
        st = "status";
        unch = "checkout --";
        br = "checkout";
        bra = "branch -a";
        newbr = "checkout -b";
        rmbr = "branch -d";
        mvbr = "branch -m";
        cleanbr = "!git remote prune origin && git co master && git branch --merged | grep -v '*' | xargs -n 1 git branch -d && git co -";
        as = "update-index --assume-unchanged";
        nas = "update-index --no-assume-unchanged";
        al = "!git config --get-regexp 'alias.*' | colrm 1 6 | sed 's/[ ]/ = /'";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
