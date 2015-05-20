$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "poring_backup/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "poring_backup"
  s.version     = PoringBackup::VERSION
  s.authors     = ["PiYa"]
  s.email       = ["piya23300@gmail.com"]
  s.homepage    = "https://github.com/piya23300/poring_backup"
  s.summary     = "backup support rails."
  s.description = "Poring Backup is database backup that support rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.2.1"
  s.add_dependency "pg"
  s.add_dependency "aws-sdk", '>= 2'
  s.add_dependency "logging", '>= 2.0.0'
end
