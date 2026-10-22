Status: review

## Parent

`001-batch-window-geometry.md`

## What to build

批次验收与 PR 材料整理：全量门禁 + 恢复行为人工验收 + commit 整理为单一独立 commit + 推 fork。

## 自动化验收结果（已完成）

- [x] `cargo check -p nebula` 通过
- [x] `cargo test` 相关子集全绿：
  - nebula-settings lib：102 passed（WindowGeometry roundtrip/非法回落/defaults + reset 五键）
  - windowing：14 passed（startup_geometry 6 含 3 个新恢复/clamp 测试）
  - workspace::：140 passed
  - settings_pane（--features gpui-test-support）：104 passed + 1 pre-existing 失败（mobile 按钮几何，干净 upstream 2.2.2 同样失败，非本批次回归）
  - file_line_budget：2 passed
- [x] `python scripts/check_architecture.py`：无 ERROR（windowing.rs 2018→1883 行拆分后回到 2000 上限内）
- [x] rustfmt --check：干净
- [x] 单一独立 commit：`1e82e05`（观测+持久化+恢复+clamp 一体，文件交叉不可拆）

## 人工观感验收清单（待用户执行）

构建已就绪：`.target/.distribution/app/pebrel.exe`（同一次构建，与 004 卡合并验收）。

1. 最大化窗口（非 F11）→ 关闭 → 重开：窗口仍为最大化，还原后尺寸正确
2. 自定义位置/尺寸（非最大化）→ 关闭 → 重开：位置尺寸保持
3. 无 window_* 键首启：居中默认，与官方 2.2.2 一致
4. F11 全屏 → 重开：不还原为全屏（按设计跳过）
5. 拔掉副屏后启动（若有多显示器）：窗口回主屏可见区
6. quick terminal 尺寸行为不回归
7. settings.txt 出现 `window_x/y/width/height/maximized` 五键且值随窗口变化更新
8. 验收通过后告知 Agent：delivery.json 转 accepted、删除可能存在的 app-prev，004/008 卡转 done

## PR 材料（起草）

标题：`feat(app): persist and restore regular window geometry`
描述要点：regular 窗口无任何几何持久化，每次启动居中，最大化状态丢失（用户报告）。本 PR 以 quick terminal size 的既有 flat-key 模式新增五键；观测标脏 + quit/autosave/关窗统一落盘；启动恢复（最大化经平台 Maximized(bounds) 语义还原还原框）；显示器消失/超屏时 clamp 进第一可见区；F11 全屏有意不持久化。Commits：`1e82e05`。

## Blocked by

- `005-window-geometry-persist.md` (done)
- `006-window-geometry-restore.md` (done)
- `007-window-geometry-clamp.md` (done)
