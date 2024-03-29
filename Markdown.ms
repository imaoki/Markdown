/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  local hasMetRequirements
  fn hasMetRequirements = (
    isStruct ::std \
        and isProperty ::std #StructName \
        and classOf ::std.StructName == MAXScriptFunction \
        and ::std.StructName() == #StandardStruct
  )
  if not hasMetRequirements() do (
    local fileClass = DotNetClass "System.IO.File"
    local pathClass = DotNetClass "System.IO.Path"
    local currentDir = pathClass.GetDirectoryName (getSourceFileName())
    local standardFile = currentDir + @"\Standard.min.ms"
    if fileClass.Exists standardFile do fileIn standardFile
  )
  if not hasMetRequirements() do (
    format "[error]Requirement not met.\n"
  )
)
/*-
[Markdig 0.26.0](https://github.com/xoofx/markdig)のラッパー。
@remarks フレームワークは`net452`を使用する。
*/
struct MarkdownStruct (
  /*- @prop <BooleanClass> 定義リストを使用する場合は`true`、使用しない場合は`false`。既定値は`true`。 */
  public UseDefinitionLists = true,
  /*- @prop <BooleanClass> テーブルを使用する場合は`true`、使用しない場合は`false`。既定値は`true`。 */
  public UsePipeTables = true,
  /*- @prop <BooleanClass> 改行を`<br />`に置き換える場合は`true`、使用しない場合は`false`。既定値は`true`。 */
  public UseSoftlineBreakAsHardlineBreak = true,

  /*- @prop <DotNetObject:Markdig.MarkdownParserContext> */
  private context,
  /*- @prop <DotNetObject:System.Reflection.RuntimeAssembly> */
  private markdigAssembly,
  /*- @prop <DotNetClass:Markdig.MarkdownExtensions> */
  private markdownClass,
  /*- @prop <Struct:PathUtilityStruct> */
  private pathUtility,
  /*- @prop <DotNetObject:Markdig.MarkdownPipeline> */
  private pipeline,

  /*- @prop <String> アセンブリのパス文字列。 */
  private markdigDll = @".\Markdown.Markdig\Markdig.dll",

  /*
  public fn Install = (),
  public fn ShowTypes = (),
  public fn ToHtml input = (),
  public fn Uninstall = (),

  -- private fn escapeErrorPunctuation input = (),
  private fn initialize = (),
  */

  /*-
  インストールする。
  @returns <OkClass>
  @remarks 静的メソッド。
  */
  public fn Install = (
    if isProperty ::startupLoader #RegisterFile do (
      ::startupLoader.RegisterFile (getSourceFileName()) installer:true
    )
    format "[install]::MarkdownStruct\n"
    ok
  ),

  /*-
  アセンブリで定義されている全ての型をリスナーに出力する。
  @returns <OkClass>
  */
  public fn ShowTypes = (
    local types = this.markdigAssembly.GetTypes()
    for type in types do (
      format "\"%\"\n" type.FullName
    )
    ok
  ),

  /*-
  マークダウンテキストをHTMLコードに変換する。
  @param input <String> マークダウンテキスト。
  @returns <String> 変換されたHTMLコード。
  */
  public fn ToHtml input = (
    -- input = this.escapeErrorPunctuation input
    ::std.StringUtility.TrimEnd (
      this.markdownClass.ToHtml input this.pipeline this.context
    ) "\n"
  ),

  /*-
  アンインストールする。
  @returns <OkClass>
  @remarks 静的メソッド。
  */
  public fn Uninstall = (
    if isProperty ::startupLoader #UnregisterFile do (
      ::startupLoader.UnregisterFile (getSourceFileName())
    )
    format "[uninstall]::MarkdownStruct\n"
    ok
  ),

  /*-
  エスケープ無しではエラーになる"&"、"*"、"_"をエスケープ処理する。
  @param input <String>
  @returns <String>
  */
  -- private fn escapeErrorPunctuation input = (
  --   substituteString (
  --     substituteString (
  --       substituteString input "&" "\\&"
  --     ) "*" "\\*"
  --   ) "_" "\\_"
  -- ),

  /*-
  @returns <OkClass>
  */
  private fn initialize = (
    local dllPath = (this.pathUtility.GetFullPath this.markdigDll)
    this.markdigAssembly = DotNet.LoadAssembly dllPath
    this.markdownClass = DotNetClass "Markdig.Markdown"
    this.context = DotNetObject "Markdig.MarkdownParserContext"
    local mdExtClass = DotNetClass "Markdig.MarkdownExtensions"
    local pipelineBuilder = DotNetObject "Markdig.MarkdownPipelineBuilder"

    if this.UseDefinitionLists do (
      pipelineBuilder = mdExtClass.UseDefinitionLists pipelineBuilder
    )
    if this.UsePipeTables do (
      local pipeTableOptions = DotNetObject "Markdig.Extensions.Tables.PipeTableOptions"
      pipelineBuilder = mdExtClass.UsePipeTables pipelineBuilder pipeTableOptions
    )
    if this.UseSoftlineBreakAsHardlineBreak do (
      pipelineBuilder = mdExtClass.UseSoftlineBreakAsHardlineBreak pipelineBuilder
    )

    this.pipeline = pipelineBuilder.Build()
    ok
  ),

  /*- @prop <Array[<Integer>]> バージョン番号。メジャー、マイナー、パッチの順。 */
  private version = #(1, 1, 3),

  /*- @returns <Name> */
  public fn StructName = #MarkdownStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%MarkdownStruct\n" indent to:out
    format "%  UseDefinitionLists:%\n" indent this.UseDefinitionLists to:out
    format "%  UsePipeTables:%\n" indent this.UsePipeTables to:out
    format "%  UseSoftlineBreakAsHardlineBreak:%\n" indent this.UseSoftlineBreakAsHardlineBreak to:out
    ok
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  @remarks 大文字と小文字を区別する。
  */
  public fn Equals obj = (
    local isEqualStructName = isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == this.StructName()

    local isEqualProperties = true

    isEqualStructName and isEqualProperties
  ),

  /*-
  @returns <Array[<Integer>]>
  */
  public fn GetVersion = (
    this.version
  ),

  on Create do (
    this.pathUtility = ::std.PathUtilityStruct (getSourceFileName())
    this.initialize()
  )
)
