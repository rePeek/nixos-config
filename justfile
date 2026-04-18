# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

deploy-brain:
  nixos-rebuild switch --flake .#brain-holder --sudo

deploy-server:
  nixos-rebuild switch --flake .#home-server --sudo

deploy-docker:
  home-manager switch --flake .#root
  
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

up package="":
  nix flake update {{package}}

fmt:
  treefmt .

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
    cd secrets && agenix --rekey
