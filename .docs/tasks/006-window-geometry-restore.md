Status: open

## Parent

`001-batch-window-geometry.md`

## What to build

启动恢复端到端：初始窗口 bounds 优先从持久化键恢复（open_initial_window 路径）；`maximized=true` 时先就位 windowed bounds 再 maximize；无键保持现居中默认（1080×720，上游默认观感不变）。

## Acceptance criteria

- [ ] 最大化 → 退出 → 重开：窗口为最大化
- [ ] 自定义位置/尺寸（非最大化）→ 退出 → 重开：保持
- [ ] 无键首启：居中默认，与官方 2.2.2 一致
- [ ] F11 全屏不受影响

## Blocked by

- `005-window-geometry-persist.md`
