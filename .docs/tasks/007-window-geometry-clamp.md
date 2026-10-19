Status: open

## Parent

`001-batch-window-geometry.md`

## What to build

多显示器安全 clamp：恢复时若上次位置落在已不存在的显示器/屏幕外，拉回主屏可见区；尺寸 clamp 不小于最小窗口尺寸（现值 760×540）。

## Acceptance criteria

- [ ] 拔掉副屏后启动：窗口回主屏可见区
- [ ] 恢复尺寸不小于 window_min_size
- [ ] clamp 单元测试（显示器集合变化场景）通过

## Blocked by

- `006-window-geometry-restore.md`
