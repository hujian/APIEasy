# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nestful"
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex MacCaw"]
  s.date = "2012-01-05"
  s.description = "Simple Ruby HTTP/REST client with a sane API"
  s.email = "info@eribium.org"
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["README.markdown"]
  s.homepage = "http://github.com/maccman/nestful"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14.1"
  s.summary = "Simple Ruby HTTP/REST client with a sane API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0.beta"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.0.0.beta"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.0.0.beta"])
  end
end
