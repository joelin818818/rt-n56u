[![CI](https://github.com/joelin818818/rt-n56u/actions/workflows/CI.yml/badge.svg)](https://github.com/joelin818818/rt-n56u/actions/workflows/CI.yml)

# rt-n56u（PSG1218 / 斐讯 K2 定制固件）

本仓库是 [hanwckf/rt-n56u](https://github.com/hanwckf/rt-n56u)（padavan 固件）的一个**单机型定制分支**，只面向 **斐讯 K2（PSG1218）** 构建固件。

- **硬件**：MT7620（580MHz）、64MB 内存、8MB 闪存、无 USB。
- **定位**：家用轻量路由 + SmartDNS 智能解析，去掉一切用不到的插件与服务。

---

## 构建与获取固件

固件由 GitHub Actions 自动构建，**不发布 Release、不打版本号**：

- 推送（或 PR 合入）到 `master` 分支即触发构建；
- 构建成功后，`.trx` 固件以 **Artifacts** 形式提供（在对应 Actions 运行页面的 Artifacts 区下载）；
- 每次构建均基于 `master` 最新提交（HEAD），无需任何 tag。

本地构建：

```shell
# 1. 准备交叉工具链（在 toolchain-mipsel 目录下）
cd toolchain-mipsel
sh dl_toolchain.sh

# 2. 编译（机型固定为 PSG1218）
cd ../trunk
fakeroot ./build_firmware_modify PSG1218
# 产物在 trunk/images/*.trx
```

本地依赖（Ubuntu/Debian，与 CI 环境一致）：

```shell
sudo apt-get update
sudo apt-get install -y build-essential libncurses5-dev libssl-dev zlib1g-dev \
  unzip flex bison texinfo gperf autoconf automake libtool-bin python3-docutils \
  gettext autopoint pkg-config fakeroot u-boot-tools
```

> 修改机型配置（一般不改）：`trunk/configs/templates/PSG1218.config`。

---

## 本分支相对上游的定制

| 定制项 | 说明 |
|---|---|
| **SmartDNS 接管 DNS** | 内置 smartdns，默认监听 53（绑定 `127.0.0.1` 与 LAN IP）。启用时 dnsmasq 仅作 DHCP（`port=0`），全 LAN 的 DNS 查询直达 smartdns，少一跳。 |
| **SmartDNS 管理页面** | 「插件」一级菜单下的 SmartDNS 页：配置上游 DNS（支持动态增删、内置国内外常见 DNS 预设，含 UDP/TCP/DoH/DoT 及非标端口如 UDP 5353、TCP 5300）、缓存条数、测速模式（三个独立框：`ping`/`tcp:80`/`tcp:443`/`无`，按顺序触发并自动去重）、双栈 IP 优选、缓存最小 TTL；并实时显示运行状态 / 监听地址 / 上游 / 缓存容量。 |
| **WebUI 主题** | 采用 ribbon 主题（`trunk/user/www/n56u_ribbon_fixed`）。 |

---

## PSG1218.config 关键开关

针对 8MB 闪存的取舍（注释含各选项体积代价，单位约 MB）：

- **已关闭（省空间）**：USB、全部文件系统（NTFS/exFAT/EXT/FAT/XFS/FUSE）、SMB/FTP/NFS、Transmission/Aria2/DLNA/UPnP、softether/vlmcsd/minieap/dogcom 等校园/企业拨号与媒体插件、QoS/IMQ/IFB、USB 摄像头/声卡/串口等内核模块。
- **已开启（路由核心）**：IPv6 + NAPT66、IPSet、EAP-PEAP、OpenSSH + SFTP、curl、SmartDNS，以及一组命令行调试工具（htop/nano/mtr/socat/ttyd/lrzsz）。
- 语言仅含简体中文（已关其他 locale）。

如需进一步缩小体积，只能从「已开启」的大头里取舍（openssl/openssh/curl、调试工具、IPv6），但这些属功能项，本分支默认保留。

---

## 刷机提示

- 刷机前备份原厂 / 旧版设置；首次刷入建议恢复出厂设置。
- 若从旧版升级，请在「系统管理 → 服务」确认 smartdns「本地端口」为 `53`（旧版残留的 6053 会导致直连模式 DNS 失效）。

---

## 致谢 / 上游

- 固件基础：[hanwckf/rt-n56u](https://github.com/hanwckf/rt-n56u)（padavan）
- SmartDNS：[pymumu/smartdns](https://github.com/pymumu/smartdns)
- WebUI 汉化字典参考：[gorden5566/padavan](https://github.com/gorden5566/padavan)

本仓库仅供学习自用，不包含任何保证与支持。刷机有风险，后果自负。
