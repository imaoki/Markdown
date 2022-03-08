# Markdown

[Markdig 0.26.0](https://github.com/xoofx/markdig)のラッパー。

## 要件

* [imaoki/Standard](https://github.com/imaoki/Standard)

## 動作確認

`3ds Max 2022.3 Update`

## インストール

01. 依存スクリプトがある場合は予めインストールしておく。

02. `install.ms`を実行する。

## アンインストール

`uninstall.ms`を実行する。

## スタンドアローン版

### インストール

01. 依存スクリプトがある場合は予めインストールしておく。

02. `Distribution\Markdown.min.ms`を実行する。

    `Distribution\Markdig`ディレクトリは`Markdown.min.ms`と同じディレクトリに配置する。

### アンインストール

```maxscript
::markdown.Uninstall()
```

## 使い方

```maxscript
(
  ::markdown.ToHtml "foo\nbar"
)
-- 結果
"<p>foo<br />
bar</p>"
```

## ライセンス

[MIT License](https://github.com/imaoki/Markdown/blob/main/LICENSE)
