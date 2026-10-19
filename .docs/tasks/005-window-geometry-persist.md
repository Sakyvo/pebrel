Status: open

## Parent

`001-batch-window-geometry.md`

## What to build

窗口几何持久化 tracer bullet：`nebula_settings` 解析五个 flat 键（`window_x` / `window_y` / `window_width` / `window_height` / `window_maximized`，命名跟随 QuickTerminalSize 先例）；普通窗口 bounds/maximized 观测走 quick 模式（observe bounds → 脏标记 → 窗口关闭 persist），quick terminal 窗口不动。

## Acceptance criteria

- [ ] 移动/缩放/最大化窗口后退出，settings.txt 出现新键且值正确
- [ ] persist/roundtrip 单元测试通过
- [ ] quick terminal 尺寸行为不回归

## Blocked by

None - can start immediately（建议等字体批次闭环后开工）
