# 构建输出契约

## 产物子树
`.target/` —— cargo workspace 全部编译产物，由根 `.cargo/config.toml` 的 `[build] target-dir = ".target"` 路由；在 `src/` 下执行 cargo 时向上发现该配置，产物写入根 `.target/`。

## release / package 入口
TODO：本仓库定位是上游修复工作台，不产出发布物；发布由上游 Kuddev/pebrel 的 CI 承担。如未来需本地打包验收，从 `src/packaging/` 的上游流程推导后补记。

## 最低产品验收
- `cargo check`（在 `src/` 下）通过。
- 涉及行为修改时：`cargo test` 相关子集 + 上游门禁 `python scripts/check_architecture.py --base upstream-vX.Y.Z`（在 `src/` 下）。
- 全部可后台运行，不依赖桌面交互。

## 主入口
`.target/debug/pebrel.exe`（调试验证用）；可执行文件名来自 `src/nebula_app/Cargo.toml` 的 `[[bin]] name = "pebrel"`。

## app / installer / zip 与刷新点
不适用：无本地交付形态。

## delivery.json 与构建输入集合
不适用：无本地交付。

## 验证产物生命周期落点
- 临时输出 / 工作证据：`.target/`（cargo 增量产物，随构建刷新）。
- 稳定缓存：`.target/` 本身即跨上游更新存活的编译缓存（依赖树未变时可复用，避免每次同步后全量重编）。
- 持久基线：无。

## 空间预算与聚合快捷方式
默认阈值；无 distribution 快捷方式。
