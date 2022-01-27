" VIM-PLUG Setup {{{

" Automatic installation {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim/plugged')

" Plugins {{{
Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-obsession'
" Plug 'tpope/vim-unimpaired'
" Plug 'tpope/vim-characterize'
" Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
" Plug 'qstrahl/vim-matchmaker'
" Plug 'junegunn/goyo.vim'
" Plug 'tpope/vim-afterimage'
Plug 'fimkap/vim-mark'
Plug 'jacoborus/tender.vim'
Plug 'rakr/vim-one'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'metakirby5/codi.vim'
Plug 'inside/vim-search-pulse'
" Plug 'ryanoasis/vim-devicons'
Plug 'mhartington/oceanic-next'
Plug 'EdenEast/nightfox.nvim'
Plug 'famiu/feline.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" For vsnip users.
" Plug 'hrsh7th/cmp-vsnip'
" Plug 'hrsh7th/vim-vsnip'
" For luasnip users.
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'onsails/lspkind-nvim'
Plug 'doums/darcula'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'chentau/marks.nvim'
" Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }
" Plug 'tell-k/vim-autopep8'
" Plug 'sheerun/vim-polyglot'
call plug#end()

let mapleader      = ' '
let maplocalleader = ' '

filetype plugin indent on

set nobackup
set nowritebackup
set noswapfile
set autoread
set signcolumn=yes:2
set nowildmenu
set wildmode=list:longest,full
set ic
set smartcase
set cpoptions+=$            " dollar sign while changing
" set completeopt=longest,menu
set completeopt=menu,menuone,noselect
set nohls
set is
set diffopt=filler,vertical
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set report=1
"set guifont=PT\ Mono:h12
set pumheight=15            " limit popup menu height
set updatetime=750
set mousemodel=extend
set mouse=a
set hid
" enable max 100000 scrollback size in terminal
set scrollback=-1
set shortmess+=c
set guicursor=n:hor10,i-ci-ve:ver25
" colorscheme apprentice
colorscheme darcula

set termguicolors

lua <<EOF
require('feline').setup()
-- require'marks'.setup {
--   -- whether to map keybinds or not. default true
--   default_mappings = true,
--   -- which builtin marks to show. default {}
--   builtin_marks = { ".", "<", ">", "^" },
--   -- whether movements cycle back to the beginning/end of buffer. default true
--   cyclic = true,
--   -- whether the shada file is updated after modifying uppercase marks. default false
--   force_write_shada = false,
--   -- how often (in ms) to redraw signs/recompute mark positions. 
--   -- higher values will have better performance but may cause visual lag, 
--   -- while lower values may cause performance penalties. default 150.
--   refresh_interval = 250,
--   -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
--   -- marks, and bookmarks.
--   -- can be either a table with all/none of the keys, or a single number, in which case
--   -- the priority applies to all marks.
--   -- default 10.
--   sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
--   -- disables mark tracking for specific filetypes. default {}
--   excluded_filetypes = {},
--   -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
--   -- sign/virttext. Bookmarks can be used to group together positions and quickly move
--   -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
--   -- default virt_text is "".
--   bookmark_0 = {
--     sign = "",
--     virt_text = "Note"
--   },
--   mappings = {}
-- }
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '▍', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '▍', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '▂', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '▔', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '﬌', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
  }
EOF

" marks options
" highlight MarkSignHL guifg=#1922cf
" highlight MarkSignNumHL guifg=#1922cf

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local lspkind = require('lspkind')

  cmp.setup({
    formatting = {
      format = lspkind.cmp_format(),
    },
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local lsp_installer = require("nvim-lsp-installer")

  local nvim_lsp = require('lspconfig')

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  end

  -- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
  -- or if the server is already installed).
  lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = on_attach,
      }

    if server.name == "gopls" then
      opts = {
      on_attach = on_attach,
      cmd = {"gopls", "serve"},
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            },
          staticcheck = true,
          },
        },
      }
    end

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
  end)
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['pyright'].setup {
  --   capabilities = capabilities
  -- }
  -- require('lspconfig')['gopls'].setup {
  --   cmd = {"gopls", "serve"},
  --   settings = {
  --     gopls = {
  --       analyses = {
  --         unusedparams = true,
  --       },
  --       staticcheck = true,
  --     },
  --   },
  -- }
EOF

" Goyo Setup {{{
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2

" diff all
nnoremap <Leader>da :windo diffthis<CR>
" diff off (for all open windows)
nnoremap <Leader>do :windo diffoff<CR>
" }}}

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" nmap <Leader>gl :silent Glog -10 --<CR>:cwindow<CR>

" highlight Matchmaker guibg=aquamarine1

" Copy to clipboard
vnoremap  <leader>y  "+y

nnoremap <BS> :e #<CR>
" Hide tilde (sideeffect - hides all special symbols)
hi NonText ctermfg=235

" Terminal
nnoremap <leader>te :below 15sp term:///bin/zsh<cr>i
tnoremap <F1> <C-\><C-n>

vnoremap // y/<C-R>"<CR>

if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Paste fast in terminal from clipboard
nnoremap <F3> :read !pbpaste<CR>

" XML format
nmap <Leader>pxa :%!xmllint --format -<CR>
" JSON format
nmap <Leader>jf :%!python -m json.tool<CR>

nnoremap <leader>c :cclose<bar>lclose<cr>

if executable('ag')
  let &grepprg = 'ag --nogroup --nocolor --column --word-regexp'
else
  let &grepprg = 'grep -rn $* *'
endif
command! -nargs=1 -bar Grep execute 'silent! grep! <q-args>' | redraw! | copen

command! -bang -nargs=* Cs
  \ call fzf#vim#grep(
  \   'csearch -n '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:80%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
" ============================================================================
" FZF {{{
" ============================================================================
if has('nvim') || has('gui_running')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

command! -nargs=? -complete=dir AF
  \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
  \   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
  \ })))

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" let g:fzf_files_options =
            " \ '--preview "(termpix --width 50 --true-color {} || cat {}) 2> /dev/null "'

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" command! Ag call fzf#vim#ag('query', {'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all'})

" nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":GFiles\<cr>"
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>l        :Lines<CR>
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
nnoremap <silent> <Leader>`        :Marks<CR>
" nnoremap <silent> q: :History:<CR>
" nnoremap <silent> q/ :History/<CR>

inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

function! s:plug_help_sink(line)
  let dir = g:plugs[a:line].dir
  for pat in ['doc/*.txt', 'README.md']
    let match = get(split(globpath(dir, pat), "\n"), 0, '')
    if len(match)
      execute 'tabedit' match
      return
    endif
  endfor
  tabnew
  execute 'Explore' dir
endfunction

command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink':   function('s:plug_help_sink')}))

let s:ag_options = ' --smart-case --word-regexp '
command! -bang -nargs=+ -complete=dir Rag call fzf#vim#ag_raw(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let options = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let options = fzf#vim#with_preview(options, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, options, a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

let g:terminal_scrollback_buffer_size = 10000

nmap <Leader>gs :Gstatus<CR>
nmap <Leader>bm :bmodified<CR>

hi EndOfBuffer guibg=bg guifg=bg
hi VertSplit guibg=bg guifg=bg
hi LineNr guibg=bg
hi SignColumn guibg=bg

hi GitSignsAdd guifg=#294436
hi GitSignsChange guifg=#303C47
hi GitSignsDelete guifg=#484A4A

" hi Search guibg=bg guifg=fg
let g:vim_search_pulse_mode = 'pattern'
" let g:vim_search_pulse_color_list = ['#ffff1a', '#ffff33', '#ffff33', '#ffff33', '#ffff33']
" let g:vim_search_pulse_duration = 400

let g:python3_host_prog='/usr/local/bin/python3'
let g:python_host_prog='/usr/local/bin/python'

" nvim-tree setup
" let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
" let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
" let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
" let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
" let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
" let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
" let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
" let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
" let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
" let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
" let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
" let g:nvim_tree_create_in_closed_folder = 0 "1 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
" let g:nvim_tree_refresh_wait = 500 "1000 by default, control how often the tree can be refreshed, 1000 means the tree can be refresh once per 1000ms.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'notify',
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
" Dictionary of buffer option names mapped to a list of option values that
" indicates to the window picker that the buffer's window should not be
" selectable.
" let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
" let g:nvim_tree_show_icons = {
"     \ 'git': 1,
"     \ 'folders': 0,
"     \ 'files': 0,
"     \ 'folder_arrows': 0,
"     \ }
"If 0, do not show the icons for one of 'git' 'folder' and 'files'
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath.
"if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
"but this will not work when you set indent_markers (because of UI conflict)

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

nnoremap <C-n> :NvimTreeToggle<CR>
" nnoremap <leader>r :NvimTreeRefresh<CR>
" nnoremap <leader>n :NvimTreeFindFile<CR>
" NvimTreeOpen, NvimTreeClose, NvimTreeFocus, NvimTreeFindFileToggle, and NvimTreeResize are also available if you need them

set termguicolors " this variable must be enabled for colors to be applied properly

" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeWindowPicker guibg=#494949

lua <<EOF
  require'nvim-tree'.setup {
    show_icons = {
      git = 1,
      folders = 1,
      files = 1,
      folder_arrows = 1,
      tree_width = 30,
      },
    quit_on_open = 0,
    git_hl = 1,
    }
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "haskell" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
