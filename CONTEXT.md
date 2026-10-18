# Pebrel 上游修复工作台

## 介绍

- 本仓库不是 Pebrel 的开发主线，而是它的**修复工作台**：上游 [Kuddev/pebrel](https://github.com/Kuddev/pebrel) 是一个 GPU 加速终端、SSH 工作区与 AI CLI 宿主（Rust + GPUI，GPL-3.0）；我们发现其中的不足，在这里以"小步修复、PR 回馈"的方式改进它。
- 与常见 fork 的区别：上游以**整目录快照**方式投递（`upstream/` 随版本删换，无 `.git`），修复历史由本仓库 git 的 main / snapshot 双分支承载，更新走 `scripts/sync-upstream.ps1` 三方合并。
- 使用者：单人本机开发；最终读者是上游维护者——一切产出以"上游可接受"为第一标准。

## Language

### 工作流词汇

**快照（snapshot）**：
上游某版本的完整源码目录 `upstream/`；只读参照物与更新投递箱，不承载修改，随时整体删换。
_Avoid_: upstream 目录不是"代码库"，也不是工作区。

**snapshot 分支**：
git 中只记录纯上游历史的分支；每次上游更新在其上多一个 commit，是三方合并的基准。tag `upstream-vX.Y.Z` 标记每个版本。

**工作副本（src/）**：
上游源码 + 本仓库全部修复；git 跟踪；唯一允许修改的地方。
_Avoid_: 别说"改 upstream"——upstream 只读。

**同步（sync）**：
删换 `upstream/` 为新源码后，运行 `scripts/sync-upstream.ps1` 把上游变更合并进 `src/` 的过程。

### 上游领域词汇（修代码时与上游用法保持一致）

**Pebrel / Nebula**：
产品名，前称 Nebula；crate 名仍是 `nebula_*`，可执行文件是 `pebrel.exe`。

**GPUI**：
来自 Zed 的 GPU 加速 UI 框架，整个渲染层的地基（经 `nebula_gpui` 做组件验收实验）。

**Pane / Split / Tab / Workspace**：
窗格（pane）= 单个终端视图；分屏（split）= 窗格的树形排布（`nebula_split`）；标签（tab）= 顶层窗口页；Workspace = 布局与各窗格工作目录的保存/恢复单位。

**VT / PTY**：
VT 是终端转义序列与网格处理，PTY 是伪终端设备——都在 `nebula_terminal`。

**补全（completion）**：
Pebrel 自有补全引擎（`nebula-completions`），从 Git、npm scripts、SSH 配置、WSL 发行版、文件系统取候选，不依赖 shell 插件或 AI；与**历史补全**（recall 已执行过的命令）是两回事。

**AI hook**：
`nebula_hook` + `src/nebula_app/src/ai_hook`——桥接 AI CLI（Claude Code、Codex 等）的事件与活动状态。

**回答阅读器（answer reader）**：
捕获的 AI 回答在原生阅读器中打开（Markdown、公式、源文本、图片预览）。

**宿主库（host library）**：
SSH 主机的保存库，支持名称/地址/分组/标签/备注搜索，供启动器、命令面板与 Quick Jump 共用同一份元数据。

## 示例对话

> **开发者**："这个修复要在 VT 层做，pane 渲染不用动。"
> **领域**："对——VT 处理在 `nebula_terminal`，pane 是 `gpui_shell` 的视图职责；这个改动应该只产生一个 `nebula_terminal` 的小 diff。"
> **开发者**："补全候选能加一个新来源吗？"
> **领域**："可以，但要走 `completion::Session` 的来源选择边界，候选计算只拿 input/cwd/environment——别在 suggest_engine 里碰 pane 状态。"
