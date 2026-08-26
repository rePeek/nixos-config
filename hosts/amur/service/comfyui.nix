# Run ComfyUI in a GPU-enabled Docker container on amur.
{
  virtualisation.oci-containers = {
    backend = "docker";

    containers.comfyui = {
      image = "runpod/comfyui:cuda12.8";
      autoStart = true;

      ports = [
        # Only expose ComfyUI to the local host.
        "127.0.0.1:8188:8188"
        "127.0.0.1:8189:8080"

        # Uncomment this when Jupyter access is needed.
        # "127.0.0.1:8888:8888"
      ];

      volumes = [
        # The RunPod image stores its application data under /workspace.
        "/srv/comfyui/workspace:/workspace"
      ];

      extraOptions = [
        # Expose all GPUs through NVIDIA Container Toolkit/CDI.
        "--device=nvidia.com/gpu=all"

        # Some ComfyUI workflows require a larger shared-memory allocation.
        "--shm-size=8g"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/comfyui 0755 root root -"
    "d /srv/comfyui/workspace 0755 root root -"
  ];
}
