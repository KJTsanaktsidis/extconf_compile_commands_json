# frozen_string_literal: true

require "mkmf"
require "shellwords"
require "json"

module ExtconfCompileCommandsJson
  def self.generate_compile_commands_json
    mkmf_cflags = []
    # Start by expanding what's in our magic variables
    [$INCFLAGS, $CPPFLAGS, $CFLAGS, $COUTFLAGS].each do |v|
      next unless v
      mkmf_cflags.concat Shellwords.split(v)
    end
    # expand that with the contents of the ruby options
    mkmf_cflags.map! do |flag|
      flag
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
    end
    mkmf_cflags.reject! { |f| f.empty? }
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
end
