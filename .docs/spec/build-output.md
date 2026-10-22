# 构建输出契约

## 输出根
`.target/` —— 唯一输出根：cargo 编译缓存（`[build] target-dir`，根 `.cargo/config.toml` 路由，跨上游更新存活）+ 交付区。

## 产物子树
- `.target/`（release/debug 编译缓存，稳定编译缓存，跨 task 复用，不做常规 clean）
- `.target/.distribution/app/` —— 最新一次可运行构建（唯一声明形态，见下）
- `installer/`、`zip/`：本项目无下游分发形态，**不创建**（治理：无对应产物不建空目录）
- `.target/check-nebula.log` 等：临时验证输出，任务结束删除

## release / package 入口
`pwsh src/scripts/build-windows-product.ps1 -TargetDirectory K:\Projects\dev\pebrel\.target`（上游脚本；`CARGO_TARGET_DIR` 环境变量覆盖，产物仍进根 `.target/release/`；构建 `pebrel.exe` + `pebrel-hook.exe`，`--locked --features nebula/gpui-shell`）

## 最低产品验收
不可完全后台执行：窗口几何往返、标签字体观感（004/008 卡人工清单）需要前台人工验收 → `app.status = pending-manual-acceptance`。

## 主形态与主入口
解压即用形态进 `app/`：`pebrel.exe` + `pebrel-hook.exe` 扁平两文件；主入口 `.target/.distribution/app/pebrel.exe`。共享 `%APPDATA%\Pebrel` 设置（与官方安装同源，验收时注意 settings 干扰项）。

## 构建输入集合
`src/` 全源码树（含 `Cargo.lock`、`rust-toolchain.toml`、i18n catalog、build script）——任一变化使 delivery 凭证 `unknown`。

## 验证产物生命周期
- 临时输出（check 日志等）当前命令结束删除
- 工作证据按 task 保留最新通过/当前失败各一份，批次收尾删除
- 稳定编译缓存 `.target/release|debug/` 不属于验证产物，不做常规 clean

## 空间预算
默认阈值（20 GiB 报告 / 50 GiB 限制）。

## delivery.json 与交付刷新
- `.target/delivery.json`：app 形态状态/源码 commit/生成命令/主入口/文件清单+SHA-256
- 影响用户功能的 task 完成时刷新 `app/`（当前内容 accepted 则先移 `app-prev/`）；构建失败不覆盖
- `app.status`：`pending-manual-acceptance`（含待验收清单与覆盖 task）→ 人工验收通过转 `accepted` 并删 `app-prev/`
- 交付区独立于编译缓存；缓存清理不触碰 `.distribution/`
- 刷新 `app/` 前检测进程占用：被占用不算失败，构建留在 `.target/release/`，“关闭正在运行的 Pebrel”作为人工验收包第一条前置动作，不另建并排目录

## 聚合快捷方式
`K:\Projects\distribution\pebrel.lnk` → `.target/.distribution/` 文件夹本身。
