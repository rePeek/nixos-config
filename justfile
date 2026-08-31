# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

deploy-local:
  nh os switch .

deploy-docker:
  home-manager switch --flake .#root

# not used now
deploy-remote-malayan:
  nixos-rebuild switch --flake .#malayan --target-host root@malayan

deploy-remote-sumatran:
  nixos-rebuild switch --flake .#sumatran --target-host root@sumatran

debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

up package="":
  nix flake update {{package}}

history:
  nh os list

repl:
  nix repl -f flake:nixpkgs

clean:
  nh clean all --keep 5

gc:
  # garbage collect all unused nix store entries
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

secret-edit name:
    cd secrets && agenix -e "{{name}}.age"

secret-rekey:
    cd secrets && sudo agenix --rekey -i /etc/ssh/ssh_host_ed25519_key
