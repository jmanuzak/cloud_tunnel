# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloud_tunnel/version'

Gem::Specification.new do |gem|
  gem.name          = "cloud_tunnel"
  gem.version       = CloudTunnel::VERSION
  gem.authors       = ["Jonathan Manuzak"]
  gem.email         = ["jonathan.manuzak@gmail.com"]
  gem.description   = %q{CloudFlare + LocalTunnel = magic}
  gem.summary       = %q{Connect persistent DNS cname to transient localtunnel}
  gem.homepage      = ""

  gem.add_dependency "localtunnel", "0.3"
  gem.add_dependency "daemons", "1.1.9"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
