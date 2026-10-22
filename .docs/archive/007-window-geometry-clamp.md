Status: done

## Parent

`001-batch-window-geometry.md`

## What to build

多显示器安全 clamp：恢复时若上次位置落在已不存在的显示器/屏幕外，拉回主屏可见区；尺寸 clamp 不小于最小窗口尺寸（现值 760×540）。

## 验收结果

- [x] clamp 规则落在 `restored_window_bounds` 纯函数：几何原点所在显示器存在 → 原位；不存在 → 第一块（主屏）可见区，位置 clamp 保证窗口完整落在可见区内
- [x] 尺寸：不超可见区；下限由 settings 校验（760×540）+ `window_min_size` 选项随 bounds 收缩兜底
- [x] 单元测试三例全绿（含拔屏 + 超大窗口 + 无显示器 None）
- [x] windowing.rs 拆分后 1883 行 < 2000 硬上限（新增 `windowing/workspace_geometry.rs` 52 行），架构门禁无 ERROR

## Blocked by

- `006-window-geometry-restore.md` (done)
