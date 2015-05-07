# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'merch_calendar/version'

Gem::Specification.new do |s|
  s.name        = "merch_calendar"
  s.version     = MerchCalendar::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Stitch Fix Engineering']
  s.email       = ['eng@stitchfix.com']
  s.licenses    = ['MIT']
  s.homepage    = "http://www.stitchfix.com"
  s.summary     = "Utility for manipulating dates within a 4-5-4 retail calendar"
  s.description = "Utility for manipulating dates within a 4-5-4 retail calendar"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", ">= 3.0.0"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "pry"
end
