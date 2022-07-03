# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name          = 'extconf_compiler_commands_json'
  s.version       = '0.0.1'
  s.summary       = 'Generate clangd compiler_commands.json files for gems'
  s.description   = <<~DESCRIPTION
    The extconf_compiler_commands_json gem allows you to easily generate
    compatible compiler_commands.json files from your extconf.rb file. This
    makes it easy to use the clangd LSP when working on your gem.
  DESCRIPTION
  s.authors       = ['KJ Tsanaktsidis']
  s.email         = 'kj@kjtsanaktsidis.id.au'
  s.license       = 'MIT'

  s.required_ruby_version = '>= 2.6.0'
  s.add_development_dependancy 'standard', '~> 1.12'
  s.add_development_dependancy 'rubocop', '~> 1.31'
end
