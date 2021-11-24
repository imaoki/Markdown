/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  -- clearListener()

  local nowTime = (DotNetClass "System.DateTime").Now.ToString "HH:mm:ss"
  local sw = DotNetObject "System.Diagnostics.Stopwatch"

  local currentFile = getSourceFileName()
  local pathUtility = ::PathUtilityStruct currentFile

  local actual
  local expected
  local testDef
  local testObj

  format "[run %]@\"%\"\n" nowTime currentFile
  /* Setup Start ------------------------------------------------------------ */
  testDef = fileIn (pathUtility.GetFullPath @"..\Markdown.ms")
  testObj = testDef UseSoftlineBreakAsHardlineBreak:false
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* ToHtml */
  --
  actual = ::TestValueStruct (testObj.ToHtml "Term 1\n:   This is a definition item\n    With a paragraph\n    > This is a block quote\n\n    - This is a list\n    - with an item2\n\n    ```java\n    Test\n\n\n    ```\n\n    And a last line\n:   This ia another definition item\n\nTerm2\nTerm3 *with some inline*\n:   This is another definition for term2")
  -- actual.Dump()
  expected = ::TestValueStruct "<dl>\n<dt>Term 1</dt>\n<dd><p>This is a definition item\nWith a paragraph</p>\n<blockquote>\n<p>This is a block quote</p>\n</blockquote>\n<ul>\n<li>This is a list</li>\n<li>with an item2</li>\n</ul>\n<pre><code class=\"language-java\">Test\n\n\n</code></pre>\n<p>And a last line</p>\n</dd>\n<dd>This ia another definition item</dd>\n<dt>Term2</dt>\n<dt>Term3 <em>with some inline</em></dt>\n<dd>This is another definition for term2</dd>\n</dl>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Term 1\n\n:   Definition\nwith lazy continuation.\n\n    Second paragraph of the definition.")
  -- actual.Dump()
  expected = ::TestValueStruct "<dl>\n<dt>Term 1</dt>\n<dd><p>Definition\nwith lazy continuation.</p>\n<p>Second paragraph of the definition.</p>\n</dd>\n</dl>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Term 1\n:  Invalid with less than 3 characters")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Term 1\n:  Invalid with less than 3 characters</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Term 1\n   : Valid even if `:` starts at most 3 spaces")
  -- actual.Dump()
  expected = ::TestValueStruct "<dl>\n<dt>Term 1</dt>\n<dd>Valid even if <code>:</code> starts at most 3 spaces</dd>\n</dl>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Term 1\n\n    : Not valid")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Term 1</p>\n<pre><code>: Not valid\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1.  First\n    \n2.  Second\n    \n    Term 1\n    :   Definition\n    \n    Term 2\n    :   Second Definition")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li><p>First</p>\n</li>\n<li><p>Second</p>\n<dl>\n<dt>Term 1</dt>\n<dd>Definition</dd>\n<dt>Term 2</dt>\n<dd>Second Definition</dd>\n</dl>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
