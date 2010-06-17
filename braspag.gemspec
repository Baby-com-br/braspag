# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{braspag}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gonow"]
  s.date = %q{2010-06-16}
  s.email = %q{labs@gonow.com.br}
  s.files = ["lib/braspag/connection.rb", "lib/braspag/cryptography.rb", "lib/braspag/gateway.rb", "lib/braspag/recorrente.rb", "lib/braspag/service.rb", "lib/braspag.rb", "Rakefile", "README.textile"]
  s.homepage = %q{http://www.gonow.com.br}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Access the Braspag webservices using Ruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubigen>, [">= 1.3.4"])
      s.add_runtime_dependency(%q<handsoap>, ["= 1.1.7"])
      s.add_runtime_dependency(%q<curb>, ["= 0.7.6"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<rubigen>, [">= 1.3.4"])
      s.add_dependency(%q<handsoap>, ["= 1.1.7"])
      s.add_dependency(%q<curb>, ["= 0.7.6"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<rubigen>, [">= 1.3.4"])
    s.add_dependency(%q<handsoap>, ["= 1.1.7"])
    s.add_dependency(%q<curb>, ["= 0.7.6"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end
