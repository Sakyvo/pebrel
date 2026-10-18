# src/ + upstream/ 双目录与 snapshot 分支的 vendor 结构

上游以整目录快照方式投递（`upstream/` 随版本删换、无 `.git`），修复必须在其上长期累积并最终以 PR 回馈。决定：`src/` 作为唯一工作副本（git 跟踪），`upstream/` 作为 gitignore 的只读快照投递箱；git 里 `snapshot` 分支记录纯上游基线（每版本一 commit），`main` 在其上承载修复；上游更新由 `scripts/sync-upstream.ps1` 完成三方合并（checkout snapshot → 镜像同步 → commit + tag → merge 回 main）。已 commit 的修复在任何更新动作下都不可能丢失。

## Considered Options
- **根目录即工作副本**：38 万行源码与治理文件混在根，路由与 gitignore 复杂，弃。
- **patch 重放**（format-patch / git am）：单分支，冲突处理弱于 3-way merge，每次更新重放全量 patch，弃。
- **单目录 vendor**（工作副本就叫 `upstream/`）："删除换新"的习惯动作直接威胁修改存活，快照与修改语义纠缠，弃。

## Consequences
- 磁盘多占一份源码（百 MB 级）；换取 PR diff 直接可产出与合并安全。
- 同步脚本要求更新前工作树完全干净（含 untracked），否则拒绝执行。
- 修复若涉及上游 `.gitignore` 忽略的文件（如大部分 `src/docs/`），需 `git add -f` 显式纳入。
- PR 通道：push 到 fork `https://github.com/Sakyvo/pebrel`（覆盖远端）→ 向 Kuddev/pebrel 提 PR。
