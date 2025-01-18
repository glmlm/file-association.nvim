vim.api.nvim_create_user_command('FileAssociationOpen', require('file-association').open_with, {})
vim.api.nvim_create_user_command('CopyPathToClipboard', require('file-association').copy_filepath, {})
