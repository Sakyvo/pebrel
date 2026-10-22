Status: anchor

## Problem

窗口最大化（非 F11 全屏）下终止 Pebrel 再打开，回到小窗化。上游普通窗口零几何持久化：每次启动 `Bounds::centered` 居中 Windowed 打开（`windowing.rs` open_initial_window 路径），最大化状态、位置、尺寸全不保存。本批次实现普通窗口几何的持久化与恢复。

## Decisions

- 完整几何：位置 + 尺寸 + maximized 一次做对（同类问题"非最大化自定义位置被重置居中"一并覆盖）。
- 存储：settings flat 键 `window_x` / `window_y` / `window_width` / `window_height` / `window_maximized`，跟随 QuickTerminalSize（`quick_terminal_width/height`）既有先例——窗口几何进 settings 已有仓库先例，架构依据现成。
- 观测：复用 quick 模式（observe bounds → 脏标记 → 窗口关闭 persist），不引入新持久化机制。
- 恢复：有键则按存几何开窗；`maximized=true` 先就位 windowed bounds 再 maximize；无键保持现居中默认（1080×720）。
- F11 全屏（ToggleFullscreen 路径）明确不碰。
- PR 直接提（AGENTS.md 已沉淀豁免）。
- 被否方案：只记 maximized 标志（非最大化位置仍每次重置，修一半）；独立 json 状态文件（偏离仓库先例，review 多解释一层）。

## Out of scope

- F11 全屏持久化。
- quick terminal 窗口尺寸行为（已有机制，不动）。
- 最小化状态。

## Testing strategy

- settings 键 persist/roundtrip 单元测试。
- 恢复行为人工验收清单（最大化往返、非最大化位置保持、无键首启默认）。
- 多显示器 clamp 单元测试（显示器集合变化场景）。
- `cargo test` + `python scripts/check_architecture.py --base upstream-v2.2.2` 门禁。
