/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  fileIn "Markdown.ms"

  if isProperty ::startupLoader "RegisterScript" do (
    ::startupLoader.RegisterScript (getSourceFileName())
  )
  ok
)
