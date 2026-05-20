# -*- encoding: utf-8 -*-
# stub: wcmc_components 0.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "wcmc_components".freeze
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "http://mygemserver.com" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ben Tregenna".freeze]
  s.date = "2022-04-26"
  s.description = "Contains rudimentary capabilites for importing CSVs and the backend for a filterable table component".freeze
  s.email = ["".freeze]
  s.homepage = "https://www.github.com/unepwcmc".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Summary of reusable components for UNEP-WCMC projects".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, [">= 5.2.3"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, [">= 5.2.3"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, [">= 5.2.3"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
  end
end
