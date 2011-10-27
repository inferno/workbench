# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "workbench/version"

Gem::Specification.new do |s|
  s.name        = "workbench"
  s.version     = Workbench::VERSION
  s.authors     = ["Konstantin Savelyev"]
  s.email       = ["konstantin.savelyev@gmail.com"]
  s.homepage    = "http://lenta.ru"
  s.summary     = "A quick web server for prototyping."
  s.description = "A quick web server for prototyping."

  s.rubyforge_project = "workbench"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_dependency "rack"
	s.add_dependency "unicorn"
	s.add_dependency "haml"
	s.add_dependency "compass"
	s.add_dependency "rack-asset-compiler"
	s.add_dependency "rack-cache"
	s.add_dependency "fastimage"
end
