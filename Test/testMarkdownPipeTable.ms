/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
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
  actual = ::TestValueStruct (testObj.ToHtml "a | b\n-- | -\n0 | 1")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a | b\n- | -\n0 | 1")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a | b\n-- | --")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a | b\n-- | --\n-- | --")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>--</td>\n<td>--</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a b\nc | d\ne | f")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>a b\nc | d\ne | f</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a | b\nc no d")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>a | b\nc no d</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a  | b \n-- | --\n0  | 1 | 2\n3  | 4\n5  |")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n<th></th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n<td>2</td>\n</tr>\n<tr>\n<td>3</td>\n<td>4</td>\n<td></td>\n</tr>\n<tr>\n<td>5</td>\n<td></td>\n<td></td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a          | b              |\n-- | --\n0      | 1       |")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "  a     | b     |\n--      | --\n| 0     | 1\n| 2     | 3     |\n  4     | 5 ")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n</tr>\n<tr>\n<td>2</td>\n<td>3</td>\n</tr>\n<tr>\n<td>4</td>\n<td>5</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "|a|b|\n|-|-|\n|0|1|")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a|b|\n-|-|\n0|1|")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "|a|b\n|-|-\n|0|1")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "| a\n| --\n| b\n| c ")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>b</td>\n</tr>\n<tr>\n<td>c</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " a     | b \n-------|-------\n 0     | 1 \n 2     | 3 ")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n</tr>\n<tr>\n<td>2</td>\n<td>3</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " a     | b       | c \n:------|:-------:| ----:\n 0     | 1       | 2 \n 3     | 4       | 5 ")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th style=\"text-align: left;\">a</th>\n<th style=\"text-align: center;\">b</th>\n<th style=\"text-align: right;\">c</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td style=\"text-align: left;\">0</td>\n<td style=\"text-align: center;\">1</td>\n<td style=\"text-align: right;\">2</td>\n</tr>\n<tr>\n<td style=\"text-align: left;\">3</td>\n<td style=\"text-align: center;\">4</td>\n<td style=\"text-align: right;\">5</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "| abc | def | ghi |\n|:---:|-----|----:|\n|  1  | 2   | 3   |")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th style=\"text-align: center;\">abc</th>\n<th>def</th>\n<th style=\"text-align: right;\">ghi</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td style=\"text-align: center;\">1</td>\n<td>2</td>\n<td style=\"text-align: right;\">3</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " a     | b\n-------|---x---\n 0     | 1\n 2     | 3 ")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>a     | b\n-------|---x---\n0     | 1\n2     | 3</p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml " *a*   | b\n-----  |-----\n 0     | _1_\n _2    | 3* ")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th><em>a</em></th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td><em>1</em></td>\n</tr>\n<tr>\n<td>_2</td>\n<td>3*</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a | b `\n0 | ` ")
  -- actual.Dump()
  expected = ::TestValueStruct "<p>a | b <code>0 |</code></p>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a <a href=\"\" title=\"|\"></a> | b\n-- | --\n0  | 1")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a <a href=\"\" title=\"|\"></a></th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a  | b\n-- | --\n[This is a link with a | inside the label](http://google.com) | 1")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td><a href=\"http://google.com\">This is a link with a | inside the label</a></td>\n<td>1</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a  | b\n-- | --")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n</tr>\n</thead>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "|a|b|c\n|---|---|---|")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n<th>c</th>\n</tr>\n</thead>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "| abc | def | \n|---|---|\n| cde| ddd| \n| eee| fff|\n| fff | fffff   | \n|gggg  | ffff | ")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>abc</th>\n<th>def</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>cde</td>\n<td>ddd</td>\n</tr>\n<tr>\n<td>eee</td>\n<td>fff</td>\n</tr>\n<tr>\n<td>fff</td>\n<td>fffff</td>\n</tr>\n<tr>\n<td>gggg</td>\n<td>ffff</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  --
  actual = ::TestValueStruct (testObj.ToHtml "a | b\n-- | - \n0 | 1 | 2")
  -- actual.Dump()
  expected = ::TestValueStruct "<table>\n<thead>\n<tr>\n<th>a</th>\n<th>b</th>\n<th></th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>0</td>\n<td>1</td>\n<td>2</td>\n</tr>\n</tbody>\n</table>"
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
