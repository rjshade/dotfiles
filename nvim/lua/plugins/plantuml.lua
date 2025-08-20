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
    
    -- Set up PlantUML preview
    local preview = require('plugins.plantuml-preview')
    preview.setup()
    
    -- Add keybinding for PlantUML preview
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "plantuml",
      callback = function()
        vim.keymap.set('n', '<leader>pl', preview.toggle_preview, { buffer = true, desc = 'Toggle PlantUML preview' })
      end,
    })
  end,
}