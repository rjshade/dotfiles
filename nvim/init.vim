" Plugins
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
Plug 'mhinz/vim-signify'              " Shows git status in sidebar.
Plug 'tpope/vim-commentary'           " Comment/uncomment easily.
Plug 'tpope/vim-fugitive'             " Git commands in vim.
Plug 'nvim-lua/plenary.nvim'          " Needed for telescope.nvim.
Plug 'nvim-telescope/telescope.nvim'  " Fuzzy file finder.
Plug 'neovim/nvim-lspconfig'          " Easy config for LSP.
Plug 'github/copilot.vim'             " Github's copilot code completion.
Plug 'jparise/vim-graphql'            " GraphQL syntax highlighting.
Plug 'kyazdani42/nvim-web-devicons'   " for file icons
Plug 'kyazdani42/nvim-tree.lua'       " for file tree
call plug#end()

" General settings.
let mapleader=","                     " Use , as the leader key.
set expandtab                         " Turn tabs into spaces.
set mouse=a                           " Mouse enabled all the time.
set nostartofline                     " Don't jump to start of line.
set number                            " Line numbers on
set scrolloff=10                      " Keep 5 context lines around cursor.
set shiftwidth=2                      " tab == 2 spaces.
set showmatch                         " Highlight matching braces.
set ignorecase                        " Case insensitive search...
set smartcase                         " ...unless search term has uppercase.
set smartindent
set softtabstop=2                     " Make spaces feel like tabs.
set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %=\ line:%l/%L\ col:%c\ %p%%
set tabstop=2                         " tab == 2 spaces.
set title                             " Terminal title.
set undolevels=100000                 " Set a bigger undo history.

" Sidebar file browser.
lua require'nvim-tree'.setup{}
nnoremap <leader>f :NvimTreeFindFile<CR>


" Pressing shift is too much work.
nnoremap ; :

" Use 2 space indentation in Python.
au FileType python setl shiftwidth=2 softtab

" When re-opening a file, automatically jump to last line used.
autocmd BufWinEnter * if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' |   exe 'normal! g`"zz' | endif

" Ctrl + hjkl to move between split windows.
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" Move up and down using visual lines rather than actual lines.
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" <leader>c to comment/uncomment lines
map <leader>c :Commentary<CR>

" Telescope fuzzy finder.
map <silent> ff :Telescope find_files<cr>| " search files in current directory
map <silent> ft :Telescope git_files<cr>|  " search files in current git repo
map <silent> fg :Telescope live_grep<cr>|  " search inside files
map <silent> fb :Telescope buffers<cr>|    " search open buffer file names

" NeoVim LSP config.
lua require'lspconfig'.tsserver.setup{}
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gh <cmd>lua vim.lsp.buf.hover()<CR>

" Colors.
colorscheme Tomorrow-Night
highlight clear SignColumn
highlight SignifySignAdd    ctermfg=112
highlight SignifySignDelete ctermfg=160
highlight SignifySignChange ctermfg=220

" Show trailing whitespace (except when typing at end of line).
highlight ExtraWhitespace ctermbg=yellow guibg=yellow
match ExtraWhitespace /\s\+\%#\@<!$/

" Briefly highlight yanked text.
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

" Source any machine-specific settings.
let VIMRC_LOCAL=expand("~/.config/local/vimrc")
if filereadable(VIMRC_LOCAL) | exe "source " . VIMRC_LOCAL | endif
