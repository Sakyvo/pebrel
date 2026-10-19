Status: open

## Parent

`000-batch-tab-font.md`

## What to build

批次验收与 PR 材料整理：全量门禁 + release 本地构建观感验收（人工）+ commit 整理为单一独立 commit + 推 fork。

## Acceptance criteria

- [ ] `cargo check` + `cargo test` 相关子集 + `python scripts/check_architecture.py --base upstream-v2.2.2` 通过
- [ ] handoff 六条观感清单人工验收并记录（见归档 handoff）
- [ ] 一个独立 commit，无混入无关改动
- [ ] PR 标题/描述起草（`feat(settings): …` 风格）

## Blocked by

- `002-tab-font-key-e2e.md`
- `003-tab-font-settings-ui.md`
