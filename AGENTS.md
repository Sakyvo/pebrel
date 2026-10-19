# Pebrel 上游修复工作台

## 项目定位
- [Kuddev/pebrel](https://github.com/Kuddev/pebrel)（GPU 加速终端，Rust + GPUI，GPL-3.0）的修复 fork：发现上游不足 → 在 `src/` 修复 → PR 回馈上游。
- 不发布产品；一切修改以"能被上游接受的小步 PR"为设计目标。

## 技术栈与结构
- Rust 2024 workspace（上游事实）：`src/nebula_app`（应用主体）、`src/nebula_terminal`（PTY/VT 核心）、`nebula_settings` / `nebula_split` / `nebula_hook` / `nebula_gpui` / `nebula-completions`；架构详见 `src/docs/architecture.md`。
- `src/` = 工作副本，唯一允许修改的地方（git 跟踪）。
- `upstream/` = 上游快照投递箱（gitignore，整目录随时删换）；任何文档与修改不得存放于此。
- `.target/` = 编译产物（根 `.cargo/config.toml` 路由，跨上游更新存活）。
- git：`main`（工作分支）+ `snapshot`（纯上游基线，每次上游更新一 commit）双分支 + tag `upstream-vX.Y.Z`；远端 fork = `https://github.com/Sakyvo/pebrel`。

## 常用命令
- 构建 / 测试（在 `src/` 下执行，产物自动进根 `.target/`）：`cargo check` / `cargo test`
- 上游架构门禁：`python scripts/check_architecture.py --base upstream-vX.Y.Z`（在 `src/` 下）
- 上游更新：删除 `upstream/` 放入新源码 → `scripts/sync-upstream.ps1`
- 推送 PR 材料：`git push -f origin main`（覆盖远端）→ 从 fork 向 Kuddev/pebrel 提 PR；修复 PR 直接提，无需先开 feature issue（用户知情豁免上游 CONTRIBUTING 礼节）。

## 常驻法则
- 修改只在 `src/` 做；写进 `upstream/` 的任何内容都会在下次同步时丢失。
- 动 `src/` 代码前，先读 `src/CONTRIBUTING.md`、`src/docs/project-constraints.md` 与目标文件路径上最近的 `src/**/AGENTS.md`；行数预算（800 提示 / 2000 硬上限）、依赖方向、i18n 规则（`src/docs/internationalization.md`）必须遵守。
- 一个修复 = 一个独立 commit，可单独 review；禁混入不相关改动。
- 治理文件（AGENTS.md、CONTEXT.md、`.docs/`、根 `scripts/`）的改动禁混进修复 commit。
- 项目受控生成输出只进根 `.target/`，禁止在 `.target/` 外产生构建产物。
- 上游同步前工作树必须完全干净（含 untracked）；`sync-upstream.ps1` 拒绝脏树。

## 按需读取索引
- 构建 / 测试 / 打包 / 交付前，读 `.docs/spec/build-output.md`
- 更新上游源码前，读 `.docs/adr/0001-src-upstream-dual-directory.md`
- 修复项落卡时，读 `.docs/tasks/` 任务板

## 优先级声明
用户指令 > 距离目标文件最近的 AGENTS.md（含上游自带的 `src/**/AGENTS.md`）> 本文件 > 路由文档。
