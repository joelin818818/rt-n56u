# PSG1218 固件 v1.3.3 更新说明

基于 Padavan（hanwckf/rt-n56u 分支）为**斐讯 K2（PSG1218，64MB 内存 / 8MB 闪存 / 无 USB）**定制构建。

## 本次更新（含 v1.3.2 全部内容）
- **修复 SmartDNS 53 端口冲突**：开启 SmartDNS 时，旧 dnsmasq 仍占用 53 端口导致 SmartDNS 绑定失败（状态显示「已停止」），而 dnsmasq 又已按 `port=0` 启动，造成全网域名解析失败。现已改为先停止旧 dnsmasq 释放 53 端口、再启动 SmartDNS。
- **支持任意本地端口**：端口为 53 时 SmartDNS 直连接管 DNS；改用非 53 端口时，dnsmasq 自动监听 53 并转发至 SmartDNS（此前改非 53 会导致客户端无法解析）。
- **启动失败自动回退**：若 SmartDNS 启动失败（如端口被占用），dnsmasq 自动回退接管 DNS，不影响正常上网，并在系统日志记录失败原因。
- （v1.3.2）「插件」菜单行与普通菜单项同级样式；SmartDNS 独立配置页、CI 编译缓存。

## 使用说明
- 固件仅适配 PSG1218（斐讯 K2），由 GitHub Actions 自动构建，`.trx` 见本 Release 附件。
- 刷机前请先备份原厂设置；首次刷入建议恢复出厂设置。
- 若从旧版升级且 SmartDNS 曾改过非 53 端口，保存后重启 SmartDNS 服务即可恢复解析。
