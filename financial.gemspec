# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "financial/version"

Gem::Specification.new do |s|
  s.name        = "financial"
  s.version     = Financial::VERSION
  s.authors     = ["Tomas D'Stefano"]
  s.email       = ["tomas_stefano@successoft.com"]
  s.homepage    = "https://github.com/tomas-stefano/financial"
  s.summary     = %q{Manage your money in the terminal with A Ruby DSL}
  s.description = %q{Manage your money in the terminal with A Ruby DSL}

  s.rubyforge_project = "financial"

  s.add_dependency(%q<terminal-table>, ["= 1.4.2"])

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
