Status: open

## Parent

`001-batch-window-geometry.md`

## What to build

批次验收与 PR 材料整理：全量门禁 + 恢复行为人工验收 + commit 整理为单一独立 commit + 推 fork。

## Acceptance criteria

- [ ] `cargo check` + `cargo test` 相关子集 + `python scripts/check_architecture.py --base upstream-v2.2.2` 通过
- [ ] 恢复行为人工验收并记录（最大化往返 / 非最大化保持 / 无键默认 / clamp）
- [ ] 一个独立 commit，无混入无关改动
- [ ] PR 标题/描述起草（`feat(app): …` 类风格）

## Blocked by

- `005-window-geometry-persist.md`
- `006-window-geometry-restore.md`
- `007-window-geometry-clamp.md`
