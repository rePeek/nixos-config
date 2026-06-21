# 桌面 profile

`modules/nixos/desktop/` 只放图形会话相关配置，通过 `custom.desktop.enable` 统一启用。

目录职责：

- `core/`：图形会话基础系统服务、字体和 Wayland portal。
- `components/`：输入法、默认终端、壁纸、头像和 gaming 的系统侧 profile 与默认值。
- `shell/`：DMS shell、Hyprland session 和 DMS greeter。

默认应用、用户应用配置、Firefox 代理和 XDG MIME 关联在 `modules/home-manager/desktop/defaults/` 中应用。系统侧 `components/` 只保留确实需要 NixOS 集成的部分，例如 AccountsService 头像、fcitx5 系统输入法、Steam/GameMode 和壁纸目录校验。主机级用户差异通过 `custom.home.users.<username>` 传给 Home Manager。

底层硬件或系统能力不放在这里：

- 音频栈在 `modules/nixos/features/audio.nix`，DMS shell 会在该 feature 启用时把 `pactl` 加入 user service PATH。
- 蓝牙硬件支持在 `modules/nixos/features/bluetooth.nix`，DMS 通过 BlueZ DBus 提供蓝牙控制界面。
- 网络服务仍由主机网络配置负责，DMS 通过 NetworkManager DBus 提供网络控制界面。
- 图形硬件和 NVIDIA 策略在 `modules/nixos/features/graphics.nix` 和 `modules/nixos/features/nvidia.nix`。
