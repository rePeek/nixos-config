# Bottles defaults for every desktop Home Manager role.
{
  lib,
  pkgs,
  ...
}:
let
  bottles = pkgs.bottles.override {
    extraPkgs = _pkgs: [ pkgs.wineWow64Packages.stagingFull ];

    bottles-unwrapped = pkgs.bottles-unwrapped.override {
      python3Packages = pkgs.python3Packages.overrideScope (
        _final: prev: {
          # patool's MIME tests currently disagree with the file database result
          # for compressed tar archives; this does not affect Bottles at runtime.
          patool = prev.patool.overridePythonAttrs (_: {
            doCheck = false;
          });
        }
      );
    };
  };
in
{
  config = {
    home.packages = [ bottles ];
  };
}
