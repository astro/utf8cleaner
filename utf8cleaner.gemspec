Gem::Specification.new do |s|
  s.name = %q{utf8cleaner}
  s.version = "0.0.1"

  s.authors = ["Astro"]
  s.date = %q{2009-11-03}
  s.description = %q{Removes any non-ASCII/UTF8 bytes from a string}
  s.email = %q{astro@spaceboyz.net}
  s.files = ["ext/extconf.rb",
             "ext/utf8cleaner.c",
             "spec/utf8cleaner_spec.rb"
            ]
  s.extensions = ["ext/extconf.rb"] 
  s.require_paths = ["ext"]
  s.summary = %q{Efficiently clean your UTF8}
  s.test_files = [
    "spec/utf8cleaner_spec.rb"
  ]
end
