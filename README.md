# 🤝 File Association

**file-association.nvim** is a Lua plugin for Neovim that associates any application with extensions and allows you to open a file directory on a buffer.
It works on a regular buffer, Netrw and other file managers.

## ✨ Features

- Open the file using the string that represents the file directory on the buffer
- Open the file under the cursor in Netrw
- Create a function on the user's side that returns the full path of the file, and use it to open the file under the cursor in other file managers, etc.

## ⚡️ Requirements

- **Neovim** >= 0.10.0

## 📦 Installation

Install the plugin with your package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "glmlm/file-association.nvim",
  keys = {
    {
      'gX',
      '<cmd>FileAssociationOpen<CR>',
      desc = 'Open a file with user-associated application',
    },
    {
      'gy',
      '<cmd>CopyPathToClipboard<CR>',
      desc = 'Copy a filepath to the clipboard',
    },
  },
  opts = {
    ret_filepath = {
      -- NOTE: To make this plugin work on the buffer provided by your own file manager,
      -- you have to define a function that returns the full path of the file
      -- In this case, the key should be the one obtained by :lua print(vim.bo.filetype)

      -- Example for stevearc/oil.nvim:
      ['oil'] = function()
        local oil = require 'oil'
        local dir = oil.get_current_dir()
        local entry = oil.get_cursor_entry().name
        local filepath = dir .. entry
        return filepath
      end,
      -- Example for nvim-neo-tree/neo-tree.nvim:
      ['neo-tree'] = function()
        local state = require('neo-tree.sources.manager').get_state 'filesystem'
        local node = state.tree:get_node()
        local filepath = node:get_id()
        return filepath
      end,
    },
    exts = {
      -- NOTE: Enter the program directory as key,
      -- and the table of file extensions you want to open with it as value

      -- For example:
      -- ['/path/to/app'] = { 'ext' },
    },
    -- optional: You can change the file manager that opens when you select a folder directory
    -- filer = '/path/to/your_filer',
  },
}
```

## 🚀 Usage

Just type the key binding or the command :FileAssociatedOpen to open an application that is registered according to the extension.

## ❓ FAQ

* Why do I need to write a function to make this plugin work with the file manager plugin's buffer?
  * The main factor is attributed to licensing. Since each file manager plugin has its own way of getting paths, it would be necessary to exploit a dedicated API to obtain them. However, it should be noted that exploiting a third-party module could complicate the licensing of this project (GPL is a good example). To avoid such issues, this plugin allows the user to specify how to obtain the file path.

<!-- panvimdoc-ignore-start -->
## Acknowledgements
This plugin has been created using the [nvim-plugin-template](https://github.com/ellisonleao/nvim-plugin-template) (MIT license) as a template.
<!-- panvimdoc-ignore-end -->
