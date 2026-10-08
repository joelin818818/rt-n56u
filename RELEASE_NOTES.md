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
