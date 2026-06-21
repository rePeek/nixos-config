# 桌面 profile

`modules/nixos/desktop/` 只放图形会话相关配置，通过 `custom.desktop.enable` 统一启用。

`modules/nixos/desktop/default.nix` 负责桌面主机的默认能力选择。桌面基础能力放在 `core/` 中固定启用；没有对应硬件或不想启用时，主机使用 NixOS 原生选项配合 `lib.mkForce false` 覆盖，例如关闭蓝牙可设置 `hardware.bluetooth.enable = lib.mkForce false`。

目录职责：

- `core/`：图形、音频、蓝牙、输入法、字体、基础桌面工具和 Wayland portal。
- `shell/`：DMS shell、Hyprland session 和 DMS greeter。
- `avatar.nix`、`gaming.nix`、`theme.nix`、`terminal.nix`：需要系统集成或需要用户默认值的桌面能力。

默认应用、用户应用配置、Firefox 代理、壁纸和 XDG MIME 关联在 `modules/home-manager/desktop/` 中应用。系统侧桌面模块只保留确实需要 NixOS 集成的部分，例如 AccountsService 头像、fcitx5 系统输入法和 Steam/GameMode。主机级用户差异通过 `custom.home.users.<username>` 传给 Home Manager。

底层硬件或系统能力按适用范围放置：

- 音频栈在 `modules/nixos/desktop/core/audio.nix`，DMS shell 可通过 `pactl` 控制音频。
- 蓝牙硬件支持在 `modules/nixos/desktop/core/bluetooth.nix`，DMS 通过 BlueZ DBus 提供蓝牙控制界面。
- 网络服务仍由主机网络配置负责，DMS 通过 NetworkManager DBus 提供网络控制界面。
- 图形基础栈在 `modules/nixos/desktop/core/graphics.nix`，NVIDIA 策略仍在 `modules/nixos/desktop/nvidia.nix`。
