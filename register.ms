/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  ::markdown = (fileIn "Markdown.ms")()
  format "[define]::markdown\n"

  if isProperty ::startupScriptLoader "RegisterScript" do (
    ::startupScriptLoader.RegisterScript (getSourceFileName())
    ::startupScriptLoader.Save()
  )
  ok
)
