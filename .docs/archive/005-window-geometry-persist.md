Status: done

## Parent

`001-batch-window-geometry.md`

## What to build

窗口几何持久化 tracer bullet：`nebula_settings` 解析五个 flat 键（`window_x` / `window_y` / `window_width` / `window_height` / `window_maximized`，命名跟随 QuickTerminalSize 先例）；普通窗口 bounds/maximized 观测走 quick 模式（observe bounds → 脏标记 → 窗口关闭 persist），quick terminal 窗口不动。

## 验收结果

- [x] `nebula_settings/src/window.rs`：WindowGeometry（finite/760×540 下限/16384 上限校验）+ persisted_values 五键写盘 + roundtrip/非法值回落测试
- [x] `RuntimeSettings.window_geometry` 解析（f32×4 zip + bool_on("window_maximized")）；parses/defaults 测试
- [x] reset.rs 五键入白名单（reader 守卫测试通过）
- [x] 观测：`observe_window_bounds` 回调追加 `workspace_window_geometry_changed`（quick 窗口跳过；F11 全屏不记）；WindowRegistry.window_geometry_dirty 脏标记
- [x] 落盘：quit / autosave_tick / save_after_window_closed 三钩子统一 persist（`windowing/workspace_geometry.rs`）
- [x] 全部测试绿（nebula-settings 102）

## Blocked by

None
