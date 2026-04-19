{ pkgs, ... }:
{
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXncD/61ecfc3asOXO9wRIpBaxR2UVZAi1aLqm165aYbOP/sxUdGMXkN0XwcI3suFOhKr5UCYUjsuMEimsS+zs2hNjN1NN6jIRY2Elyo7fOtxFOayw93BQkNHOADS0k8OAmG5lCM4iawVym1NFHkfRRA7mcoDH+eenn77yRCS0bEeO89Jtcwx0G9p3UKsNZIBCLJss+yQ6kSnJQIUMCOaalwj4JL2PZQPJaVEac9HB4ng3AM2WojHyUDILOJDeGv5N1fgUXAaXLHuWIcqONLiyVf1Hzj0ekeDDyKzuQORmI0ffrbeXgndkf26QF/zrc+DTW0rh8pXnXEYl4cNvbAaWCP0fo+1UkVNHsFQPMdIoyCi/m0jokQOBMPoqEW7O0LPT+4znOY9VMOCBgZ+QUyMnwQu8K26P+cjV1S9xmWRaufG2k26yGMHlcV0pvJ5SENQEfVj3BvYSCaDeaCZiOiqTZ+VaH1kG7TEiTOTE71kG99qoJ3/lXRQQr1sSSKrVvt0= github.com"
  ];
  users.users.wanglei = {
    isNormalUser = true;
    description = "wanglei";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    home = "/home/wanglei";
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXncD/61ecfc3asOXO9wRIpBaxR2UVZAi1aLqm165aYbOP/sxUdGMXkN0XwcI3suFOhKr5UCYUjsuMEimsS+zs2hNjN1NN6jIRY2Elyo7fOtxFOayw93BQkNHOADS0k8OAmG5lCM4iawVym1NFHkfRRA7mcoDH+eenn77yRCS0bEeO89Jtcwx0G9p3UKsNZIBCLJss+yQ6kSnJQIUMCOaalwj4JL2PZQPJaVEac9HB4ng3AM2WojHyUDILOJDeGv5N1fgUXAaXLHuWIcqONLiyVf1Hzj0ekeDDyKzuQORmI0ffrbeXgndkf26QF/zrc+DTW0rh8pXnXEYl4cNvbAaWCP0fo+1UkVNHsFQPMdIoyCi/m0jokQOBMPoqEW7O0LPT+4znOY9VMOCBgZ+QUyMnwQu8K26P+cjV1S9xmWRaufG2k26yGMHlcV0pvJ5SENQEfVj3BvYSCaDeaCZiOiqTZ+VaH1kG7TEiTOTE71kG99qoJ3/lXRQQr1sSSKrVvt0= github.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0t0DJhihGqEPY2U07mAtWcUN8CpACj8srO621oK5CRJmYBKID/e8iHpfUPwnq0Kozi2fz8SIh8mmrAiruoqK7kyPUZkGN0nNUjVX4EgyRtU21O/tQmy7ZnyWiOuJNruHNwpamBb/pffK3i62QAJsoT3cyX8l9sRG5Ad6cdCwdJaxExZJc0zq6G/Z/cCqwP6TgL4QuYEO0bPBlLIE9Kf51lQI1deBExEtqJ+ENuFzEAS1dwmWlqV79IB9CquKgQayqt+WmfTqD6PBZcW1SfuMlNQVWXnrDBT2icfJ63zW6v5waLY4A0Vpf7b9D3/3JjXCrA48QaZWOR6bh5EPviSoAATXo6D1r4Wqx5/HP6xHP1/92HrgRAimbBbpZ8HTCReFEsC1pEiVDu6+0L5C2ncG3z9/0DIA0x6YIlWIEsSUP4gI0r5o0LvSVYLcyo/M1Pfoh+JkDB2GXCJXTpEpxR4jvqJxPD/ANpO7l/en9EEWkM2wP2eb2rTapT1HSBur6H08= asen@DESKTOP-MD02KTI"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIyqrlxQC9ZaNsziknJtA83WjVLvXZnyZXgBtH7h/dE wsy@tmp"
    ];
  };
  # given the users in this list the right to specify additional substituters via:
  #    1. `nixConfig.substituers` in `flake.nix`
  #    2. command line args `--options substituers http://xxx`
  nix.settings.trusted-users = [ "wanglei" ];
  nix.settings.allowed-users = [ "wanglei" ];
}
