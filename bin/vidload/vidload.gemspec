require_relative "lib/vidload"

Gem::Specification.new do |s|
  s.name        = "vidload"
  s.version     = Vidload::VERSION
  s.authors     = ["Patacode <pata.codegineer@gmail.com>"]
  s.summary     = "Download videos from web to local"
  s.files       = Dir["lib/**/*.rb", "lib/**/*.sh"]
  s.require_paths = ["lib"]
  s.add_dependency "playwright-ruby-client", "~> 1.58"
  s.add_dependency "tty-spinner", "~> 0.9"
  s.add_dependency "m3u8", "~> 1.8"
  s.add_development_dependency "rake"
end
