# Handoff：Pebrel 标签字体回归 — fork + PR 实施

> 交接自 K:\Workplace 诊断会话（2026-10-18）。本文件按 handoff 规范存放，
> 由下一会话以 `pickup` 消费；消费后归档至 `.docs/archive/`。
> 若实施会话直接在 fork clone 目录工作，请把本文件复制进 `<clone>/.docs/handoffs/`。

## 当前目标

Pebrel 2.2.2 把侧栏/顶栏的**标签文字**（tab labels）从随包等宽字体（Maple Mono Normal NF CN）换成了内置 Geist 比例字体。用户只接受**标签恢复 Maple 等宽观感，其余 UI 保持 Geist**。配置层无出口（`ui_font_family` 是全局键，实测会把整个 UI 换成 Maple），因此需要改代码：fork → 实现 → 本地构建验证 → 向 Kuddev/pebrel 提 PR。

## 下一步入口

1. 拍板方案 A / B（推荐 B，理由见下）。
2. fork `github.com/Kuddev/pebrel` 并 clone（建议 `K:\Projects\sourcecodes\pebrel`，当前 2.2.2 tag）。
3. 按所选方案实现 → `cargo build --release --locked -p nebula --bin pebrel --features gpui-shell`。
4. 跑本地验收清单（见下）。
5. 按上游礼节开 feature issue / 直接提 PR。

## 已验证状态（2.2.1/2.2.2 源码对比确认）

- 源码快照（仅参考，无 .git）：`K:\Projects\sourcecodes\pebrel-2.2.1`、`K:\Projects\sourcecodes\pebrel-2.2.2`；PR 工作须重新 fork + clone。
- 2.2.2 新增 `nebula_app/src/gpui_shell/typography.rs`：`UI_FONT_FAMILY = "Geist"`，`GeistVF.ttf` 内嵌进二进制。
- 字体链：`theme.font_family = settings.txt 的 ui_font_family（可选） ?? "Geist"`（`gpui_shell/theme.rs:803-804`）；`theme.mono_font_family = REQUIRED_FONT_FAMILY = "Maple Mono Normal NF CN"`（`theme.rs:802`；`font_install.rs:5`）。
- 2.2.1 → 2.2.2 标签字体三处落点（全部由 `theme.mono_font_family` 改为 `theme.font_family`）：
  1. `workspace/sidebar.rs` `render_sidebar()`（fn 定义 @190）：`chrome_family` @208，标签用点 @508/@514/@665
  2. `workspace/sidebar.rs` `render_collapsed_tab_title()`（fn @956）：`chrome_family` @977，用点 @1027
  3. `workspace/top_tabs.rs`：`chrome_family` @150
- 侧栏路径等元数据仍走 `metadata_family = theme.mono_font_family`（Maple），未变。
- 根容器字体即 `theme.font_family`（`workspace/render.rs:80`）→ 用户写 `ui_font_family=Maple Mono Normal NF CN` 后全 UI 变 Maple 的原因。
- 仓库不存在任何按区域划分的字体键（rg 验证：无 sidebar_font / tab_font / label_font）。
- 上游无既有相关 issue（GitHub API 搜 font/Geist，仅 release PR #667 提及）；无重复报告风险。
- 用户设置 `C:\Users\ASUS\AppData\Roaming\Pebrel\pebrel_settings.txt`：`font_family=Maple Mono NF CN`、`font_family_cjk=Maple Mono Normal NF CN`、`ui_font_size=15.00`、`theme=CatppuccinMocha`、（当前临时）`ui_font_family=Maple Mono Normal NF CN`——**注意：测试观感前先处理这行**。

## 方案（未决，实施会话开头拍板）

### 方案 B（推荐）：新增按域键 `tab_font_family`

- 语义：侧栏 + 顶栏标签文字字体；缺省回落 `ui_font_family`（默认 Geist，**不改变上游默认观感**）。
- 用户用法：`tab_font_family=Maple Mono Normal NF CN` + 删除全局 `ui_font_family` 行 → 标签 Maple、其余 Geist。
- 触点：
  - `nebula_settings/src/lib.rs`：解析（参考 `ui_font_family` @995/@1190 模式）
  - `nebula_settings/src/reset.rs`：RESET_KEYS 白名单（必加，否则"恢复默认"不识别）
  - `nebula_app/src/gpui_shell/config.rs`：Settings 字段 + 装配（参考 @60/@280）
  - 三处标签落点改读新键（回落 ui_font_family）
  - 可选：settings_pane UI 控件 + `localization.rs`/`setting_help.rs` 文案（加 UI 须过 docs/internationalization.md 语言目录合同）
  - 测试参考 `settings_pane/appearance.rs`、`font_picker.rs` 既有 persist/roundtrip 模式
  - 新持久化键 = 架构约束的"持久化变更"，须给设计依据；note 政策见 `architecture/notes/AGENTS.md`
- 风险：面较大、要过 i18n 与架构门禁；默认行为不变，上游接受概率高。

### 方案 A（对照/最小 fork）：三处落点直接改回 `theme.mono_font_family`

- diff 极小（3 行），完全恢复 2.2.1 观感，无需新键。
- 风险：直接推翻 2.2.2 有意设计（CHANGELOG 明示 Geist 化），上游大概率拒收；仅适合自用补丁路线，且自建版要防官方自动更新覆盖（用便携包或关自动更新），每次 release 需 rebase 重建。

### 上游礼节（CONTRIBUTING.md 明文）

- "Propose a feature: describe the workflow and user need before prescribing an implementation. For broad changes, agree on scope before writing a large PR." → 选 B 建议先开 feature issue（用户故事：终端用户偏好标签标题与终端字体一致的等宽观感），维护者表态后再写 PR；A 可直接 PR 但预期被拒。
- PR 标题格式参考近期合并记录：`fix(sidebar): …`、`feat(terminal): add a setting to …`（#632、#331）。

## 环境 / 构建

- Windows 10 LTSC；工具链由仓库 `rust-toolchain.toml` 固定。
- 构建：`cargo build --release --locked -p nebula --bin pebrel --features gpui-shell`（内部包名 nebula、产物名 pebrel；README「构建」节）。
- `target/release/pebrel.exe` 可直接运行验证（GUI），与官方安装 `K:\Pebrel\pebrel.exe` 共享 `%APPDATA%\Pebrel` 设置——测试时留意 settings.txt 中临时的 `ui_font_family` 行会干扰观感判断。
- 门禁：`python3 scripts/check_architecture.py --base <PR-base-commit>`（800 行提示 / 2000 行上限）；`rustfmt.toml`；分层 AGENTS.md 按触点读（根 → nebula_app → nebula_settings → docs → packaging/release-notes）。

## 验收清单（本地）

1. 无新键：侧栏/顶栏标签 = Geist（与官方 2.2.2 一致）。
2. `tab_font_family=Maple Mono Normal NF CN`：标签恢复等宽 Maple；设置页/对话框/其余 chrome 仍 Geist。
3. 终端区始终走 `font_family`/`font_family_cjk`，不受影响。
4. `tabs_position` 顶栏模式同样生效。
5. 设置页"恢复默认"能清掉新键（reset.rs 白名单生效）。
6. 仓库测试（cargo test / nextest）与 check_architecture.py 通过。

## 建议技能

- `pickup`：消费本 handoff。
- `tdd`：先写 persist/roundtrip 回归测试再实现（仓库测试文化重）。
- `codex-review`：提 PR 前自查 diff。

## 未决问题

- 方案 A vs B 拍板（建议 B；用户需求"只要标签恢复"与 B 的键语义正好重合）。
- fork clone 位置（建议 `K:\Projects\sourcecodes\pebrel`）与 GitHub 推送授权。
- 是否先开 feature issue（选 B 则建议是）。
- 新键最终命名（`tab_font_family` vs `ui_font_family_tabs`，与维护者对齐）。
- 完整诊断记录：`K:\Workplace\History\2026-10-18_Pebrel字体回退\记录.md`。
