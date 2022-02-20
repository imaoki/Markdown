# Markdown

[Markdig 0.26.0](https://github.com/xoofx/markdig)のラッパー。

## 要件

* [imaoki/Standard](https://github.com/imaoki/Standard)

## 動作確認

`3ds Max 2022.3 Update`

## スタートアップに登録する

`register.ms`を実行する。

## スタートアップから登録解除する

`unregister.ms`を実行する。

## 使い方

```maxscript
(
  local markdown = ::MarkdownStruct()
  markdown.ToHtml "foo\nbar"
)
-- 結果
"<p>foo<br />
bar</p>"
```

## ライセンス

[MIT License](https://github.com/imaoki/Markdown/blob/main/LICENSE)
