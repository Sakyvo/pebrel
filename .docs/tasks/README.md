# 任务板

修复项任务卡。初始为空板——修复清单由项目主人列出后落卡。

## 落卡约定
- 每个修复项一张卡：`NNNN-<slug>.md`，内容含：问题现象、复现方式、修复方案、验收（cargo check / cargo test + 上游门禁）、PR 材料（commit hash）。
- 卡状态：`open` → `in-review` → `closed`（PR 被上游合并即 closed）。
