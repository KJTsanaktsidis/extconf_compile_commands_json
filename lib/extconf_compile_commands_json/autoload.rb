# frozen_string_literal: true

# Requiring this file will patch MkMf to auto-magically generate compile_commands.json.
# Handy to add to a RUBYOPT env var or such, so you can work on a project not using
# this gem but benefit from it yourself, without having to modify the existing build
# scripts.

require "mkmf"
# the require_relative looks stupid, but it ensures that you can load this patch
# simply by running adding -r/path/to/autoload.rb to your Ruby invocation without
# needing to muck about with $LOAD_PATH or Bundler.
require_relative "../extconf_compile_commands_json"

# We have to patch MakeMakefile directly, rather than prepending to it, because
# requiring mkmf includes it into the toplevel main object straight away. So prepending
# here would be too late.

module MakeMakefile
  alias_method :__extconfcc_orig_create_makefile, :create_makefile
  def create_makefile(...)
    r = __extconfcc_orig_create_makefile(...)
    ExtconfCompileCommandsJson.generate!
    ExtconfCompileCommandsJson.symlink!
    r
  end
end
