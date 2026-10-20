Status: done

## Parent

`000-batch-tab-font.md`

## What to build

settings_pane 外观区加标签字体选择控件（font_picker 先例），文案走 i18n 编译期合同：catalog JSON 十一语言词条（en/zh-Hans/zh-Hant/fr/de/es/pt-BR/it/ru/ja/ko）+ `Message` 类型化 ID + `UiLanguage::text()`。

## Acceptance criteria

- [ ] 控件列出已装字体，选择即写 `tab_font_family`
- [ ] 清空/默认回落 Geist
- [ ] 十一语言词条齐全，编译通过（缺 ID 编译失败合同）
- [ ] `i18n_contract.rs` 测试通过

## Blocked by

- `002-tab-font-key-e2e.md`
