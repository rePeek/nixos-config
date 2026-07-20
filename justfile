# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

deploy-local:
  nixos-rebuild switch --flake ".#$(hostname -s)" --sudo

deploy-docker:
  home-manager switch --flake .#root
  
deploy-remote:
  nixos-rebuild switch --flake .#rainyun --target-host root@rainyun

debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

up package="":
  nix flake update {{package}}

history:
  nix profile history --profile /nix/var/nix/profiles/system

repl:
  nix repl -f flake:nixpkgs

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

secret-edit name:
    cd secrets && agenix -e "{{name}}.age"

secret-rekey:
    cd secrets && sudo agenix --rekey -i /etc/ssh/ssh_host_ed25519_key
