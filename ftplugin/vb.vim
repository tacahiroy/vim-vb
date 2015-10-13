" Language: Visual Basic 6
" Description: Visual Basic 6 filetype plugin
" Maintainer: Takahiro Yoshihara <tacahiroy@gmail.com>
" Last Change: 13-May-2010.
" License: The BSD 2-Clause License
" Copyright (c) 2010, Takahiro Yoshihara
" All rights reserved.

" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:

" * Redistributions of source code must retain the above copyright notice, this
"   list of conditions and the following disclaimer.

" * Redistributions in binary form must reproduce the above copyright notice,
"   this list of conditions and the following disclaimer in the documentation
"   and/or other materials provided with the distribution.

" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
" SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
" CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
" OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
" OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if exists('b:did_vb_ftplugin')
  finish
endif
let b:did_vb_ftplugin = 1

function! s:vbpChoice(dir)
  let res = globpath(a:dir, '*.vbp')
  if len(res) == 0
    echomsg 'No vbp files found.'
    return ''
  endif

  let vbps = split(res, "\n")
  if len(vbps) == 1
    return vbps[0]
  endif

  let vbps = map(vbps, 'printf("%2d: %s", v:key+1, v:val)')
  call insert(vbps, "\nPlease select a vbp >", 0)

  let choice = ''
  while len(choice) == 0
    let ans = inputlist(vbps)
    if ans == 0
      return ''
    endif

    if ans !~# '^\d\{1,2}$'
      continue
    endif
    let choice = get(vbps, str2nr(ans), '')
  endwhile

  echom substitute(choice, '^\s*\d\+\s*:', '', '')
  return substitute(choice, '^\s*\d\+\s*:', '', '')
endfunction

if !exists(':Vbp')
  command! -buffer -nargs=0 Vbp let vbp = s:vbpChoice('.') | if 0 < len(vbp) | call system(' start "" ' . vbp) | endif
endif

if !exists('no_plugin_maps') && !exists('no_vb_maps')
  nnoremap <buffer> <F5> :Vbp<Cr>
endif

setlocal commentstring='\ %s
setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
else
  let b:undo_ftplugin = '|'
endif
