#!/usr/bin/env bash
set -xeuo pipefail

gamescopeArgs=(
    --adaptive-sync # VRR support
    --hdr-enabled
    --rt
    -W 2560
    -H 1440
    -r 60
    -f
    --mangoapp
    --steam
)
steamArgs=(
    -pipewire-dmabuf
    # -tenfoot
)
# mangoConfig=(
#     cpu_temp
#     gpu_temp
#     ram
#     vram
# )
# mangoVars=(
#     MANGOHUD=1
#     MANGOHUD_CONFIG="$(IFS=,; echo "${mangoConfig[*]}")"
# )

# export "${mangoVars[@]}"
exec gamescope "${gamescopeArgs[@]}" -- steam "${steamArgs[@]}"
