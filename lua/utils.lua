local EXPORTS = {}

-- Create a keymap to run a (neo)vim cmd
-- `opts` is a table that must contain keys:
--   * `modes`,
--   * `cmd` the vim cmd
--   * `keystrokes`, the keystroke sequence
--   * `extra`, optional but highly recommended to set up documentation
EXPORTS.create_keymap_for_cmd = function(opts)
  return vim.keymap.set(opts.modes, opts.keystrokes, function()
    vim.cmd(opts.cmd)
  end, opts.extra or {})
end

-- Create a keymap to run a lua function
-- `opts` is a table that must contain keys:
--   * `modes`,
--   * `keystrokes`, the keystroke sequence
--   * `extra`, optional but highly recommended to set up documentation
-- `fn` is a callable that takes no arguments.
EXPORTS.create_keymap_for_fn = function(opts, fn)
  return vim.keymap.set(opts.modes, opts.keystrokes, fn, opts.extra or {})
end

return EXPORTS
