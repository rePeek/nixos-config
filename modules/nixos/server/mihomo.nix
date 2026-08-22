{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib;
let
  cfg = config.custom.server.mihomo;
  runtimeConfig = "/run/mihomo/config.yaml";
  directUdpRules = concatMapStringsSep "\n  " (
    cidr: "- AND,((SRC-IP-CIDR,${cidr}),(NETWORK,UDP)),DIRECT"
  ) cfg.directUdpSourceCidrs;
in
{

  options.custom.server.mihomo = {
    enable = mkEnableOption "Mihomo client service.";

    directUdpSourceCidrs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Source CIDRs whose UDP traffic bypasses proxy nodes.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.custom.server.agenix.enable;
        message = "custom.server.mihomo.enable requires custom.server.agenix.enable = true;";
      }
    ];

    age.secrets.jms-subscription = {
      file = inputs.self + /secrets/jms-subscription.age;
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
              JMS_URL="$(cat ${config.age.secrets.jms-subscription.path})"

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
            - 'tailfd7184.ts.net'
            - '*.tailfd7184.ts.net'
            - '*.tailscale.com'
            - '*.ts.net'
            - 'controlplane.tailscale.com'
            - 'log.tailscale.com'
            - 'login.tailscale.com'
            # github
            - 'github.com'
            - '*.github.com'
            - '*.githubusercontent.com'
            - '*.githubassets.com'
            - 'raw.githubusercontent.com'
            - 'objects.githubusercontent.com'
            - 'release-assets.githubusercontent.com'
            # Leigod uses resolved addresses directly for UDP/WebSocket traffic.
            - '*.xxghh.biz'
            - '*.nn.com'
          nameserver:
            - 223.5.5.5
            - 1.1.1.1
            - 8.8.8.8

        sniffer:
          enable: true
          parse-pure-ip: true
          sniff:
            HTTP:
              ports:
                - 80
                - 8080-8880
              override-destination: true
            TLS:
              ports:
                - 443
                - 8443
            QUIC:
              ports:
                - 443
                - 8443

        tun:
          enable: true
          stack: system
          dns-hijack:
            - "any:53"
            - "tcp://any:53"
          auto-route: true
          auto-redirect: true
          auto-detect-interface: true
          route-exclude-address:
            - 100.64.0.0/10
            - 10.0.0.0/8
            - 172.16.0.0/12
            - 192.168.0.0/16

        proxy-providers:

          jms_sub:
            type: http
            url: "$JMS_URL"
            interval: 3600
            health-check:
              enable: true
              url: "https://www.gstatic.com/generate_204"
              interval: 300

        proxy-groups:
          - name: PROXY
            type: url-test
            use:
              - jms_sub
            interval: 300
            timeout: 3000
            tolerance: 50
            lazy: false

          - name: JP
            type: url-test
            use:
              - jms_sub
            filter: "(?i)日本|Japan|JP|东京|Tokyo|大阪|Osaka|c2s4"
            url: "https://www.gstatic.com/generate_204"
            interval: 300
            timeout: 3000
            tolerance: 50

          - name: US
            type: url-test
            use:
              - jms_sub
            filter: "(?i)美国|United States|USA|US|JMS"
            url: "https://www.gstatic.com/generate_204"
            interval: 300
            timeout: 3000
            tolerance: 50
            lazy: false

          - name: Steam
            type: select
            proxies:
              - PROXY
              - US
              - JP
              - DIRECT

        rule-providers:
          reject:
            type: http
            behavior: domain
            url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/reject.txt"
            path: ./ruleset/reject.yaml
            interval: 86400

          proxy:
            type: http
            behavior: domain
            url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/proxy.txt"
            path: ./ruleset/proxy.yaml
            interval: 86400

          direct:
            type: http
            behavior: domain
            url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/direct.txt"
            path: ./ruleset/direct.yaml
            interval: 86400

          private:
            type: http
            behavior: domain
            url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/private.txt"
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

          tld-not-cn:
            type: http
            behavior: domain
            url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/tld-not-cn.txt"
            path: ./ruleset/tld-not-cn.yaml
            interval: 86400

          gfw:
            type: http
            behavior: domain
            url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/gfw.txt"
            path: ./ruleset/gfw.yaml
            interval: 86400

          steam:
            type: http
            behavior: classical
            format: yaml
            path: ./ruleset/steam.yaml
            url: https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/release/rule/Clash/Steam/Steam.yaml
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

          microsoft:
            type: http
            behavior: domain
            format: yaml
            path: ./ruleset/microsoft.yaml
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/microsoft.yaml"
            interval: 86400

          grok:
            type: http
            behavior: classical
            url: "https://raw.githubusercontent.com/Accademia/Additional_Rule_For_Clash/main/Grok/Grok.yaml"
            path: ./ruleset/grok.yaml
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

          github:
            type: http
            behavior: domain
            format: text
            url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/github.list"
            path: ./ruleset/github.list
            interval: 86400

          lancidr:
            type: http
            behavior: ipcidr
            url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/lancidr.txt"
            path: ./ruleset/lancidr.yaml
            interval: 86400

        rules:
          - RULE-SET,reject,REJECT

          ${directUdpRules}

          # Steam international store and community
          - DOMAIN,store.steampowered.com,Steam
          - DOMAIN,login.steampowered.com,Steam
          - DOMAIN-SUFFIX,steamstatic.com,Steam
          - DOMAIN-SUFFIX,steamcommunity.com,Steam
          - DOMAIN-SUFFIX,steamusercontent.com,Steam

          - DOMAIN-SUFFIX,jmssub.net,DIRECT
          - RULE-SET,private,DIRECT
          - RULE-SET,direct,DIRECT
          - RULE-SET,lancidr,DIRECT
          - RULE-SET,cn-domain,DIRECT
          - RULE-SET,cn-ip,DIRECT

          - DOMAIN,controlplane.tailscale.com,DIRECT
          - DOMAIN,log.tailscale.com,DIRECT
          - DOMAIN,login.tailscale.com,DIRECT
          - DOMAIN-SUFFIX,tailscale.com,DIRECT
          - DOMAIN-SUFFIX,ts.net,DIRECT
          - DOMAIN-KEYWORD,tailscale,DIRECT
          - IP-CIDR,100.64.0.0/10,DIRECT,no-resolve
          
          - DOMAIN-SUFFIX,steamcontent.com,DIRECT
          - DOMAIN-SUFFIX,steamcdn-a.akamaihd.net,DIRECT
          - DOMAIN-SUFFIX,steampowered.com,DIRECT
          - DOMAIN-SUFFIX,steamgames.com,DIRECT
          - DOMAIN-SUFFIX,steamserver.net,DIRECT
          - RULE-SET,steam,DIRECT

          - DOMAIN-SUFFIX,xxghh.biz,DIRECT
          - DOMAIN-SUFFIX,nn.com,DIRECT
          
          - RULE-SET,github,PROXY

          - RULE-SET,telegram-domain,JP
          - RULE-SET,telegram-ip,JP

          - RULE-SET,grok,US
          - RULE-SET,openai,US
          - RULE-SET,claude,US
          - RULE-SET,copilot,US
          - RULE-SET,bard,US
          
          - RULE-SET,microsoft,DIRECT

          - RULE-SET,proxy,PROXY
          - RULE-SET,tld-not-cn,PROXY
          - RULE-SET,gfw,PROXY

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
      restartTriggers = [
        config.systemd.services.mihomo-config.script # 用当前配置生成服务作为触发器
      ];
    };

    # Route selected LAN UDP traffic before Mihomo's priority-9000 TUN rules.
    systemd.services.mihomo-udp-bypass = mkIf (cfg.directUdpSourceCidrs != [ ]) {
      description = "Bypass Mihomo TUN for selected UDP source networks";
      wantedBy = [ "multi-user.target" ];
      after = [ "mihomo.service" ];
      partOf = [ "mihomo.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        while ${pkgs.iproute2}/bin/ip -4 rule del priority 8999 2>/dev/null; do :; done
        ${concatMapStringsSep "\n" (
          cidr:
          "${pkgs.iproute2}/bin/ip -4 rule add priority 8999 from ${escapeShellArg cidr} ipproto udp lookup main"
        ) cfg.directUdpSourceCidrs}
      '';

      preStop = ''
        while ${pkgs.iproute2}/bin/ip -4 rule del priority 8999 2>/dev/null; do :; done
      '';
    };

    networking.firewall.allowedTCPPorts = [
      7890
      9090
    ];
  };
}
