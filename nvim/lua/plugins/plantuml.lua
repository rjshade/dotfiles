return {
  'aklt/plantuml-syntax',
  ft = { 'plantuml', 'puml', 'uml', 'pu', 'iuml' },
  config = function()
    vim.g.plantuml_executable_script = 'plantuml'
    vim.g.plantuml_set_makeprg = 1
    
    -- Set up file type detection for PlantUML files
    vim.cmd([[
      autocmd BufRead,BufNewFile *.puml,*.pu,*.uml,*.plantuml,*.iuml setfiletype plantuml
      autocmd FileType plantuml setlocal commentstring=/'%s'/
      autocmd FileType plantuml setlocal shiftwidth=2
      autocmd FileType plantuml setlocal tabstop=2
      autocmd FileType plantuml setlocal expandtab
      autocmd FileType plantuml setlocal autoindent
      autocmd FileType plantuml setlocal smartindent
    ]])
    
  end,
}