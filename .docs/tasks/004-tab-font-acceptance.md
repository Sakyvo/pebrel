Status: review

## Parent

`000-batch-tab-font.md`

## What to build

批次验收与 PR 材料整理：全量门禁 + release 本地构建观感验收（人工）+ commit 整理为单一独立 commit + 推 fork。

## 自动化验收结果（已完成）

- [x] `cargo check -p nebula` 通过
- [x] `cargo test` 相关子集全绿：
  - nebula-settings lib：100 passed（含 parse/默认值/reset 清键用例）
  - gpui_shell::config：19 passed；workspace::（sidebar/top_tabs）：137 passed；theme：7 passed
  - settings_pane（--features gpui-test-support）：104 passed + 1 **pre-existing 失败**（mobile 按钮几何断言，干净 upstream 2.2.2 树同样失败，环境相关，非本批次回归）
  - i18n_contract：24 passed（新词条过编译期合同）
  - file_line_budget：2 passed（行数预算无增长）
  - 新交互测试 tab_dropdown_selection_persists_tab_font_family：passed（chevron → 面板 → 选字体 → tab_font_family 落盘 → escape）
  - 既有交互测试 cjk_dropdown_selection… / review_regression_font_fields…：passed（三态化无回归）
- [x] `python scripts/check_architecture.py`：exit 0（注：上游脚本假定仓库根=src；本仓库根在上层，--base 的 git 路径解析不适用，"拒绝债务增长"部分由 file_line_budget 测试等价覆盖；上游 CI 跑 PR 时不受影响）
- [x] rustfmt --check：干净
- [x] commit 已拆分独立可 review：`4041e67`（键+落点）、`5f83a45`（设置页控件+i18n）

## 人工观感验收清单（待用户执行）

构建：`cargo build --release --locked -p nebula --bin pebrel --features gpui-shell`（产物 `../.target/release/pebrel.exe`）
测试前注意：`%APPDATA%\Pebrel\pebrel_settings.txt` 若残留临时 `ui_font_family` 行，先删除再测。

1. 无 `tab_font_family` 键：侧栏/顶栏标签 = Geist（与官方 2.2.2 一致）
2. 设置页 → 外观 → 高级 → 界面组："标签字体"行存在；输入/选择 `Maple Mono Normal NF CN` → 标签恢复等宽；设置页/对话框/其余 chrome 仍 Geist
3. 标签字体输入框清空并回车 → 标签回落界面默认字体
4. 终端区始终走 `font_family`/`font_family_cjk`，观感不受影响
5. `tabs_position=top` 顶栏模式同样生效
6. 设置页"恢复默认"清掉 tab_font_family 键（reset 白名单）

## PR 材料（起草）

标题：`feat(settings): per-surface tab label font (tab_font_family)`
描述要点：2.2.2 将标签文字从随包等宽（Maple）换为 Geist 比例字体，无按域出口；全局 `ui_font_family` 会重排整个 UI。本 PR 新增 `tab_font_family`（缺省回落 ui_font_family→Geist，默认观感不变），设置页外观-界面组提供共享字体选择器行；en/zh-Hans/zh-Hant/ja catalog 词条，其余语言按上游目录覆盖度回落英文。Commits：`4041e67` + `5f83a45`。

## Blocked by

- `002-tab-font-key-e2e.md` (done)
- `003-tab-font-settings-ui.md` (done)
