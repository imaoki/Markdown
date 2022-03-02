(
  -- clearListener()

  local nowTime = (DotNetClass "System.DateTime").Now.ToString "HH:mm:ss"
  local sw = DotNetObject "System.Diagnostics.Stopwatch"

  local currentFile = getSourceFileName()
  local pathUtility = ::std.PathUtilityStruct currentFile

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
  actual = ::TestValueStruct (testObj.ToHtml "\tfoo\tbaz\t\tbim")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>foo\tbaz\t\tbim\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  \tfoo\tbaz\t\tbim")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>foo\tbaz\t\tbim\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    a\ta\n    ὐ\ta")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>a\ta\nὐ\ta\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  - foo\n\n\tbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>foo</p>\n<p>bar</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n\n\t\tbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>foo</p>\n<pre><code>  bar\n</code></pre>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml ">\t\tfoo")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<pre><code>  foo\n</code></pre>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "-\t\tfoo")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>\n<pre><code>  foo\n</code></pre>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    foo\n\tbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>foo\nbar\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " - foo\n   - bar\n\t - baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>baz</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "#\tFoo")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>Foo</h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*\t*\t*\t")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\]^_`{|}~</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "\\t\A\a\ \3\φ\«")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>\\t\A\a\ \3\φ\«</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "\*not emphasized*\n\<br/> not a tag\n\[not a link](/foo)\n\`not code`\n1\. not a list\n\* not a list\n\# not a heading\n\[foo]: /url \"not a reference\"\n\&ouml; not a character entity")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*not emphasized*\n&lt;br/&gt; not a tag\n[not a link](/foo)\n`not code`\n1. not a list\n* not a list\n# not a heading\n[foo]: /url &quot;not a reference&quot;\n&amp;ouml; not a character entity</p>"
  assert (actual.Equals expected == true)
  -- CommonMarkの結果とは異なる（Markdigの仕様）
  actual = ::TestValueStruct (testObj.ToHtml "\\*emphasis*")
  -- actual.Dump()
  -- expected = ::TestValueStruct "<p>\\<em>emphasis</em></p>"
  expected = ::TestValueStruct "<p>*emphasis*</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo\\\nbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo<br />\nbar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`` \[\` ``")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>\[\`</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    \[\]")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>\[\]\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "~~~\n\[\]\n~~~")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>\[\]\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<http://example.com?find=\*>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"http://example.com?find=%5C*\">http://example.com?find=\*</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a href=\"/bar\/)\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<a href=\"/bar\/)\">"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo](/bar\* \"ti\*tle\")")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]\n\n[foo]: /bar\* \"ti\*tle\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "``` foo\+bar\nfoo\n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code class=\"language-foo+bar\">foo\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "&nbsp; &amp; &copy; &AElig; &Dcaron;\n&frac34; &HilbertSpace; &DifferentialD;\n&ClockwiseContourIntegral; &ngE;")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>  &amp; © Æ Ď\n¾ ℋ ⅆ\n∲ ≧̸</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "&#35; &#1234; &#992; &#0;")
  -- actual.Dump()
  expected = ::TestValueStruct "<p># Ӓ Ϡ �</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "&#X22; &#XD06; &#xcab;")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&quot; ആ ಫ</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "&nbsp &x; &#; &#x;\n&#87654321;\n&#abcdef0;\n&ThisIsNotDefined; &hi?;")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&amp;nbsp &amp;x; &amp;#; &amp;#x;\n&amp;#87654321;\n&amp;#abcdef0;\n&amp;ThisIsNotDefined; &amp;hi?;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "&copy")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&amp;copy</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "&MadeUpEntity;")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&amp;MadeUpEntity;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a href=\"&ouml;&ouml;.html\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<a href=\"&ouml;&ouml;.html\">"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo](/f&ouml;&ouml; \"f&ouml;&ouml;\")")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/f%C3%B6%C3%B6\" title=\"föö\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]\n\n[foo]: /f&ouml;&ouml; \"f&ouml;&ouml;\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/f%C3%B6%C3%B6\" title=\"föö\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "``` f&ouml;&ouml;\nfoo\n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code class=\"language-föö\">foo\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`f&ouml;&ouml;`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>f&amp;ouml;&amp;ouml;</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    f&ouml;f&ouml;")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>f&amp;ouml;f&amp;ouml;\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "&#42;foo&#42;\n*foo*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*foo*\n<em>foo</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "&#42; foo\n\n* foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>* foo</p>\n<ul>\n<li>foo</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo&#10;&#10;bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo\n\nbar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "&#9;foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>\tfoo</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[a](url &quot;tit&quot;)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[a](url &quot;tit&quot;)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- `one\n- two`")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>`one</li>\n<li>two`</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "***\n---\n___")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />\n<hr />\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "+++")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>+++</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "===")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>===</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "--\n**\n__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>--\n**\n__</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " ***\n  ***\n   ***")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />\n<hr />\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    ***")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>***\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n    ***")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo\n***</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_____________________________________")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " - - -")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " **  * ** * ** * **")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "-     -      -      -")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- - - -    ")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_ _ _ _ a\n\na------\n\n---a---")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>_ _ _ _ a</p>\n<p>a------</p>\n<p>---a---</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " *-*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>-</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n***\n- bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo</li>\n</ul>\n<hr />\n<ul>\n<li>bar</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n***\nbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo</p>\n<hr />\n<p>bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n---\nbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>Foo</h2>\n<p>bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "* Foo\n* * *\n* Bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>Foo</li>\n</ul>\n<hr />\n<ul>\n<li>Bar</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- Foo\n- * * *")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>Foo</li>\n<li><hr />\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "# foo\n## foo\n### foo\n#### foo\n##### foo\n###### foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>foo</h1>\n<h2>foo</h2>\n<h3>foo</h3>\n<h4>foo</h4>\n<h5>foo</h5>\n<h6>foo</h6>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "####### foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>####### foo</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "#5 bolt\n\n#hashtag")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>#5 bolt</p>\n<p>#hashtag</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "\## foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>## foo</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "# foo *bar* \*baz\*")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>foo <em>bar</em> *baz*</h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "#                  foo                     ")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>foo</h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " ### foo\n  ## foo\n   # foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<h3>foo</h3>\n<h2>foo</h2>\n<h1>foo</h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    # foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code># foo\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo\n    # bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo\n# bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "## foo ##\n  ###   bar    ###")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>foo</h2>\n<h3>bar</h3>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "# foo ##################################\n##### foo ##")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>foo</h1>\n<h5>foo</h5>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "### foo ###     ")
  -- actual.Dump()
  expected = ::TestValueStruct "<h3>foo</h3>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "### foo ### b")
  -- actual.Dump()
  expected = ::TestValueStruct "<h3>foo ### b</h3>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "# foo#")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>foo#</h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "### foo \###\n## foo #\##\n# foo \#")
  -- actual.Dump()
  expected = ::TestValueStruct "<h3>foo ###</h3>\n<h2>foo ###</h2>\n<h1>foo #</h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "****\n## foo\n****")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />\n<h2>foo</h2>\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo bar\n# baz\nBar foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo bar</p>\n<h1>baz</h1>\n<p>Bar foo</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "## \n#\n### ###")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2></h2>\n<h1></h1>\n<h3></h3>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo *bar*\n=========\n\nFoo *bar*\n---------")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>Foo <em>bar</em></h1>\n<h2>Foo <em>bar</em></h2>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo *bar\nbaz*\n====")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>Foo <em>bar\nbaz</em></h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  Foo *bar\nbaz*\t\n====")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>Foo <em>bar\nbaz</em></h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n-------------------------\n\nFoo\n=")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>Foo</h2>\n<h1>Foo</h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "   Foo\n---\n\n  Foo\n-----\n\n  Foo\n  ===")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>Foo</h2>\n<h2>Foo</h2>\n<h1>Foo</h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    Foo\n    ---\n\n    Foo\n---")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>Foo\n---\n\nFoo\n</code></pre>\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n   ----      ")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>Foo</h2>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n    ---")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo\n---</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n= =\n\nFoo\n--- -")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo\n= =</p>\n<p>Foo</p>\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo  \n-----")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>Foo</h2>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\\\n----")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>Foo\</h2>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`Foo\n----\n`\n\n<a title=\"a lot\n---\nof dashes\"/>")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>`Foo</h2>\n<p>`</p>\n<h2>&lt;a title=&quot;a lot</h2>\n<p>of dashes&quot;/&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> Foo\n---")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>Foo</p>\n</blockquote>\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> foo\nbar\n===")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>foo\nbar\n===</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- Foo\n---")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>Foo</li>\n</ul>\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\nBar\n---")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>Foo\nBar</h2>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "---\nFoo\n---\nBar\n---\nBaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />\n<h2>Foo</h2>\n<h2>Bar</h2>\n<p>Baz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "\n====")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>====</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "---\n---")
  -- actual.Dump()
  expected = ::TestValueStruct "<hr />\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n-----")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo</li>\n</ul>\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    foo\n---")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>foo\n</code></pre>\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> foo\n-----")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>foo</p>\n</blockquote>\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "\> foo\n------")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>&gt; foo</h2>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n\nbar\n---\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo</p>\n<h2>bar</h2>\n<p>baz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\nbar\n\n---\n\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo\nbar</p>\n<hr />\n<p>baz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\nbar\n* * *\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo\nbar</p>\n<hr />\n<p>baz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\nbar\n\---\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo\nbar\n---\nbaz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    a simple\n      indented code block")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>a simple\n  indented code block\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  - foo\n\n    bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>foo</p>\n<p>bar</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1.  foo\n\n    - bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li><p>foo</p>\n<ul>\n<li>bar</li>\n</ul>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    <a/>\n    *hi*\n\n    - one")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>&lt;a/&gt;\n*hi*\n\n- one\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    chunk1\n\n    chunk2\n  \n \n \n    chunk3")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>chunk1\n\nchunk2\n\n\n\nchunk3\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    chunk1\n      \n      chunk2")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>chunk1\n  \n  chunk2\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n    bar\n")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo\nbar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    foo\nbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>foo\n</code></pre>\n<p>bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "# Heading\n    foo\nHeading\n------\n    foo\n----")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>Heading</h1>\n<pre><code>foo\n</code></pre>\n<h2>Heading</h2>\n<pre><code>foo\n</code></pre>\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "        foo\n    bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>    foo\nbar\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "\n    \n    foo\n    \n")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>foo\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    foo  ")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>foo  \n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```\n<\n >\n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>&lt;\n &gt;\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "~~~\n<\n >\n~~~")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>&lt;\n &gt;\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "``\nfoo\n``")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>foo</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```\naaa\n~~~\n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\n~~~\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "~~~\naaa\n```\n~~~")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\n```\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "````\naaa\n```\n``````")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\n```\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "~~~~\naaa\n~~~\n~~~~")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\n~~~\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code></code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`````\n\n```\naaa")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>\n```\naaa\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> ```\n> aaa\n\nbbb")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<pre><code>aaa\n</code></pre>\n</blockquote>\n<p>bbb</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```\n\n  \n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>\n  \n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```\n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code></code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " ```\n aaa\naaa\n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\naaa\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  ```\naaa\n  aaa\naaa\n  ```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\naaa\naaa\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "   ```\n   aaa\n    aaa\n  aaa\n   ```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\n aaa\naaa\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    ```\n    aaa\n    ```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>```\naaa\n```\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```\naaa\n  ```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "   ```\naaa\n  ```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```\naaa\n    ```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\n    ```\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "``` ```\naaa")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code> </code>\naaa</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "~~~~~~\naaa\n~~~ ~~")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\n~~~ ~~\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo\n```\nbar\n```\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo\n---\n~~~\nbar\n~~~\n# baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<h2>foo</h2>\n<pre><code>bar\n</code></pre>\n<h1>baz</h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```ruby\ndef foo(x)\n  return 3\nend\n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "~~~~    ruby startline=3 $%@#$\ndef foo(x)\n  return 3\nend\n~~~~~~~")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "````;\n````")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code class=\"language-;\"></code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "``` aa ```\nfoo")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>aa</code>\nfoo</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "~~~ aa ``` ~~~\nfoo\n~~~")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code class=\"language-aa\">foo\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```\n``` aaa\n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>``` aaa\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<table><tr><td>\n<pre>\n**Hello**,\n\n_world_.\n</pre>\n</td></tr></table>")
  -- actual.Dump()
  expected = ::TestValueStruct "<table><tr><td>\n<pre>\n**Hello**,\n<p><em>world</em>.\n</pre></p>\n</td></tr></table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table>\n\nokay.")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table>\n<p>okay.</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " <div>\n  *hello*\n         <foo><a>")
  -- actual.Dump()
  expected = ::TestValueStruct " <div>\n  *hello*\n         <foo><a>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "</div>\n*foo*")
  -- actual.Dump()
  expected = ::TestValueStruct "</div>\n*foo*"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<DIV CLASS=\"foo\">\n\n*Markdown*\n\n</DIV>")
  -- actual.Dump()
  expected = ::TestValueStruct "<DIV CLASS=\"foo\">\n<p><em>Markdown</em></p>\n</DIV>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div id=\"foo\"\n  class=\"bar\">\n</div>")
  -- actual.Dump()
  expected = ::TestValueStruct "<div id=\"foo\"\n  class=\"bar\">\n</div>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div id=\"foo\" class=\"bar\n  baz\">\n</div>")
  -- actual.Dump()
  expected = ::TestValueStruct "<div id=\"foo\" class=\"bar\n  baz\">\n</div>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div>\n*foo*\n\n*bar*")
  -- actual.Dump()
  expected = ::TestValueStruct "<div>\n*foo*\n<p><em>bar</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div id=\"foo\"\n*hi*")
  -- actual.Dump()
  expected = ::TestValueStruct "<div id=\"foo\"\n*hi*"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div class\nfoo")
  -- actual.Dump()
  expected = ::TestValueStruct "<div class\nfoo"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div *???-&&&-<---\n*foo*")
  -- actual.Dump()
  expected = ::TestValueStruct "<div *???-&&&-<---\n*foo*"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div><a href=\"bar\">*foo*</a></div>")
  -- actual.Dump()
  expected = ::TestValueStruct "<div><a href=\"bar\">*foo*</a></div>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<table><tr><td>\nfoo\n</td></tr></table>")
  -- actual.Dump()
  expected = ::TestValueStruct "<table><tr><td>\nfoo\n</td></tr></table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div></div>\n``` c\nint x = 33;\n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<div></div>\n``` c\nint x = 33;\n```"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a href=\"foo\">\n*bar*\n</a>")
  -- actual.Dump()
  expected = ::TestValueStruct "<a href=\"foo\">\n*bar*\n</a>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<Warning>\n*bar*\n</Warning>")
  -- actual.Dump()
  expected = ::TestValueStruct "<Warning>\n*bar*\n</Warning>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<i class=\"foo\">\n*bar*\n</i>")
  -- actual.Dump()
  expected = ::TestValueStruct "<i class=\"foo\">\n*bar*\n</i>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "</ins>\n*bar*")
  -- actual.Dump()
  expected = ::TestValueStruct "</ins>\n*bar*"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<del>\n*foo*\n</del>")
  -- actual.Dump()
  expected = ::TestValueStruct "<del>\n*foo*\n</del>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<del>\n\n*foo*\n\n</del>")
  -- actual.Dump()
  expected = ::TestValueStruct "<del>\n<p><em>foo</em></p>\n</del>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<del>*foo*</del>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><del><em>foo</em></del></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<pre language=\"haskell\"><code>\nimport Text.HTML.TagSoup\n\nmain :: IO ()\nmain = print $ parseTags tags\n</code></pre>\nokay")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre language=\"haskell\"><code>\nimport Text.HTML.TagSoup\n\nmain :: IO ()\nmain = print $ parseTags tags\n</code></pre>\n<p>okay</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<script type=\"text/javascript\">\n// JavaScript example\n\ndocument.getElementById(\"demo\").innerHTML = \"Hello JavaScript!\";\n</script>\nokay")
  -- actual.Dump()
  expected = ::TestValueStruct "<script type=\"text/javascript\">\n// JavaScript example\n\ndocument.getElementById(\"demo\").innerHTML = \"Hello JavaScript!\";\n</script>\n<p>okay</p>"
  assert (actual.Equals expected == true)
  -- CommonMarkの結果とは異なる（Markdigの仕様）
  actual = ::TestValueStruct (testObj.ToHtml "<textarea>\n\n*foo*\n\n_bar_\n\n</textarea>")
  -- actual.Dump()
  -- expected = ::TestValueStruct "<textarea>\n\n*foo*\n\n_bar_\n\n</textarea>"
  expected = ::TestValueStruct "<textarea>\n<p><em>foo</em></p>\n<p><em>bar</em></p>\n</textarea>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<style\n  type=\"text/css\">\nh1 {color:red;}\n\np {color:blue;}\n</style>\nokay")
  -- actual.Dump()
  expected = ::TestValueStruct "<style\n  type=\"text/css\">\nh1 {color:red;}\n\np {color:blue;}\n</style>\n<p>okay</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<style\n  type=\"text/css\">\n\nfoo")
  -- actual.Dump()
  expected = ::TestValueStruct "<style\n  type=\"text/css\">\n\nfoo"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> <div>\n> foo\n\nbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<div>\nfoo\n</blockquote>\n<p>bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- <div>\n- foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><div>\n</li>\n<li>foo</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<style>p{color:red;}</style>\n*foo*")
  -- actual.Dump()
  expected = ::TestValueStruct "<style>p{color:red;}</style>\n<p><em>foo</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<!-- foo -->*bar*\n*baz*")
  -- actual.Dump()
  expected = ::TestValueStruct "<!-- foo -->*bar*\n<p><em>baz</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<script>\nfoo\n</script>1. *bar*")
  -- actual.Dump()
  expected = ::TestValueStruct "<script>\nfoo\n</script>1. *bar*"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<!-- Foo\n\nbar\n   baz -->\nokay")
  -- actual.Dump()
  expected = ::TestValueStruct "<!-- Foo\n\nbar\n   baz -->\n<p>okay</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<?php\n\n  echo '>';\n\n?>\nokay")
  -- actual.Dump()
  expected = ::TestValueStruct "<?php\n\n  echo '>';\n\n?>\n<p>okay</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<!DOCTYPE html>")
  -- actual.Dump()
  expected = ::TestValueStruct "<!DOCTYPE html>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<![CDATA[\nfunction matchwo(a,b)\n{\n  if (a < b && a < 0) then {\n    return 1;\n\n  } else {\n\n    return 0;\n  }\n}\n]]>\nokay")
  -- actual.Dump()
  expected = ::TestValueStruct "<![CDATA[\nfunction matchwo(a,b)\n{\n  if (a < b && a < 0) then {\n    return 1;\n\n  } else {\n\n    return 0;\n  }\n}\n]]>\n<p>okay</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  <!-- foo -->\n\n    <!-- foo -->")
  -- actual.Dump()
  expected = ::TestValueStruct "  <!-- foo -->\n<pre><code>&lt;!-- foo --&gt;\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  <div>\n\n    <div>")
  -- actual.Dump()
  expected = ::TestValueStruct "  <div>\n<pre><code>&lt;div&gt;\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n<div>\nbar\n</div>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo</p>\n<div>\nbar\n</div>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div>\nbar\n</div>\n*foo*")
  -- actual.Dump()
  expected = ::TestValueStruct "<div>\nbar\n</div>\n*foo*"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n<a href=\"bar\">\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo\n<a href=\"bar\">\nbaz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div>\n\n*Emphasized* text.\n\n</div>")
  -- actual.Dump()
  expected = ::TestValueStruct "<div>\n<p><em>Emphasized</em> text.</p>\n</div>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<div>\n*Emphasized* text.\n</div>")
  -- actual.Dump()
  expected = ::TestValueStruct "<div>\n*Emphasized* text.\n</div>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<table>\n\n<tr>\n\n<td>\nHi\n</td>\n\n</tr>\n\n</table>")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<tr>\n<td>\nHi\n</td>\n</tr>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<table>\n\n  <tr>\n\n    <td>\n      Hi\n    </td>\n\n  </tr>\n\n</table>")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n  <tr>\n<pre><code>&lt;td&gt;\n  Hi\n&lt;/td&gt;\n</code></pre>\n  </tr>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /url \"title\"\n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "   [foo]: \n      /url  \n           'the title'  \n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"the title\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[Foo*bar\]]:my_(url) 'title (with parens)'\n\n[Foo*bar\]]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"my_(url)\" title=\"title (with parens)\">Foo*bar]</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[Foo bar]:\n<my url>\n'title'\n\n[Foo bar]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"my%20url\" title=\"title\">Foo bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /url '\ntitle\nline1\nline2\n'\n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"\ntitle\nline1\nline2\n\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /url 'title\n\nwith blank line'\n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo]: /url 'title</p>\n<p>with blank line'</p>\n<p>[foo]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]:\n/url\n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]:\n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo]:</p>\n<p>[foo]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: <>\n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: <bar>(baz)\n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo]: <bar>(baz)</p>\n<p>[foo]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /url\bar\*baz \"foo\\\"bar\baz\"\n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url%5Cbar*baz\" title=\"foo&quot;bar\baz\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]\n\n[foo]: url")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"url\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]\n\n[foo]: first\n[foo]: second")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"first\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[FOO]: /url\n\n[Foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\">Foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[ΑΓΩ]: /φου\n\n[αγω]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/%CF%86%CE%BF%CF%85\">αγω</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /url")
  -- actual.Dump()
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[\nfoo\n]: /url\nbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /url \"title\" ok")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo]: /url &quot;title&quot; ok</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /url\n\"title\" ok")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&quot;title&quot; ok</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    [foo]: /url \"title\"\n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>[foo]: /url &quot;title&quot;\n</code></pre>\n<p>[foo]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```\n[foo]: /url\n```\n\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>[foo]: /url\n</code></pre>\n<p>[foo]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n[bar]: /baz\n\n[bar]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo\n[bar]: /baz</p>\n<p>[bar]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "# [Foo]\n[foo]: /url\n> bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1><a href=\"/url\">Foo</a></h1>\n<blockquote>\n<p>bar</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /url\nbar\n===\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<h1>bar</h1>\n<p><a href=\"/url\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /url\n===\n[foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>===\n<a href=\"/url\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /foo-url \"foo\"\n[bar]: /bar-url\n  \"bar\"\n[baz]: /baz-url\n\n[foo],\n[bar],\n[baz]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/foo-url\" title=\"foo\">foo</a>,\n<a href=\"/bar-url\" title=\"bar\">bar</a>,\n<a href=\"/baz-url\">baz</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]\n\n> [foo]: /url")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\">foo</a></p>\n<blockquote>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "aaa\n\nbbb")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>aaa</p>\n<p>bbb</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "aaa\nbbb\n\nccc\nddd")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>aaa\nbbb</p>\n<p>ccc\nddd</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "aaa\n\n\nbbb")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>aaa</p>\n<p>bbb</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  aaa\n bbb")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>aaa\nbbb</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "aaa\n             bbb\n                                       ccc")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>aaa\nbbb\nccc</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "   aaa\nbbb")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>aaa\nbbb</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    aaa\nbbb")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>aaa\n</code></pre>\n<p>bbb</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "aaa     \nbbb     ")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>aaa<br />\nbbb</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  \n\naaa\n  \n\n# aaa\n\n  ")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>aaa</p>\n<h1>aaa</h1>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> # Foo\n> bar\n> baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "># Foo\n>bar\n> baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "   > # Foo\n   > bar\n > baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    > # Foo\n    > bar\n    > baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>&gt; # Foo\n&gt; bar\n&gt; baz\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> # Foo\n> bar\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> bar\nbaz\n> foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>bar\nbaz\nfoo</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> foo\n---")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>foo</p>\n</blockquote>\n<hr />"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> - foo\n- bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<ul>\n<li>foo</li>\n</ul>\n</blockquote>\n<ul>\n<li>bar</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml ">     foo\n    bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<pre><code>foo\n</code></pre>\n</blockquote>\n<pre><code>bar\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> ```\nfoo\n```")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<pre><code></code></pre>\n</blockquote>\n<p>foo</p>\n<pre><code></code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> foo\n    - bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>foo\n- bar</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml ">")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml ">\n>  \n> ")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml ">\n> foo\n>  ")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>foo</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> foo\n\n> bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>foo</p>\n</blockquote>\n<blockquote>\n<p>bar</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> foo\n> bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>foo\nbar</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> foo\n>\n> bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>foo</p>\n<p>bar</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo\n> bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo</p>\n<blockquote>\n<p>bar</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> aaa\n***\n> bbb")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>aaa</p>\n</blockquote>\n<hr />\n<blockquote>\n<p>bbb</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> bar\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>bar\nbaz</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> bar\n\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>bar</p>\n</blockquote>\n<p>baz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> bar\n>\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<p>bar</p>\n</blockquote>\n<p>baz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> > > foo\nbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<blockquote>\n<blockquote>\n<p>foo\nbar</p>\n</blockquote>\n</blockquote>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml ">>> foo\n> bar\n>>baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<blockquote>\n<blockquote>\n<p>foo\nbar\nbaz</p>\n</blockquote>\n</blockquote>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml ">     code\n\n>    not code")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<pre><code>code\n</code></pre>\n</blockquote>\n<blockquote>\n<p>not code</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "A paragraph\nwith two lines.\n\n    indented code\n\n> A block quote.")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1.  A paragraph\n    with two lines.\n\n        indented code\n\n    > A block quote.")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li><p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- one\n\n two")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>one</li>\n</ul>\n<p>two</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- one\n\n  two")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>one</p>\n<p>two</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " -    one\n\n     two")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>one</li>\n</ul>\n<pre><code> two\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " -    one\n\n      two")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>one</p>\n<p>two</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "   > > 1.  one\n>>\n>>     two")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<blockquote>\n<ol>\n<li><p>one</p>\n<p>two</p>\n</li>\n</ol>\n</blockquote>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml ">>- one\n>>\n  >  > two")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<blockquote>\n<ul>\n<li>one</li>\n</ul>\n<p>two</p>\n</blockquote>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "-one\n\n2.two")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>-one</p>\n<p>2.two</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n\n\n  bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>foo</p>\n<p>bar</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1.  foo\n\n    ```\n    bar\n    ```\n\n    baz\n\n    > bam")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li><p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>\n<blockquote>\n<p>bam</p>\n</blockquote>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- Foo\n\n      bar\n\n\n      baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>Foo</p>\n<pre><code>bar\n\n\nbaz\n</code></pre>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "123456789. ok")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol start=\"123456789\">\n<li>ok</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1234567890. not ok")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>1234567890. not ok</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "0. ok")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol start=\"0\">\n<li>ok</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "003. ok")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol start=\"3\">\n<li>ok</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "-1. not ok")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>-1. not ok</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n\n      bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>foo</p>\n<pre><code>bar\n</code></pre>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  10.  foo\n\n           bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol start=\"10\">\n<li><p>foo</p>\n<pre><code>bar\n</code></pre>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    indented code\n\nparagraph\n\n    more code")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1.     indented code\n\n   paragraph\n\n       more code")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li>\n<pre><code>indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1.      indented code\n\n   paragraph\n\n       more code")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li>\n<pre><code> indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "   foo\n\nbar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo</p>\n<p>bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "-    foo\n\n  bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo</li>\n</ul>\n<p>bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "-  foo\n\n   bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>foo</p>\n<p>bar</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "-\n  foo\n-\n  ```\n  bar\n  ```\n-\n      baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo</li>\n<li>\n<pre><code>bar\n</code></pre>\n</li>\n<li>\n<pre><code>baz\n</code></pre>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "-   \n  foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "-\n\n  foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li></li>\n</ul>\n<p>foo</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n-\n- bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n-   \n- bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1. foo\n2.\n3. bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li></li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo\n*\n\nfoo\n1.")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo\n*</p>\n<p>foo\n1.</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " 1.  A paragraph\n     with two lines.\n\n         indented code\n\n     > A block quote.")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li><p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  1.  A paragraph\n      with two lines.\n\n          indented code\n\n      > A block quote.")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li><p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "   1.  A paragraph\n       with two lines.\n\n           indented code\n\n       > A block quote.")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li><p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "    1.  A paragraph\n        with two lines.\n\n            indented code\n\n        > A block quote.")
  -- actual.Dump()
  expected = ::TestValueStruct "<pre><code>1.  A paragraph\n    with two lines.\n\n        indented code\n\n    &gt; A block quote.\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  1.  A paragraph\nwith two lines.\n\n          indented code\n\n      > A block quote.")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li><p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  1.  A paragraph\n    with two lines.")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li>A paragraph\nwith two lines.</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> 1. > Blockquote\ncontinued here.")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<ol>\n<li>\n<blockquote>\n<p>Blockquote\ncontinued here.</p>\n</blockquote>\n</li>\n</ol>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "> 1. > Blockquote\n> continued here.")
  -- actual.Dump()
  expected = ::TestValueStruct "<blockquote>\n<ol>\n<li>\n<blockquote>\n<p>Blockquote\ncontinued here.</p>\n</blockquote>\n</li>\n</ol>\n</blockquote>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n  - bar\n    - baz\n      - boo")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>baz\n<ul>\n<li>boo</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n - bar\n  - baz\n   - boo")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo</li>\n<li>bar</li>\n<li>baz</li>\n<li>boo</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "10) foo\n    - bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol start=\"10\">\n<li>foo\n<ul>\n<li>bar</li>\n</ul>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "10) foo\n   - bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol start=\"10\">\n<li>foo</li>\n</ol>\n<ul>\n<li>bar</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- - foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>\n<ul>\n<li>foo</li>\n</ul>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1. - 2. foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li>\n<ul>\n<li>\n<ol start=\"2\">\n<li>foo</li>\n</ol>\n</li>\n</ul>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- # Foo\n- Bar\n  ---\n  baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><h1>Foo</h1>\n</li>\n<li><h2>Bar</h2>\nbaz</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n- bar\n+ baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo</li>\n<li>bar</li>\n</ul>\n<ul>\n<li>baz</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1. foo\n2. bar\n3) baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li>foo</li>\n<li>bar</li>\n</ol>\n<ol start=\"3\">\n<li>baz</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo\n- bar\n- baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo</p>\n<ul>\n<li>bar</li>\n<li>baz</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "The number of windows in my house is\n14.  The number of doors is 6.")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>The number of windows in my house is\n14.  The number of doors is 6.</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "The number of windows in my house is\n1.  The number of doors is 6.")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>The number of windows in my house is</p>\n<ol>\n<li>The number of doors is 6.</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n\n- bar\n\n\n- baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>foo</p>\n</li>\n<li><p>bar</p>\n</li>\n<li><p>baz</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n  - bar\n    - baz\n\n\n      bim")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li><p>baz</p>\n<p>bim</p>\n</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- foo\n- bar\n\n<!-- -->\n\n- baz\n- bim")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>foo</li>\n<li>bar</li>\n</ul>\n<!-- -->\n<ul>\n<li>baz</li>\n<li>bim</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "-   foo\n\n    notcode\n\n-   foo\n\n<!-- -->\n\n    code")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>foo</p>\n<p>notcode</p>\n</li>\n<li><p>foo</p>\n</li>\n</ul>\n<!-- -->\n<pre><code>code\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a\n - b\n  - c\n   - d\n  - e\n - f\n- g")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n<li>d</li>\n<li>e</li>\n<li>f</li>\n<li>g</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1. a\n\n  2. b\n\n   3. c")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li><p>a</p>\n</li>\n<li><p>b</p>\n</li>\n<li><p>c</p>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a\n - b\n  - c\n   - d\n    - e")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n<li>d\n- e</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1. a\n\n  2. b\n\n    3. c")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li><p>a</p>\n</li>\n<li><p>b</p>\n</li>\n</ol>\n<pre><code>3. c\n</code></pre>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a\n- b\n\n- c")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>a</p>\n</li>\n<li><p>b</p>\n</li>\n<li><p>c</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "* a\n*\n\n* c")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>a</p>\n</li>\n<li></li>\n<li><p>c</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a\n- b\n\n  c\n- d")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>a</p>\n</li>\n<li><p>b</p>\n<p>c</p>\n</li>\n<li><p>d</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a\n- b\n\n  [ref]: /url\n- d")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>a</p>\n</li>\n<li><p>b</p>\n</li>\n<li><p>d</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a\n- ```\n  b\n\n\n  ```\n- c")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>a</li>\n<li>\n<pre><code>b\n\n\n</code></pre>\n</li>\n<li>c</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a\n  - b\n\n    c\n- d")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>a\n<ul>\n<li><p>b</p>\n<p>c</p>\n</li>\n</ul>\n</li>\n<li>d</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "* a\n  > b\n  >\n* c")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>a\n<blockquote>\n<p>b</p>\n</blockquote>\n</li>\n<li>c</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a\n  > b\n  ```\n  c\n  ```\n- d")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>a\n<blockquote>\n<p>b</p>\n</blockquote>\n<pre><code>c\n</code></pre>\n</li>\n<li>d</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>a</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a\n  - b")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li>a\n<ul>\n<li>b</li>\n</ul>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "1. ```\n   foo\n   ```\n\n   bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<ol>\n<li>\n<pre><code>foo\n</code></pre>\n<p>bar</p>\n</li>\n</ol>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "* foo\n  * bar\n\n  baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>foo</p>\n<ul>\n<li>bar</li>\n</ul>\n<p>baz</p>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "- a\n  - b\n  - c\n\n- d\n  - e\n  - f")
  -- actual.Dump()
  expected = ::TestValueStruct "<ul>\n<li><p>a</p>\n<ul>\n<li>b</li>\n<li>c</li>\n</ul>\n</li>\n<li><p>d</p>\n<ul>\n<li>e</li>\n<li>f</li>\n</ul>\n</li>\n</ul>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`hi`lo`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>hi</code>lo`</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`foo`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>foo</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`` foo ` bar ``")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>foo ` bar</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "` `` `")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>``</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`  ``  `")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code> `` </code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "` a`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code> a</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "` b `")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code> b </code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "` `\n`  `")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code> </code>\n<code>  </code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "``\nfoo\nbar  \nbaz\n``")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>foo bar   baz</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "``\nfoo \n``")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>foo </code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`foo   bar \nbaz`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>foo   bar  baz</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`foo\`bar`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>foo\</code>bar`</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "``foo`bar``")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>foo`bar</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "` foo `` bar `")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>foo `` bar</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo`*`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*foo<code>*</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[not a `link](/foo`)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[not a <code>link](/foo</code>)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`<a href=\"`\">`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a href=\"`\">`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"`\">`</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`<http://foo.bar.`baz>`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>&lt;http://foo.bar.</code>baz&gt;`</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<http://foo.bar.`baz>`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"http://foo.bar.%60baz\">http://foo.bar.`baz</a>`</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "```foo``")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>```foo``</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`foo")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>`foo</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`foo``bar``")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>`foo<code>bar</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo bar*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo bar</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a * foo bar*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>a * foo bar*</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a*\"foo\"*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>a*&quot;foo&quot;*</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "* a *")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>* a *</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo*bar*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo<em>bar</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "5*6*78")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>5<em>6</em>78</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_foo bar_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo bar</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_ foo bar_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>_ foo bar_</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a_\"foo\"_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>a_&quot;foo&quot;_</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo_bar_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo_bar_</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "5_6_78")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>5_6_78</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "пристаням_стремятся_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>пристаням_стремятся_</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "aa_\"bb\"_cc")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>aa_&quot;bb&quot;_cc</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo-_(bar)_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo-<em>(bar)</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_foo*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>_foo*</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo bar *")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*foo bar *</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo bar\n*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*foo bar\n*</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*(*foo)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*(*foo)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*(*foo*)*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>(<em>foo</em>)</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo*bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo</em>bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_foo bar _")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>_foo bar _</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_(_foo)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>_(_foo)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_(_foo_)_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>(<em>foo</em>)</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_foo_bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>_foo_bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_пристаням_стремятся")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>_пристаням_стремятся</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_foo_bar_baz_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo_bar_baz</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_(bar)_.")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>(bar)</em>.</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo bar**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo bar</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "** foo bar**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>** foo bar**</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a**\"foo\"**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>a**&quot;foo&quot;**</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo**bar**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo<strong>bar</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo bar__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo bar</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__ foo bar__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>__ foo bar__</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__\nfoo bar__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>__\nfoo bar__</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a__\"foo\"__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>a__&quot;foo&quot;__</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo__bar__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo__bar__</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "5__6__78")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>5__6__78</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "пристаням__стремятся__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>пристаням__стремятся__</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo, __bar__, baz__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo, <strong>bar</strong>, baz</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo-__(bar)__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo-<strong>(bar)</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo bar **")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>**foo bar **</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**(**foo)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>**(**foo)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*(**foo**)*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>(<strong>foo</strong>)</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**Gomphocarpus (*Gomphocarpus physocarpus*, syn.\n*Asclepias physocarpa*)**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.\n<em>Asclepias physocarpa</em>)</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo \"*bar*\" foo**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo**bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo</strong>bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo bar __")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>__foo bar __</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__(__foo)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>__(__foo)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_(__foo__)_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>(<strong>foo</strong>)</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo__bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>__foo__bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__пристаням__стремятся")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>__пристаням__стремятся</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo__bar__baz__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo__bar__baz</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__(bar)__.")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>(bar)</strong>.</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo [bar](/url)*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo <a href=\"/url\">bar</a></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo\nbar*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo\nbar</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_foo __bar__ baz_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo <strong>bar</strong> baz</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_foo _bar_ baz_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo <em>bar</em> baz</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo_ bar_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em><em>foo</em> bar</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo *bar**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo <em>bar</em></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo **bar** baz*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo <strong>bar</strong> baz</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo**bar**baz*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo<strong>bar</strong>baz</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo**bar*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo**bar</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "***foo** bar*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em><strong>foo</strong> bar</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo **bar***")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo <strong>bar</strong></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo**bar***")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo<strong>bar</strong></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo***bar***baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo<em><strong>bar</strong></em>baz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo******bar*********baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo<strong><strong><strong>bar</strong></strong></strong>***baz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo **bar *baz* bim** bop*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo [*bar*](/url)*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo <a href=\"/url\"><em>bar</em></a></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "** is not an empty emphasis")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>** is not an empty emphasis</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**** is not an empty strong emphasis")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>**** is not an empty strong emphasis</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo [bar](/url)**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo <a href=\"/url\">bar</a></strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo\nbar**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo\nbar</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo _bar_ baz__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo <em>bar</em> baz</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo __bar__ baz__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo <strong>bar</strong> baz</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "____foo__ bar__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong><strong>foo</strong> bar</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo **bar****")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo <strong>bar</strong></strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo *bar* baz**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo <em>bar</em> baz</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo*bar*baz**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo<em>bar</em>baz</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "***foo* bar**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong><em>foo</em> bar</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo *bar***")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo <em>bar</em></strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo *bar **baz**\nbim* bop**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo <em>bar <strong>baz</strong>\nbim</em> bop</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo [*bar*](/url)**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo <a href=\"/url\"><em>bar</em></a></strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__ is not an empty emphasis")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>__ is not an empty emphasis</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "____ is not an empty strong emphasis")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>____ is not an empty strong emphasis</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo ***")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo ***</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo *\**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <em>*</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo *_*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <em>_</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo *****")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo *****</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo **\***")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <strong>*</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo **_**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <strong>_</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*<em>foo</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo</em>*</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "***foo**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*<strong>foo</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "****foo*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>***<em>foo</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo***")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo</strong>*</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo****")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo</em>***</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo ___")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo ___</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo _\__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <em>_</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo _*_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <em>*</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo _____")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo _____</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo __\___")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <strong>_</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo __*__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <strong>*</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>_<em>foo</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_foo__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo</em>_</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "___foo__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>_<strong>foo</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "____foo_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>___<em>foo</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo___")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo</strong>_</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_foo____")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo</em>___</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*_foo_*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em><em>foo</em></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__foo__")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong>foo</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_*foo*_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em><em>foo</em></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "****foo****")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong><strong>foo</strong></strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "____foo____")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong><strong>foo</strong></strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "******foo******")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><strong><strong><strong>foo</strong></strong></strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "***foo***")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em><strong>foo</strong></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_____foo_____")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em><strong><strong>foo</strong></strong></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo _bar* baz_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo _bar</em> baz_</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo __bar *baz bim__ bam*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo <strong>bar *baz bim</strong> bam</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**foo **bar baz**")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>**foo <strong>bar baz</strong></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo *bar baz*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*foo <em>bar baz</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*[bar*](/url)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*<a href=\"/url\">bar*</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_foo [bar_](/url)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>_foo <a href=\"/url\">bar_</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*<img src=\"foo\" title=\"*\"/>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*<img src=\"foo\" title=\"*\"/></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**<a href=\"**\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>**<a href=\"**\"></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__<a href=\"__\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>__<a href=\"__\"></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*a `*`*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>a <code>*</code></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "_a `_`_")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>a <code>_</code></em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "**a<http://foo.bar/?q=**>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>**a<a href=\"http://foo.bar/?q=**\">http://foo.bar/?q=**</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "__a<http://foo.bar/?q=__>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>__a<a href=\"http://foo.bar/?q=__\">http://foo.bar/?q=__</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](/uri \"title\")")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\" title=\"title\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[](./target.md)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"./target.md\"></a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link]()")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](<>)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[]()")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"\"></a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](/my uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[link](/my uri)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](</my uri>)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/my%20uri\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](foo\nbar)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[link](foo\nbar)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](<foo\nbar>)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[link](<foo\nbar>)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[a](<b)c>)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"b)c\">a</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](<foo\>)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[link](&lt;foo&gt;)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[a](<b)c\n[a](<b)c>\n[a](<b>c)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[a](&lt;b)c\n[a](&lt;b)c&gt;\n[a](<b>c)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](\(foo\))")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"(foo)\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](foo(and(bar)))")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"foo(and(bar))\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](foo(and(bar))")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[link](foo(and(bar))</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](foo\(and\(bar\))")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"foo(and(bar)\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](<foo(and(bar)>)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"foo(and(bar)\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](foo\)\:)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"foo):\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](#fragment)\n\n[link](http://example.com#fragment)\n\n[link](http://example.com?foo=3#frag)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"#fragment\">link</a></p>\n<p><a href=\"http://example.com#fragment\">link</a></p>\n<p><a href=\"http://example.com?foo=3#frag\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](foo\bar)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"foo%5Cbar\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](foo%20b&auml;)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"foo%20b%C3%A4\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](\"title\")")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"%22title%22\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](/url \"title\")\n[link](/url 'title')\n[link](/url (title))")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\">link</a>\n<a href=\"/url\" title=\"title\">link</a>\n<a href=\"/url\" title=\"title\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](/url \"title \\\"&quot;\")")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title &quot;&quot;\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](/url \"title\")")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url%C2%A0%22title%22\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](/url \"title \"and\" title\")")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](/url 'title \"and\" title')")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title &quot;and&quot; title\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link](   /uri\n  \"title\"  )")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\" title=\"title\">link</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link] (/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[link] (/uri)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link [foo [bar]]](/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\">link [foo [bar]]</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link] bar](/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[link] bar](/uri)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link [bar](/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[link <a href=\"/uri\">bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link \[bar](/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\">link [bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link *foo **bar** `#`*](/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[![moon](moon.jpg)](/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\" /></a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo [bar](/uri)](/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo <a href=\"/uri\">bar</a>](/uri)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo *[bar [baz](/uri)](/uri)*](/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo <em>[bar <a href=\"/uri\">baz</a>](/uri)</em>](/uri)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![[[foo](uri1)](uri2)](uri3)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"uri3\" alt=\"[foo](uri2)\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*[foo*](/uri)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*<a href=\"/uri\">foo*</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo *bar](baz*)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"baz*\">foo *bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo [bar* baz]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo [bar</em> baz]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo <bar attr=\"](baz)\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo <bar attr=\"](baz)\"></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo`](/uri)`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo<code>](/uri)</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo<http://example.com/?search=](uri)>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo<a href=\"http://example.com/?search=%5D(uri)\">http://example.com/?search=](uri)</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][bar]\n\n[bar]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link [foo [bar]]][ref]\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\">link [foo [bar]]</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link \[bar][ref]\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\">link [bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[link *foo **bar** `#`*][ref]\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[![moon](moon.jpg)][ref]\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\" /></a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo [bar](/uri)][ref]\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo <a href=\"/uri\">bar</a>]<a href=\"/uri\">ref</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo *bar [baz][ref]*][ref]\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo <em>bar <a href=\"/uri\">baz</a></em>]<a href=\"/uri\">ref</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*[foo*][ref]\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*<a href=\"/uri\">foo*</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo *bar][ref]*\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\">foo *bar</a>*</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo <bar attr=\"][ref]\">\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo <bar attr=\"][ref]\"></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo`][ref]`\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo<code>][ref]</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo<http://example.com/?search=][ref]>\n\n[ref]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo<a href=\"http://example.com/?search=%5D%5Bref%5D\">http://example.com/?search=][ref]</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][BaR]\n\n[bar]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\">foo</a></p>"
  assert (actual.Equals expected == true)
  -- CommonMarkの結果とは異なる（Markdigの仕様）
  actual = ::TestValueStruct (testObj.ToHtml "[ẞ]\n\n[SS]: /url")
  -- actual.Dump()
  -- expected = ::TestValueStruct "<p><a href=\"/url\">ẞ</a></p>"
  expected = ::TestValueStruct "<p>[ẞ]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[Foo\n  bar]: /url\n\n[Baz][Foo bar]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\">Baz</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo] [bar]\n\n[bar]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo] <a href=\"/url\" title=\"title\">bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]\n[bar]\n\n[bar]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo]\n<a href=\"/url\" title=\"title\">bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]: /url1\n\n[foo]: /url2\n\n[bar][foo]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url1\">bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[bar][foo\!]\n\n[foo!]: /url")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[bar][foo!]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][ref[]\n\n[ref[]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo][ref[]</p>\n<p>[ref[]: /uri</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][ref[bar]]\n\n[ref[bar]]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo][ref[bar]]</p>\n<p>[ref[bar]]: /uri</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[[[foo]]]\n\n[[[foo]]]: /url")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[[[foo]]]</p>\n<p>[[[foo]]]: /url</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][ref\[]\n\n[ref\[]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/uri\">foo</a></p>"
  assert (actual.Equals expected == true)
  -- CommonMarkの結果とは異なる（Markdigの仕様）
  actual = ::TestValueStruct (testObj.ToHtml "[bar\\]: /uri\n\n[bar\\]")
  -- actual.Dump()
  -- expected = ::TestValueStruct "<p><a href=\"/uri\">bar\</a></p>"
  expected = ::TestValueStruct "<p>[bar]: /uri</p>\n<p>[bar]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[]\n\n[]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[]</p>\n<p>[]: /uri</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[\n ]\n\n[\n ]: /uri")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[\n]</p>\n<p>[\n]: /uri</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[*foo* bar][]\n\n[*foo* bar]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\"><em>foo</em> bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[Foo][]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\">Foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo] \n[]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\">foo</a>\n[]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[*foo* bar]\n\n[*foo* bar]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\"><em>foo</em> bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[[*foo* bar]]\n\n[*foo* bar]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[<a href=\"/url\" title=\"title\"><em>foo</em> bar</a>]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[[bar [foo]\n\n[foo]: /url")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[[bar <a href=\"/url\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[Foo]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\" title=\"title\">Foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo] bar\n\n[foo]: /url")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url\">foo</a> bar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "\[foo]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo*]: /url\n\n*[foo*]")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>*<a href=\"/url\">foo*</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][bar]\n\n[foo]: /url1\n[bar]: /url2")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url2\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][]\n\n[foo]: /url1")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url1\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo]()\n\n[foo]: /url1")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo](not a link)\n\n[foo]: /url1")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url1\">foo</a>(not a link)</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][bar][baz]\n\n[baz]: /url")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo]<a href=\"/url\">bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][bar][baz]\n\n[baz]: /url1\n[bar]: /url2")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"/url2\">foo</a><a href=\"/url1\">baz</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "[foo][bar][baz]\n\n[baz]: /url1\n[foo]: /url2")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>[foo]<a href=\"/url1\">bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo](/url \"title\")")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo *bar*]\n\n[foo *bar*]: train.jpg \"train & tracks\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo ![bar](/url)](/url2)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url2\" alt=\"foo bar\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo [bar](/url)](/url2)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url2\" alt=\"foo bar\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo *bar*][]\n\n[foo *bar*]: train.jpg \"train & tracks\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo *bar*][foobar]\n\n[FOOBAR]: train.jpg \"train & tracks\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo](train.jpg)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"train.jpg\" alt=\"foo\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "My ![foo bar](/path/to/train.jpg  \"title\"   )")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>My <img src=\"/path/to/train.jpg\" alt=\"foo bar\" title=\"title\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo](<url>)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"url\" alt=\"foo\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![](/url)")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo][bar]\n\n[bar]: /url")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"foo\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo][bar]\n\n[BAR]: /url")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"foo\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo][]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![*foo* bar][]\n\n[*foo* bar]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"foo bar\" title=\"title\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![Foo][]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"Foo\" title=\"title\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo] \n[]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"foo\" title=\"title\" />\n[]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![foo]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![*foo* bar]\n\n[*foo* bar]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"foo bar\" title=\"title\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![[foo]]\n\n[[foo]]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>![[foo]]</p>\n<p>[[foo]]: /url &quot;title&quot;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "![Foo]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><img src=\"/url\" alt=\"Foo\" title=\"title\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "!\[foo]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>![foo]</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "\![foo]\n\n[foo]: /url \"title\"")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>!<a href=\"/url\" title=\"title\">foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<http://foo.bar.baz>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"http://foo.bar.baz\">http://foo.bar.baz</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<http://foo.bar.baz/test?q=hello&id=22&boolean>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean\">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<irc://foo.bar:2233/baz>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"irc://foo.bar:2233/baz\">irc://foo.bar:2233/baz</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<MAILTO:FOO@BAR.BAZ>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"MAILTO:FOO@BAR.BAZ\">MAILTO:FOO@BAR.BAZ</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a+b+c:d>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"a+b+c:d\">a+b+c:d</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<made-up-scheme://foo,bar>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"made-up-scheme://foo,bar\">made-up-scheme://foo,bar</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<http://../>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"http://../\">http://../</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<localhost:5001/foo>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"localhost:5001/foo\">localhost:5001/foo</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<http://foo.bar/baz bim>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;http://foo.bar/baz bim&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<http://example.com/\[\>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"http://example.com/%5C%5B%5C\">http://example.com/\[\</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<foo@bar.example.com>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"mailto:foo@bar.example.com\">foo@bar.example.com</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<foo+special@Bar.baz-bar0.com>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"mailto:foo+special@Bar.baz-bar0.com\">foo+special@Bar.baz-bar0.com</a></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<foo\+@bar.example.com>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;foo+@bar.example.com&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "< http://foo.bar >")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt; http://foo.bar &gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<m:abc>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;m:abc&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<foo.bar.baz>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;foo.bar.baz&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "http://example.com")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>http://example.com</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo@bar.example.com")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo@bar.example.com</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a><bab><c2c>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a><bab><c2c></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a/><b2/>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a/><b2/></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a  /><b2\ndata=\"foo\" >")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a  /><b2\ndata=\"foo\" ></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a foo=\"bar\" bam = 'baz <em>\"</em>'\n_boolean zoop:33=zoop:33 />")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a foo=\"bar\" bam = 'baz <em>\"</em>'\n_boolean zoop:33=zoop:33 /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo <responsive-image src=\"foo.jpg\" />")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo <responsive-image src=\"foo.jpg\" /></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<33> <__>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;33&gt; &lt;__&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a h*#ref=\"hi\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a href=\"hi'> <a href=hi'>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;a href=&quot;hi'&gt; &lt;a href=hi'&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "< a><\nfoo><bar/ >\n<foo bar=baz\nbim!bop />")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt; a&gt;&lt;\nfoo&gt;&lt;bar/ &gt;\n&lt;foo bar=baz\nbim!bop /&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a href='bar'title=title>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;a href='bar'title=title&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "</a></foo >")
  -- actual.Dump()
  expected = ::TestValueStruct "<p></a></foo ></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "</a href=\"foo\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;/a href=&quot;foo&quot;&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo <!-- this is a\ncomment - with hyphen -->")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <!-- this is a\ncomment - with hyphen --></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo <!-- not a comment -- two hyphens -->")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo <!--> foo -->\n\nfoo <!-- foo--->")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo &lt;!--&gt; foo --&gt;</p>\n<p>foo &lt;!-- foo---&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo <?php echo $a; ?>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <?php echo $a; ?></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo <!ELEMENT br EMPTY>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <!ELEMENT br EMPTY></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo <![CDATA[>&<]]>")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <![CDATA[>&<]]></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo <a href=\"&ouml;\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <a href=\"&ouml;\"></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo <a href=\"\*\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo <a href=\"\*\"></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a href=\"\\\"\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>&lt;a href=&quot;&quot;&quot;&gt;</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo  \nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo<br />\nbaz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo\\\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo<br />\nbaz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo       \nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo<br />\nbaz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo  \n     bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo<br />\nbar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo\\\n     bar")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo<br />\nbar</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo  \nbar*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo<br />\nbar</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "*foo\\\nbar*")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><em>foo<br />\nbar</em></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`code  \nspan`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>code   span</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "`code\\\nspan`")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><code>code\ span</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a href=\"foo  \nbar\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"foo  \nbar\"></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "<a href=\"foo\\\nbar\">")
  -- actual.Dump()
  expected = ::TestValueStruct "<p><a href=\"foo\\\nbar\"></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo\\")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo\</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo  ")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "### foo\\")
  -- actual.Dump()
  expected = ::TestValueStruct "<h3>foo\</h3>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "### foo  ")
  -- actual.Dump()
  expected = ::TestValueStruct "<h3>foo</h3>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo\nbaz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo\nbaz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "foo \n baz")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>foo\nbaz</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "hello $.;'there")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>hello $.;'there</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Foo χρῆν")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Foo χρῆν</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "Multiple     spaces")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>Multiple     spaces</p>"
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
