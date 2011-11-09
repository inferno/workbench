# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "work_bench/version"

Gem::Specification.new do |s|
  s.name        = "work-bench"
  s.version     = Workbench::VERSION
  s.authors     = "Konstantin Savelyev"
  s.email       = "konstantin.savelyev@gmail.com"
  s.homepage    = "http://lenta.ru"
  s.summary     = "A quick and simple local web server for prototyping web applications."
  s.description = "A quick and simple local web server for prototyping web applications."

  s.rubyforge_project = "work-bench"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

	s.add_development_dependency "yard"
	s.add_development_dependency "maruku"

  s.add_dependency "rack"
	s.add_dependency "rack-test"
	s.add_dependency "unicorn"
	s.add_dependency "haml"
	s.add_dependency "compass"
	s.add_dependency "rack-cache"
	s.add_dependency "rack-contrib"
	s.add_dependency "thor"
end
