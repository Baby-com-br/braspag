require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

GEM = "braspag"
GEM_VERSION = "0.0.1"
SUMMARY = "Access the Braspag webservices using Ruby"
AUTHOR = "Concrete/Gonow"
EMAIL = "lucabastos@gmail.com;renato.elias@gmail.com"
HOMEPAGE = "http://www.concretesolutions.com.br"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*.rb', '[A-Z]*'].to_a

  s.add_dependency 'httpi',  '>=0.9.4'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'nokogiri'

  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs -fh:doc/specs.html --color)
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Builds the project"
task :build => :spec
