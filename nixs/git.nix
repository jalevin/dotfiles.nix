{ config, ... }: {
  programs.git = {
    enable = true;
    userName = "Jeff Levin";
    userEmail = "jeff@levinology.com";
    ignores = [ "*~" ".DS_Store" ".direnv" ".env" ".rgignore" ".swo" ".swp" ];
    extraConfig = {
      core = { 
        autocrlf = "input";
        editor = "nvim";
      };
      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSifg2hVNreHw8bqshGDhzONFURBSViI4fIkR+e2rl6";
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
    };
    delta = { 
      enable = true; 
    };
    aliases = {
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
}
