# 加密秘密管理指南 (agenix)

本文档说明如何在 NixOS 配置中使用 agenix 管理加密的秘密文件（如 API 密钥、密码等）。

## 1. 生成 age 密钥对

首先，为需要访问秘密的用户生成 age 密钥对：

```bash
# 生成新的 age 密钥对
age-keygen -o ~/.config/age/key.txt

# 或者使用现有的 SSH 密钥
ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/age/key.txt
```

查看公钥：
```bash
cat ~/.config/age/key.txt | grep "public key:" | cut -d: -f2 | xargs
```

记录输出的公钥（以 `age1...` 开头）。

## 2. 配置 secrets.nix

编辑 `secrets/secrets.nix`，在 `age.secrets` 中添加你的秘密定义：

```nix
age.secrets = {
  my-api-key = {
    file = ./my-api-key.age;
    publicKeys = [ "age1your-public-key-here" ]; # 替换为你的公钥
    # 可选参数
    mode = "0400";    # 文件权限
    owner = "asen";   # 文件所有者（仅 NixOS）
    group = "users";  # 文件所属组（仅 NixOS）
  };
};
```

## 3. 创建加密的秘密文件

使用 agenix 编辑加密文件：

```bash
# 在项目根目录执行
agenix -e secrets/my-api-key.age
```

这将打开编辑器，输入你的秘密内容（如 API 密钥），保存并关闭。

## 4. 在配置中使用解密后的文件

在 NixOS 或 home-manager 配置中，通过以下路径访问解密后的文件：

```nix
# 在 NixOS 配置中
config.age.secrets.my-api-key.path

# 在 home-manager 配置中
config.age.secrets.my-api-key.path
```

示例：在 home-manager 配置中设置环境变量：

```nix
{ config, ... }:
{
  # 在 home-manager 配置中
  home.sessionVariables = {
    API_KEY_FILE = config.age.secrets.my-api-key.path;
  };

  # 或者直接读取内容到环境变量
  home.sessionVariables = let
    apiKey = builtins.readFile config.age.secrets.my-api-key.path;
  in {
    API_KEY = apiKey;
  };
}
```

## 5. 应用配置

```bash
# 对于 NixOS 主机（如 brain-holder）
just deploy-brain

# 对于 home-manager 配置（如 nixos-in-docker）
just deploy-docker
```

## 6. 重要注意事项

1. **不要提交明文秘密**：`.gitignore` 已配置为忽略常见的秘密文件扩展名（如 `.txt`、`.json`、`.env`），但 `.age` 文件（加密的）应该提交。

2. **密钥安全**：`~/.config/age/key.txt` 是私钥文件，请妥善保管，不要分享。

3. **多用户访问**：如果需要多个用户访问同一个秘密，将他们的公钥都添加到 `publicKeys` 列表中。

4. **权限设置**：根据秘密的敏感程度设置适当的文件权限（`mode`）。

## 7. 容器环境特别说明

如果你在 Docker 容器中使用 home-manager 配置（如 `nixos-in-docker`），请注意：

1. **私钥位置**：容器中的 root 用户私钥路径为 `/root/.config/age/key.txt`。
2. **复制私钥**：需要将主机的 age 私钥复制到容器中，或为容器生成独立的密钥对。
3. **公钥配置**：确保容器的公钥已添加到 `secrets.nix` 的 `publicKeys` 列表中。

示例：在容器中生成密钥对：
```bash
# 进入容器后执行
age-keygen -o /root/.config/age/key.txt
```

## 8. 故障排除

**错误：`secret 'my-api-key' has no defined public keys`**
- 确保在 `secrets.nix` 中为每个秘密定义了 `publicKeys` 列表。

**错误：无法解密**
- 确保使用的私钥对应的公钥已添加到 `publicKeys` 列表中。
- 检查私钥文件路径是否正确（默认 `~/.config/age/key.txt`）。

**home-manager 中无法访问**
- 确保在 home-manager 配置中导入了 `secrets.nix`（已在 `root.nix` 中配置）。
- 确保 home-manager 用户有权限读取私钥文件。

## 9. 扩展阅读

- [agenix GitHub 仓库](https://github.com/ryantm/agenix)
- [age 加密工具](https://github.com/FiloSottile/age)
- [NixOS Wiki: agenix](https://nixos.wiki/wiki/Agenix)