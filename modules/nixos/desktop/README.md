# 桌面 profile

`modules/nixos/desktop/` 只放图形会话相关配置，通过 `custom.desktop.enable` 统一启用。

目录职责：

- `base.nix`：图形会话基础系统服务，例如 dconf、libinput、printing、geoclue2、gvfs 和桌面 udev 规则。
- `gaming.nix`：Steam 和 GameMode，由 `custom.desktop.gaming.enable` 开启。
- `input-method/`：输入法 profile，以及需要注入 Home Manager 用户的默认配置。
- `shell/`：DMS shell、Hyprland session、DMS greeter、字体、Wayland portal、默认应用和 XDG MIME 关联。

底层硬件或系统能力不放在这里：

- 音频栈在 `modules/nixos/features/audio.nix`，DMS shell 会在该 feature 启用时把 `pactl` 加入 user service PATH。
- 蓝牙硬件支持在 `modules/nixos/features/bluetooth.nix`，DMS 通过 BlueZ DBus 提供蓝牙控制界面。
- 网络服务仍由主机网络配置负责，DMS 通过 NetworkManager DBus 提供网络控制界面。
- 图形硬件和 NVIDIA 策略在 `modules/nixos/features/graphics.nix` 和 `modules/nixos/features/nvidia.nix`。
