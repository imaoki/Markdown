# Markdown

[Markdig](https://github.com/xoofx/markdig) wrapper.
<!-- [Markdig](https://github.com/xoofx/markdig)のラッパー。 -->

## Requirements
<!-- 要件 -->

* [imaoki/Standard](https://github.com/imaoki/Standard)

## Development Environment
<!-- 開発環境 -->

`3ds Max 2022.3 Update`

## Install
<!-- インストールする -->

01. Dependent scripts should be installed beforehand.
    <!-- 依存スクリプトは予めインストールしておく。 -->

02. Execute `install.ms`.
    <!-- `install.ms`を実行する。 -->

## Uninstall
<!-- アンインストールする -->

Execute `uninstall.ms`.
<!-- `uninstall.ms`を実行する。 -->

## Standalone version
<!-- スタンドアローン版 -->

### Install
<!-- インストールする -->

01. Dependent scripts should be installed beforehand.
    <!-- 依存スクリプトは予めインストールしておく。 -->

02. Execute `Distribution\Markdown.min.ms`.
    <!-- `Distribution\Markdown.min.ms`を実行する。 -->

    Place the `Distribution\Markdig` directory in the same directory as `Markdown.min.ms`.
    <!-- `Distribution\Markdig`ディレクトリは`Markdown.min.ms`と同じディレクトリに配置する。 -->

### Uninstall
<!-- アンインストールする -->

```maxscript
::markdown.Uninstall()
```

## Usage
<!-- 使い方 -->

```maxscript
(
  ::markdown.ToHtml "foo\nbar"
)
-- result
"<p>foo<br />
bar</p>"
```

## License
<!-- ライセンス -->

[MIT License](https://github.com/imaoki/Markdown/blob/main/LICENSE)
