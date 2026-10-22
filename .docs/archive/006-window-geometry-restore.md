Status: done

## Parent

`001-batch-window-geometry.md`

## What to build

启动恢复端到端：初始窗口 bounds 优先从持久化键恢复（open_initial_window 路径）；`maximized=true` 时先就位 windowed bounds 再 maximize；无键保持现居中默认（1080×720，上游默认观感不变）。

## 验收结果

- [x] `workspace_window_options` Regular 分支：`restored_regular_bounds(cx)` 优先恢复存档几何；None 走既有 `centered_regular_bounds`（preferred_size/primary_display 居中，上游默认不变）
- [x] 最大化恢复：`WindowBounds::Maximized(bounds)` 打开 → gpui 平台层自动 zoom，还原框 = 存档的 windowed bounds（gpui 内建语义，无需手动 maximize 步骤）
- [x] `startup_geometry::restored_window_bounds` 纯函数 + 3 个单元测试（原位恢复 / 显示器消失回主屏 / 超大窗口收缩 + 无显示器返回 None）
- [x] F11 全屏不受影响（观测侧明确跳过 Fullscreen）
- [x] windowing 14 passed、workspace:: 140 passed

## Blocked by

- `005-window-geometry-persist.md` (done)
