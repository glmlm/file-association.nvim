local plugin = require('file-association')

describe('setup', function()
  it('works with default', function()
    assert(plugin.open_with() == 1, 'my first function with param = 1')
  end)

  it('works with custom var', function()
    plugin.setup({ exts = { ['/path/to/app'] = { 'ext' } } })
    assert(plugin.open_with() == 0, 'my first function with param = 0')
  end)
end)
