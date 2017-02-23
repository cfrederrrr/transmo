root = File.dirname(__FILE__)
lib = File.join root, "lib"
require File.join(lib, "transmo/version")

Gem::Specification.new do |spec|
  spec.name         = "transmo"
  spec.version      = Transmo::Version.to_s
  spec.platform     = Gem::Platform::RUBY
  spec.authors      = ["Carl Frederick"]
  spec.email        = ["galvertez@gmail.com"]
  spec.homepage     = "http://github.com/galvertez/transmo"
  spec.summary      = "A Transmission RPC Client"
  spec.description  = File.read(File.join root, "README.md")
  spec.files        = Dir["#{lib}/**/*.rb"]
  spec.require_path = "lib"
  spec.licenses     = ["MIT"]
end
