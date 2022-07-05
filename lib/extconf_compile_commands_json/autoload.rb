# frozen_string_literal: true

# Requiring this file will patch MkMf to auto-magically generate compile_commands.json.
# Handy to add to a RUBYOPT env var or such, so you can work on a project not using
# this gem but benefit from it yourself, without having to modify the existing build
# scripts.

require "mkmf"
require "extconf_compile_commands_json"

module ExtconfCompileCommandsJson
  module AutoloadPatch
    def create_makefile(*args)
      super
      ExtconfCompileCommandsJson.generate!
      ExtconfCompileCommandsJson.symlink!
    end
  end
end

MakeMakefile.prepend ExtconfCompileCommandsJson::AutoloadPatch
