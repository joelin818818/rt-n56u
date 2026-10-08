# PSG1218 固件 v1.3.2 更新说明

基于 Padavan（hanwckf/rt-n56u 分支）为**斐讯 K2（PSG1218，64MB 内存 / 8MB 闪存 / 无 USB）**定制构建。

## 本次更新（含 v1.3.0 / v1.3.1 全部内容）
- **SmartDNS 独立配置页**：将 SmartDNS 设置从「系统管理 → 服务」拆出，新增「插件 → SmartDNS」独立页面（Advanced_SmartDNS_Content.asp），可配置上游 DNS、缓存条数；未开启 smartdns 编译时不生成该页面。
- **左侧菜单修复**：修复 v1.3.0 中左侧菜单全部消失的问题；「插件」菜单行与其它菜单项同级同样式显示。
- **构建提速（工程优化，无功能影响）**：CI 增加编译缓存，仅改 WebUI/rc 等小模块时内核与公共库免重编，GitHub Actions 构建从约 15 分钟降至分钟级。

## 使用说明
- 固件仅适配 PSG1218（斐讯 K2），由 GitHub Actions 自动构建，`.trx` 见本 Release 附件。
- 刷机前请先备份原厂设置；首次刷入建议恢复出厂设置。
