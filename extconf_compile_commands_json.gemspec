# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "extconf_compile_commands_json"
  s.version = "0.0.5"
  s.summary = "Generate clangd compile_commands.json files for gems"
  s.description = <<~DESCRIPTION
    The extconf_compile_commands_json gem allows you to easily generate
    compatible compile_commands.json files from your extconf.rb file. This
    makes it easy to use the clangd LSP when working on your gem.
  DESCRIPTION
  s.authors = ["KJ Tsanaktsidis"]
  s.email = "kj@kjtsanaktsidis.id.au"
  s.license = "MIT"
  s.homepage = "https://github.com/KJTsanaktsidis/extconf_compile_commands_json"

  s.files = %w[
    lib/extconf_compile_commands_json.rb
    lib/extconf_compile_commands_json/autoload.rb
  ]

  s.required_ruby_version = ">= 2.6.0"
  s.add_development_dependency "standard", "~> 1.12"
end
