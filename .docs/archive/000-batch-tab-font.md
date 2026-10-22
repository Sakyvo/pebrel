Status: anchor

## Problem

Pebrel 2.2.2 把侧栏/顶栏标签文字从 Maple 等宽字体（`mono_font_family`）换成内置 Geist 比例字体。偏好标签与终端一致等宽观感的用户无法恢复：配置层无按域出口，全局键 `ui_font_family` 会换掉整个 UI。本批次让标签字体独立可配，其余 UI 保持 Geist。

## Decisions

- 新自由字体键 `tab_font_family`：接受任意字体名，缺省回落 Geist（上游默认观感不变）。
- settings_pane 控件 + 十一语言 i18n 词条纳入第一批 PR（i18n 走编译期合同：catalog + Message 类型化 ID）。
- PR 直接提，不开 feature issue（AGENTS.md 已沉淀豁免）。
- 被否方案：三处落点直改回 `mono_font_family`（推翻 2.2.2 有意设计，上游大概率拒收，仅自用补丁路线）；布尔两态开关（只能跟终端/UI 字体走，表达力受限）。
- 执行顺序：本批次先于窗口几何批次（001）闭环。
- 完整触点资产：`.docs/archive/2026-10-18-pebrel-tab-font.md`（已归档的字体诊断 handoff）。

## Out of scope

- `ui_font_family` 全局键行为。
- 侧栏路径等元数据字体（`metadata_family`，仍走 mono，上游未变）。
- 上游默认观感（缺省 Geist 不动）。

## Testing strategy

- persist/roundtrip 测试参考 `settings_pane/appearance.rs`、`font_picker.rs` 既有模式。
- 标签落点行为用 `tabs_position` 两种模式验证（侧栏 + 顶栏）。
- reset 白名单生效测试（"恢复默认"清键）。
- `cargo test` + `python scripts/check_architecture.py --base upstream-v2.2.2` 门禁。
