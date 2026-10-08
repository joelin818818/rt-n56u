# PSG1218 固件 v1.2.0 更新说明

基于 Padavan（hanwckf/rt-n56u 分支）为**斐讯 K2（PSG1218，64MB 内存 / 8MB 闪存 / 无 USB）**定制构建。

## 本次更新
- **smartdns 改为「直接接管 DNS」**：smartdns 默认监听 53 端口（同时绑定 `127.0.0.1` 与 LAN IP），启用时 dnsmasq 仅保留 DHCP（`port=0`），全 LAN 的 DNS 查询直达 smartdns，不再经 dnsmasq 转发；关闭开关时自动恢复 dnsmasq 作 DNS。
  - 默认端口：`53`（与 DHCP 下发的 DNS 端口一致；请勿改为其它值，否则 LAN 设备无法解析）
  - 默认上游：`223.5.5.5:53`、`119.29.29.29:53`
  - 默认缓存：512 条
- **新增「SmartDNS 状态」行**：在「系统管理 → 服务」页实时显示运行状态（PID）、监听地址、上游 DNS、缓存容量。
  - 说明：内置 smartdns（Release33）不暴露缓存命中计数，状态行显示缓存容量而非命中数。

## 升级注意
- 若从旧版（v1.1.0）升级，旧 nvram 可能残留 `smartdns_port=6053`，直连模式下会导致 DNS 失效；请在「系统管理 → 服务」将 smartdns「本地端口」改为 `53` 后保存，或恢复出厂设置。

## 使用说明
- 固件仅适配 PSG1218（斐讯 K2），由 GitHub Actions 自动构建，`.trx` 见本 Release 附件。
- 刷机前请先备份原厂设置；首次刷入建议恢复出厂设置。

---

# PSG1218 固件 v1.1.0 更新说明

基于 Padavan（hanwckf/rt-n56u 分支）为**斐讯 K2（PSG1218，64MB 内存 / 8MB 闪存 / 无 USB）**定制构建。

## 本次更新
- **新增 smartdns 原生管理界面**：在「系统管理 → 服务」页可开关 smartdns，并配置上游 DNS、本地端口、缓存条数；保存后自动联动 dnsmasq，使全 LAN 的 DNS 查询经 smartdns 解析。
  - 默认端口：`6053`
  - 默认上游：`223.5.5.5:53`、`119.29.29.29:53`
  - 默认缓存：512 条
- **关闭 10 个本机用不到的插件**以节省闪存空间：SMBD36、FFMPEG_NEW、XUPNPD、TCPDUMP、SRELAY、DOGCOM、MINIEAP、NJIT_CLIENT、IPERF3、VLMCSD。

## 使用说明
- 固件仅适配 PSG1218（斐讯 K2），由 GitHub Actions 自动构建，`.trx` 见本 Release 附件。
- 刷机前请先备份原厂设置；首次刷入建议恢复出厂设置。
- 开启 smartdns 后，可在「系统管理 → 服务」页面验证配置，并在状态页确认 LAN 设备 DNS 已走 smartdns。
