-- require('lspsaga').init_lsp_saga()

vim.cmd [[
  nnoremap <silent> gh <cmd>lua require('lspsaga.provider').lsp_finder()<CR>
  nnoremap <silent> ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
  vnoremap <silent> ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
  nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
  nnoremap <silent> gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
]]
