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
      #brain-holder
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXncD/61ecfc3asOXO9wRIpBaxR2UVZAi1aLqm165aYbOP/sxUdGMXkN0XwcI3suFOhKr5UCYUjsuMEimsS+zs2hNjN1NN6jIRY2Elyo7fOtxFOayw93BQkNHOADS0k8OAmG5lCM4iawVym1NFHkfRRA7mcoDH+eenn77yRCS0bEeO89Jtcwx0G9p3UKsNZIBCLJss+yQ6kSnJQIUMCOaalwj4JL2PZQPJaVEac9HB4ng3AM2WojHyUDILOJDeGv5N1fgUXAaXLHuWIcqONLiyVf1Hzj0ekeDDyKzuQORmI0ffrbeXgndkf26QF/zrc+DTW0rh8pXnXEYl4cNvbAaWCP0fo+1UkVNHsFQPMdIoyCi/m0jokQOBMPoqEW7O0LPT+4znOY9VMOCBgZ+QUyMnwQu8K26P+cjV1S9xmWRaufG2k26yGMHlcV0pvJ5SENQEfVj3BvYSCaDeaCZiOiqTZ+VaH1kG7TEiTOTE71kG99qoJ3/lXRQQr1sSSKrVvt0= github.com"
      # blue
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0t0DJhihGqEPY2U07mAtWcUN8CpACj8srO621oK5CRJmYBKID/e8iHpfUPwnq0Kozi2fz8SIh8mmrAiruoqK7kyPUZkGN0nNUjVX4EgyRtU21O/tQmy7ZnyWiOuJNruHNwpamBb/pffK3i62QAJsoT3cyX8l9sRG5Ad6cdCwdJaxExZJc0zq6G/Z/cCqwP6TgL4QuYEO0bPBlLIE9Kf51lQI1deBExEtqJ+ENuFzEAS1dwmWlqV79IB9CquKgQayqt+WmfTqD6PBZcW1SfuMlNQVWXnrDBT2icfJ63zW6v5waLY4A0Vpf7b9D3/3JjXCrA48QaZWOR6bh5EPviSoAATXo6D1r4Wqx5/HP6xHP1/92HrgRAimbBbpZ8HTCReFEsC1pEiVDu6+0L5C2ncG3z9/0DIA0x6YIlWIEsSUP4gI0r5o0LvSVYLcyo/M1Pfoh+JkDB2GXCJXTpEpxR4jvqJxPD/ANpO7l/en9EEWkM2wP2eb2rTapT1HSBur6H08= asen@DESKTOP-MD02KTI"
      # home-server
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJfEGaOVh0XWCou3GPcsB9mfwTyow9RftRs8Q+SAaPiH senxlin@gmail.com"
      # blue-tmp
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIyqrlxQC9ZaNsziknJtA83WjVLvXZnyZXgBtH7h/dE wsy@tmp"
      # work(may change in feature)
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8xxMOxMAUKz4QZ3h2VqjNeTjd2btVKXB6qN3aMWSyAbCvkOwrCB/1HCUvWDM+3ocsxlTQWfldX38PdypBllEU9ITi5aeh5pR/oicbIhN0ELg2+Q6yJ59+4clbXrZhjFHLak1OT7laBlvlynBCnbe2uSyAawgVdy6T3d7b1iRw1e1gwlQJB8ju0suPQeWgMxFNLzXRAgHUZ/q2Rfj6niTBd/4bkDkNdSNJ6WG0UHlHwzFkflLDGuJ3DIvY9Cr7CmijoX4Ntq+V4lc5Igpr+FxQYEPT9a6i+dmebrPcp88rYO55ZhbOzvr7XJIazfQudHheWMOQ6HnzV1ZBygAUi6n1RfwQRr2GJZLlNHnO3X1nMrBjJd2gJgK2zyl+7uS2tsRU0kLZfmfr4h4D+3bUspq4eR8v/3hnBg2LeRf/WnSgF7qE9I1Wms0Pvk3KsNc7YvUamyhF48J+xkCbv9JVi9sYiREPlMrZbGh7+X8T5kf1cGnyZFP8Z1pS7DMGxJ9D/Pk= root@work"
    ];
  };
  # given the users in this list the right to specify additional substituters via:
  #    1. `nixConfig.substituers` in `flake.nix`
  #    2. command line args `--options substituers http://xxx`
  nix.settings.trusted-users = [ "wanglei" ];
  nix.settings.allowed-users = [ "wanglei" ];
}
