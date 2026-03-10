Gem::Specification.new do |s|
  s.name        = "vidload"
  s.version     = "0.1.4"
  s.authors     = ["Patacode"]
  s.summary     = "Download videos from web to local"
  s.files       = Dir["lib/**/*.rb", "lib/**/*.sh"]
  s.require_paths = ["lib"]
  s.add_dependency "playwright-ruby-client", "~> 1.58"
end
