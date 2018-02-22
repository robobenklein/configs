" Vim color file - corobalt
" Generated by http://bytefluent.com/vivify 2018-02-21
set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "corobalt"

"hi CTagsMember -- no settings --
"hi CTagsGlobalConstant -- no settings --
"hi Ignore -- no settings --
hi Normal guifg=NONE guibg=#121212 guisp=#121212 gui=bold ctermfg=NONE ctermbg=233 cterm=bold
"hi CTagsImport -- no settings --
"hi CTagsGlobalVariable -- no settings --
"hi SpellRare -- no settings --
"hi EnumerationValue -- no settings --
"hi Union -- no settings --
"hi Question -- no settings --
"hi VisualNOS -- no settings --
"hi ModeMsg -- no settings --
"hi EnumerationName -- no settings --
"hi MoreMsg -- no settings --
"hi SpellCap -- no settings --
"hi SpellLocal -- no settings --
"hi DefinedName -- no settings --
"hi LocalVariable -- no settings --
"hi SpellBad -- no settings --
"hi CTagsClass -- no settings --
"hi Underlined -- no settings --
"hi clear -- no settings --
hi IncSearch guifg=#ffffff guibg=#005fff guisp=#005fff gui=NONE ctermfg=15 ctermbg=27 cterm=NONE
hi WildMenu guifg=NONE guibg=#909da8 guisp=#909da8 gui=NONE ctermfg=NONE ctermbg=109 cterm=NONE
hi SignColumn guifg=#1a1a1a guibg=#445291 guisp=#445291 gui=NONE ctermfg=234 ctermbg=60 cterm=NONE
hi SpecialComment guifg=#0088ff guibg=NONE guisp=NONE gui=bold,italic ctermfg=33 ctermbg=NONE cterm=bold
hi Typedef guifg=#40e0d0 guibg=NONE guisp=NONE gui=bold ctermfg=80 ctermbg=NONE cterm=bold
hi Title guifg=#ffffff guibg=NONE guisp=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi Folded guifg=#1a1a1a guibg=#909da8 guisp=#909da8 gui=italic ctermfg=234 ctermbg=109 cterm=NONE
hi PreCondit guifg=#c526ff guibg=NONE guisp=NONE gui=NONE ctermfg=13 ctermbg=NONE cterm=NONE
hi Include guifg=#c526ff guibg=NONE guisp=NONE gui=NONE ctermfg=13 ctermbg=NONE cterm=NONE
hi Float guifg=#ff0044 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi StatusLineNC guifg=#ffffff guibg=#000000 guisp=#000000 gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi NonText guifg=#2e373e guibg=NONE guisp=NONE gui=italic ctermfg=237 ctermbg=NONE cterm=NONE
hi DiffText guifg=NONE guibg=#0000af guisp=#0000af gui=bold ctermfg=NONE ctermbg=19 cterm=bold
hi ErrorMsg guifg=#ffffff guibg=#3f0000 guisp=#3f0000 gui=NONE ctermfg=15 ctermbg=52 cterm=NONE
hi Debug guifg=#8b8a7c guibg=NONE guisp=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
hi PMenuSbar guifg=NONE guibg=#767c88 guisp=#767c88 gui=NONE ctermfg=NONE ctermbg=60 cterm=NONE
hi Identifier guifg=#5fd7ff guibg=NONE guisp=NONE gui=NONE ctermfg=81 ctermbg=NONE cterm=NONE
hi SpecialChar guifg=#c526ff guibg=NONE guisp=NONE gui=bold ctermfg=13 ctermbg=NONE cterm=bold
hi Conditional guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi StorageClass guifg=#40e0d0 guibg=NONE guisp=NONE gui=bold,italic ctermfg=80 ctermbg=NONE cterm=bold
hi Todo guifg=#ffff00 guibg=#000000 guisp=#000000 gui=NONE ctermfg=11 ctermbg=NONE cterm=NONE
hi Special guifg=#5f87ff guibg=NONE guisp=NONE gui=bold ctermfg=69 ctermbg=NONE cterm=bold
hi LineNr guifg=#6c6c6c guibg=NONE guisp=NONE gui=NONE ctermfg=242 ctermbg=NONE cterm=NONE
hi StatusLine guifg=#ffffff guibg=#000000 guisp=#000000 gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi Label guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi PMenuSel guifg=#ffffff guibg=#0000ff guisp=#0000ff gui=NONE ctermfg=15 ctermbg=21 cterm=NONE
hi Search guifg=#ffffff guibg=#005fd7 guisp=#005fd7 gui=NONE ctermfg=15 ctermbg=26 cterm=NONE
hi Delimiter guifg=#8b8a7c guibg=NONE guisp=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
hi Statement guifg=#d700ff guibg=NONE guisp=NONE gui=bold ctermfg=165 ctermbg=NONE cterm=bold
hi Comment guifg=#00afff guibg=NONE guisp=NONE gui=italic ctermfg=39 ctermbg=NONE cterm=NONE
hi Character guifg=#ff0044 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi TabLineSel guifg=NONE guibg=#0000ff guisp=#0000ff gui=bold,underline ctermfg=NONE ctermbg=21 cterm=bold,underline
hi Number guifg=#c00000 guibg=NONE guisp=NONE gui=NONE ctermfg=1 ctermbg=NONE cterm=NONE
hi Boolean guifg=#ff0044 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi Operator guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi CursorLine guifg=NONE guibg=#1d2a30 guisp=#1d2a30 gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
hi TabLineFill guifg=NONE guibg=#121212 guisp=#121212 gui=bold ctermfg=NONE ctermbg=233 cterm=bold
hi WarningMsg guifg=#080808 guibg=#ffcc00 guisp=#ffcc00 gui=NONE ctermfg=232 ctermbg=220 cterm=NONE
hi DiffDelete guifg=#ff0044 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi CursorColumn guifg=NONE guibg=#1d2a30 guisp=#1d2a30 gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
hi Define guifg=#8b8a7c guibg=NONE guisp=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
hi Function guifg=#5fafff guibg=NONE guisp=NONE gui=bold ctermfg=75 ctermbg=NONE cterm=bold
hi FoldColumn guifg=#1a1a1a guibg=#909da8 guisp=#909da8 gui=italic ctermfg=234 ctermbg=109 cterm=NONE
hi PreProc guifg=#00ffff guibg=NONE guisp=NONE gui=NONE ctermfg=14 ctermbg=NONE cterm=NONE
hi Visual guifg=#1a1a1a guibg=#e4dfff guisp=#e4dfff gui=NONE ctermfg=234 ctermbg=189 cterm=NONE
hi VertSplit guifg=#1a1a1a guibg=#536570 guisp=#536570 gui=bold ctermfg=234 ctermbg=66 cterm=bold
hi Exception guifg=#d78700 guibg=NONE guisp=NONE gui=bold ctermfg=172 ctermbg=NONE cterm=bold
hi Keyword guifg=#ffdd00 guibg=NONE guisp=NONE gui=bold ctermfg=220 ctermbg=NONE cterm=bold
hi Type guifg=#5fffff guibg=NONE guisp=NONE gui=bold ctermfg=87 ctermbg=NONE cterm=bold
hi DiffChange guifg=NONE guibg=#444444 guisp=#444444 gui=NONE ctermfg=NONE ctermbg=238 cterm=NONE
hi Cursor guifg=#c0c0c0 guibg=#f9e0f5 guisp=#f9e0f5 gui=NONE ctermfg=7 ctermbg=225 cterm=NONE
hi Error guifg=#ffffff guibg=#3f0000 guisp=#3f0000 gui=NONE ctermfg=15 ctermbg=52 cterm=NONE
hi PMenu guifg=#ffffff guibg=#000000 guisp=#000000 gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi SpecialKey guifg=#ffdd00 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi Constant guifg=#d70000 guibg=NONE guisp=NONE gui=NONE ctermfg=160 ctermbg=NONE cterm=NONE
hi Tag guifg=#ff9d00 guibg=NONE guisp=NONE gui=NONE ctermfg=214 ctermbg=NONE cterm=NONE
hi String guifg=#5fd700 guibg=NONE guisp=NONE gui=NONE ctermfg=76 ctermbg=NONE cterm=NONE
hi PMenuThumb guifg=NONE guibg=#939aa8 guisp=#939aa8 gui=NONE ctermfg=NONE ctermbg=103 cterm=NONE
hi MatchParen guifg=#ffffff guibg=#d70061 guisp=#d70061 gui=bold ctermfg=15 ctermbg=161 cterm=bold
hi Repeat guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi Directory guifg=#5fafff guibg=NONE guisp=NONE gui=bold ctermfg=75 ctermbg=NONE cterm=bold
hi Structure guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi Macro guifg=#ffdd00 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi DiffAdd guifg=NONE guibg=#3a3a3a guisp=#3a3a3a gui=NONE ctermfg=NONE ctermbg=237 cterm=NONE
hi TabLine guifg=NONE guibg=#121212 guisp=#121212 gui=bold ctermfg=NONE ctermbg=233 cterm=bold
hi cursorim guifg=#1a1a1a guibg=#445291 guisp=#445291 gui=NONE ctermfg=234 ctermbg=60 cterm=NONE