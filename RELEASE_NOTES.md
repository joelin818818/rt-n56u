# PSG1218 固件 v1.3.1 更新说明

基于 Padavan（hanwckf/rt-n56u 分支）为**斐讯 K2（PSG1218，64MB 内存 / 8MB 闪存 / 无 USB）**定制构建。

## 本次更新
- **修复左侧菜单不显示**：修复 v1.3.0 中 WebUI 左侧菜单（含「插件」分组与 SmartDNS 入口）全部消失的问题。
- 保留 v1.3.0 全部功能：SmartDNS 独立配置页（「插件 → SmartDNS」）、CI 编译缓存提速。

## 使用说明
- 固件仅适配 PSG1218（斐讯 K2），由 GitHub Actions 自动构建，`.trx` 见本 Release 附件。
- 刷机前请先备份原厂设置；首次刷入建议恢复出厂设置。
