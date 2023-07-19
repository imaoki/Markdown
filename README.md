# Markdown

<!-- [![GitHub release (latest by date)](https://img.shields.io/github/v/release/imaoki/Markdown)](https://github.com/imaoki/Markdown/releases/latest) -->
[![GitHub](https://img.shields.io/github/license/imaoki/Markdown)](https://github.com/imaoki/Markdown/blob/main/LICENSE)

[Markdig](https://github.com/xoofx/markdig)のラッパー。

## ライセンス

[MIT License](https://github.com/imaoki/Markdown/blob/main/LICENSE)

## 要件

* [imaoki/Standard](https://github.com/imaoki/Standard)

* （任意）[imaoki/StartupLoader](https://github.com/imaoki/StartupLoader)
  導入済みの場合はインストール/アンインストールでスタートアップスクリプトの登録/解除が行われる。
  未使用の場合はスクリプトの評価のみ行われる。

## 開発環境

`3ds Max 2024`

## インストール

01. 依存スクリプトは予めインストールしておく。

02. `install.ms`を実行する。

## アンインストール

`uninstall.ms`を実行する。

## 単一ファイル版

### インストール

01. 依存スクリプトは予めインストールしておく。

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
