# 主机改名 blue-10700 → bengal 后续 TODO

仓库内改名已完成（分支 `rename/blue-10700-to-bengal`，dry-build 通过）。以下为仓库外 / 运行时需手动完成的事项。

- [ ] 部署生效：`just deploy-local`（hostname 真正变成 `bengal` 需 `switch`）
- [ ] Tailscale 控制平面：机器在 tailnet 里现注册名仍为 `blue-10700`，`networking.hosts` 已改成 `bengal`，需在 Tailscale 管理端把机器 rename 成 `bengal`，或部署后 `sudo tailscale up --hostname=bengal`，否则静态解析名与实际机器名对不上
- [ ] 可选：更新机器实际 host key 的 comment（不影响功能）：`sudo ssh-keygen -c -f /etc/ssh/ssh_host_ed25519_key -C 'root@bengal'`
