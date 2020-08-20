Gem::Specification.new do |s|
  s.name = "lamb"
  s.authors = ["Krzysiek Heród"]
  s.licenses = ["MIT"]
  s.homepage = "https://rubygems.org/netizer/groundcover"
  s.version = "0.0.1"
  s.date = "2020-06-13"
  s.summary = "Lamb frontend to Forest language."
  s.description = "Lamb is an advanced language that compiles to Forest."
  s.files = `git ls-files -z`.split("\x0")
  s.require_paths = ["lib", "generated"]
end
