{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    git

    # 基础系统工具（NixOS 默认已包含 procps、util-linux、iproute2 等）
    procps
    util-linux
    file
    fd
    ripgrep
    jq
    unzip
  ];
}
