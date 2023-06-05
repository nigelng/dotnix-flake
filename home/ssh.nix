{ ... }: {
  programs.ssh = {
    enable = true;

    controlMaster = "auto";
    controlPath = "~/.ssh/ssh-control-%r@%h:%p";
    controlPersist = "5m";

    extraConfig = ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };
}
