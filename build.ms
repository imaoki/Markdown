/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  /* 初期化 */
  local mp = ::MxsPackStruct (getSourceFileName())
  /* 出力先ディレクトリ削除 */
  -- mp.DeleteDirectory @".\Distribution"

  /* コード切り出し */
  local MarkdownCode = mp.ClipFile @".\Markdown.ms" 1 -1

  /* コード置換 */
  local code = MarkdownCode

  /* インストールコード追加 */
  code = mp.AppendText code "::MarkdownStruct.Install()\n::MarkdownStruct\n"
  /* インストーラーオプション削除 */
  code = mp.RemoveInstallerOption code
  /* バンドルファイルを保存 */
  -- mp.WriteAllText @".\Distribution\Markdown.bundle.ms" code
  /* 最小化ファイルを保存 */
  code = mp.Minify code
  mp.WriteAllText @".\Distribution\Markdown.min.ms" code
  /* ファイルコピー */
  mp.CopyDirectory @".\Markdown.Markdig" @".\Distribution\Markdown.Markdig"
  ok
)
