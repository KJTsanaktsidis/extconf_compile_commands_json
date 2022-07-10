# frozen_string_literal: true

require "mkmf"
require "shellwords"
require "json"
require "fileutils"

module ExtconfCompileCommandsJson
  def self.generate!
    # Start by expanding what's in our magic variables
    mkmf_cflags = [$INCFLAGS, $CPPFLAGS, $CFLAGS, $COUTFLAGS].map { |flag|
      # expand that with the contents of the ruby options
      (flag || "")
        .gsub("$(arch_hdrdir)", $arch_hdrdir || "")
        .gsub("$(hdrdir)", $hdrdir || "")
        .gsub("$(srcdir)", $srcdir || "")
        .gsub("$(cppflags)", RbConfig::CONFIG["cppflags"] || "")
        .gsub("$(DEFS)", RbConfig::CONFIG["DEFS"] || "")
        .gsub("$(cflags)", RbConfig::CONFIG["cflags"] || "")
        .gsub("$(cxxflags)", RbConfig::CONFIG["cxxflags"] || "")
        .gsub("$(optflags)", RbConfig::CONFIG["optflags"] || "")
        .gsub("$(debugflags)", RbConfig::CONFIG["debugflags"] || "")
        .gsub("$(warnflags)", RbConfig::CONFIG["warnflags"] || "")
        .gsub("$(empty)", "")
    }.flat_map { |flags|
      # Need to shellwords expand them (_after_ doing the $() subst's)
      Shellwords.split(flags)
    }.reject { |flag|
      flag.empty?
    }
    # This makes sure that #include "extconf.h" works
    mkmf_cflags = ["-iquote#{File.realpath(Dir.pwd)}"] + mkmf_cflags
    compile_commands = $srcs.map do |src|
      {
        directory: File.realpath(Dir.pwd),
        # Set the C compiler to "clang", always, since the whole point
        # of this file is to make clangd work.
        arguments: ["clang"] + mkmf_cflags + [src],
        file: src
      }
    end
    File.write("compile_commands.json", compile_commands.to_json)
  end

  # generate will put the compile_commands.json in the same folder as the
  # compiled output (and Makefile); symlink will create a symlink in the
  # same folder as the extconf.rb, so that clangd can find it.
  def self.symlink!
    # This is the same check mkmf does for deciding whether to spew errors onto your
    # terminal, so I figure it'll do for spewing symlinks into your directory too.
    return unless !$extmk && (/\A(extconf|makefile).rb\z/ =~ File.basename($0))
    extconf_dir = File.dirname $0
    compile_commands_file = File.realpath("./compile_commands.json")
    return unless File.exist? compile_commands_file
    FileUtils.ln_sf compile_commands_file, File.join(extconf_dir, "compile_commands.json")
  end
end
