# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

deploy-brain:
  nixos-rebuild switch --flake .#brain-holder --sudo


deploy-docker:
  home-manager switch --flake .#root --show-trace --verbose
  
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

up:
  nix flake update

fmt:
  treefmt .

# Update specific input
# usage: make upp i=home-manager
upp:
  nix flake update $(i)

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

############################################################################
#
#  agenix secrets management
#
############################################################################

# Edit a secret (creates if doesn't exist)
# usage: just secret-edit name=my-api-key
secret-edit:
  agenix -e secrets/$(name).age

# Rekey all secrets (e.g., after adding a new public key)
secret-rekey:
  agenix --rekey

# View a secret (decrypts and shows content)
# usage: just secret-view name=my-api-key
secret-view:
  agenix -d secrets/$(name).age
