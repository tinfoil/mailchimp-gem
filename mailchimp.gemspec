# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mailchimp/version"

Gem::Specification.new do |s|
  s.name        = "mailchimp"
  s.version     = Mailchimp::VERSION
  s.authors     = ["Tinfoil Security, Inc."]
  s.email       = ["engineers@tinfoilsecurity.com"]
  s.homepage    = ""
  s.summary     = %q{Mailchimp/Mandrill APIs in Ruby}
  s.description = %q{This provides Ruby access to the Mailchimp & Mandrill APIs}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('httparty')

  s.add_development_dependency('rake')
  s.add_development_dependency('shoulda')
  s.add_development_dependency('mocha')
  s.add_development_dependency('cover_me')
  s.add_development_dependency('fakeweb')
  s.add_development_dependency('geminabox')
end
