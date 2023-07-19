# Markdown

<!-- [![GitHub release (latest by date)](https://img.shields.io/github/v/release/imaoki/Markdown)](https://github.com/imaoki/Markdown/releases/latest) -->
[![GitHub](https://img.shields.io/github/license/imaoki/Markdown)](https://github.com/imaoki/Markdown/blob/main/LICENSE)

[Markdig](https://github.com/xoofx/markdig)のラッパー。
<!-- [Markdig](https://github.com/xoofx/markdig) wrapper. -->

## ライセンス
<!-- ## License -->

[MIT License](https://github.com/imaoki/Markdown/blob/main/LICENSE)

## 要件
<!-- ## Requirements -->

* [imaoki/Standard](https://github.com/imaoki/Standard)

## 開発環境
<!-- ## Development Environment -->

`3ds Max 2024`

## インストール
<!-- ## Install -->

01. 依存スクリプトは予めインストールしておく。
    <!-- 01. Dependent scripts should be installed beforehand. -->

02. `install.ms`を実行する。
    <!-- 02. Execute `install.ms`. -->

## アンインストール
<!-- ## Uninstall -->

`uninstall.ms`を実行する。
<!-- Execute `uninstall.ms`. -->

## 単一ファイル版
<!-- ## Single File Version -->

### インストール
<!-- ### Install -->

01. 依存スクリプトは予めインストールしておく。
    <!-- 01. Dependent scripts should be installed beforehand. -->

02. `Distribution\Markdown.min.ms`を実行する。
    <!-- 02. Execute `Distribution\Markdown.min.ms`. -->
    `Distribution\Markdig`ディレクトリは`Markdown.min.ms`と同じディレクトリに配置する。
    <!-- Place the `Distribution\Markdig` directory in the same directory as `Markdown.min.ms`. -->

### アンインストール
<!-- ### Uninstall -->

```maxscript
::markdown.Uninstall()
```

## 使い方
<!-- ## Usage -->

```maxscript
(
  ::markdown.ToHtml "foo\nbar"
)
-- 結果
"<p>foo<br />
bar</p>"
```
