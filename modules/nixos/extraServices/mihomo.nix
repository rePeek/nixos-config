{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.network.clash;
  runtimeConfig = "/run/mihomo/config.yaml";
in
{

  options.modules.network.clash = {
    enable = mkEnableOption "clash VPN client.";
  };

  config = mkIf cfg.enable {
    age.secrets.flybit-subscription = {
      file = inputs.self + /secrets/flybit-subscription.age;
      owner = "root";
      group = "root";
      mode = "0400";
    };

    systemd.services.mihomo-config = {
      description = "Generate Mihomo runtime config";
      wantedBy = [ "multi-user.target" ];
      before = [ "mihomo.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
              install -d -m 0755 /run/mihomo
              SUB_URL="$(cat ${config.age.secrets.flybit-subscription.path})"

              cat > ${runtimeConfig} <<EOF
        mixed-port: 7890
        allow-lan: true
        bind-address: "*"
        mode: rule
        log-level: info

        external-controller: 0.0.0.0:9090
        secret: "112358"

        profile:
          store-selected: true
          store-fake-ip: true

        dns:
          enable: true
          ipv6: false
          enhanced-mode: fake-ip
          fake-ip-filter:
            - '*.tailscale.com'
            - '*.ts.net'
            - 'controlplane.tailscale.com'
            - 'log.tailscale.com'
            - 'login.tailscale.com'
          nameserver:
            - 1.1.1.1
            - 8.8.8.8

        tun:
          enable: true
          stack: mixed
          dns-hijack:
            - "any:53"
            - "tcp://any:53"
          auto-route: true
          auto-redirect: true
          auto-detect-interface: true
          exclude-interface:
            - tailscale0
          route-exclude-address:
            - 100.64.0.0/10

        proxy-providers:
          mysub:
            type: http
            url: "$SUB_URL"
            interval: 86400
            health-check:
              enable: true
              url: "https://www.gstatic.com/generate_204"
              interval: 300

        proxy-groups:
          - name: PROXY
            type: select
            use:
              - mysub
            proxies:
              - HK-AUTO
              - US-AUTO
              - DIRECT

          - name: AI-US
            type: select
            proxies:
              - US-AUTO
              - PROXY
              - DIRECT

          - name: TG-HK
            type: select
            proxies:
              - HK-AUTO
              - PROXY
              - DIRECT

          - name: HK-AUTO
            type: url-test
            use:
              - mysub
            filter: "(?i)香港|Hong Kong|HK"
            url: "https://www.gstatic.com/generate_204"
            interval: 300

          - name: US-AUTO
            type: url-test
            use:
              - mysub
            filter: "(?i)美国|United States|USA|US"
            url: "https://www.gstatic.com/generate_204"
            interval: 300

        rule-providers:
          private:
            type: http
            behavior: domain
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/private.yaml"
            path: ./ruleset/private.yaml
            interval: 86400

          cn-domain:
            type: http
            behavior: domain
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/cn.yaml"
            path: ./ruleset/cn-domain.yaml
            interval: 86400

          cn-ip:
            type: http
            behavior: ipcidr
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/cn.yaml"
            path: ./ruleset/cn-ip.yaml
            interval: 86400

          telegram-domain:
            type: http
            behavior: domain
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/telegram.yaml"
            path: ./ruleset/telegram-domain.yaml
            interval: 86400

          telegram-ip:
            type: http
            behavior: ipcidr
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/telegram.yaml"
            path: ./ruleset/telegram-ip.yaml
            interval: 86400

          openai:
            type: http
            behavior: classical
            url: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/OpenAI/OpenAI.yaml"
            path: ./ruleset/openai.yaml
            interval: 86400

          claude:
            type: http
            behavior: classical
            url: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/Claude/Claude.yaml"
            path: ./ruleset/claude.yaml
            interval: 86400

          copilot:
            type: http
            behavior: classical
            url: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/Copilot/Copilot.yaml"
            path: ./ruleset/copilot.yaml
            interval: 86400

          bard:
            type: http
            behavior: classical
            url: "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/BardAI/BardAI.yaml"
            path: ./ruleset/bard.yaml
            interval: 86400

        rules:
          - DOMAIN,controlplane.tailscale.com,DIRECT
          - DOMAIN,log.tailscale.com,DIRECT
          - DOMAIN,login.tailscale.com,DIRECT
          - DOMAIN-SUFFIX,tailscale.com,DIRECT
          - DOMAIN-SUFFIX,ts.net,DIRECT
          - DOMAIN-KEYWORD,tailscale,DIRECT
          - IP-CIDR,100.64.0.0/10,DIRECT,no-resolve
          - RULE-SET,private,DIRECT
          - RULE-SET,telegram-domain,TG-HK
          - RULE-SET,telegram-ip,TG-HK
          - RULE-SET,openai,AI-US
          - RULE-SET,claude,AI-US
          - RULE-SET,copilot,AI-US
          - RULE-SET,bard,AI-US
          - RULE-SET,cn-domain,DIRECT
          - RULE-SET,cn-ip,DIRECT
          - MATCH,PROXY
        EOF

              chown root:root ${runtimeConfig}
              chmod 0400 ${runtimeConfig}
      '';
    };

    services.mihomo = {
      enable = true;
      tunMode = true;
      webui = pkgs.metacubexd;
      configFile = runtimeConfig;
    };

    systemd.services.mihomo = {
      after = [ "mihomo-config.service" ];
      wants = [ "mihomo-config.service" ];
    };

    networking.firewall.allowedTCPPorts = [
      7890
      9090
    ];
  };
}
