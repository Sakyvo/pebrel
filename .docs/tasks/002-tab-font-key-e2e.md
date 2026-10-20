Status: done

## Parent

`000-batch-tab-font.md`

## What to build

`tab_font_family` 键端到端生效的 tracer bullet：`nebula_settings` 解析（参考 `ui_font_family` 的解析模式）→ `gpui_shell/config.rs` Settings 字段与装配 → 标签字体来源改为 `tab_font_family` 回落 `font_family` → sidebar 两处（render_sidebar、render_collapsed_tab_title）与 top_tabs 一处标签落点接新键 → `reset.rs` 白名单加键。完成后手改 settings.txt 即可验证观感。

## Acceptance criteria

- [ ] 无键：侧栏/顶栏标签 = Geist（与官方 2.2.2 一致）
- [ ] `tab_font_family=Maple Mono Normal NF CN`：标签 = Maple 等宽；设置页/对话框/其余 chrome 仍 Geist
- [ ] 终端区 `font_family` / `font_family_cjk` 不受影响
- [ ] `tabs_position` 顶栏模式同样生效
- [ ] 设置页"恢复默认"清掉新键（reset 白名单生效）
- [ ] persist/roundtrip 测试通过（appearance.rs / font_picker.rs 模式）

## Blocked by

None - can start immediately
