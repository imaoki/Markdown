# Markdown

[Markdig 0.26.0](https://github.com/xoofx/markdig)のラッパー。

## 依存リポジトリ

* [imaoki/Standard](https://github.com/imaoki/Standard)

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
