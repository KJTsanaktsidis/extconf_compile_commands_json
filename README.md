# extconf_compile_commands_json

This simple gem generates a clangd-compatible `compile_commands.json` file from the extconf.rb file of a native gem. It's purpose is to enable clangd/LSP to work better when developing native Ruby extension gems.

# Method 1: modifying extconf.rb

Just add this to your extconf.rb file _after_ your `create_makefile` invocation:

```ruby
require 'extconf_compile_commands_json'
ExtconfCompileCommandsJson.generate!
```

That will write out a `compile_commands.json` file to the same directory that mkmf generated your Makefile in.

If you're using `rake-compiler` to compile your project, that will be in `tmp/${arch}/${gem_name}/${ruby_version}/compile_commands.json`; you will probably want to symlink that file into the root of your project so that clangd can find it. This can be done by calling symlink!; so:


```ruby
require 'extconf_compile_commands_json'
ExtconfCompileCommandsJson.generate!
ExtconfCompileCommandsJson.symlink!
```

# Method 2: without modifying extconf.rb

Modifying extconf.rb is fine if you own all the build config for your project, but if, for example, you're working on somebody else's project and don't want to modify their extconf.rb, you can still use extconf_compile_commands_json! Something like the following should work, if using rake-compiler:

```shell
RUBYOPT="$RUBYOPT $(gem which extconf_compile_commands_json/autoload)" bundle exec rake compile
```

That will load up extconf_compile_commands_json as a patch on mkmf and inject it into any Ruby process that your Rake invocation spawns.
