# extconf_compile_commands_json

This simple gem generates a clangd-compatible `compile_commands.json` file from the extconf.rb file of a native gem. It's purpose is to enable clangd/LSP to work better when developing native Ruby extension gems.

Just add this to your extconf.rb file _after_ your `create_makefile` invocation:

```ruby
require 'extconf_compile_commands_json'
ExtconfCompileCommandsJson.generate_compile_commands_json
```

That will write out a `compile_commands.json` file to the same directory that mkmf generated your Makefile in.

If you're using `rake-compiler` to compile your project, that will be in `tmp/${arch}/${gem_name}/${ruby_version}/compile_commands.json`; you will probably want to symlink that file into the root of your project so that clangd can find it. In the future I'll probably integrate something into rake-compiler that updates the symlink after each invocation of `rake compile` (so it works nicely when switching Ruby versions, etc).

