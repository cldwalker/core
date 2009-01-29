# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{core}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gabriel Horner"]
  s.date = %q{2009-01-28}
  s.description = %q{My extensions to core ruby classes, similar to the facets gem.}
  s.email = %q{gabriel.horner@gmail.com}
  s.extra_rdoc_files = ["README.markdown", "LICENSE.txt"]
  s.files = ["VERSION.yml", "Rakefile", "README.markdown", "LICENSE.txt", "lib/core", "lib/core/array.rb", "lib/core/class.rb", "lib/core/dir.rb", "lib/core/file.rb", "lib/core/hash.rb", "lib/core/io.rb", "lib/core/irb.rb", "lib/core/object.rb", "lib/core/string.rb", "lib/core.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/cldwalker/core}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{My extensions to core ruby classes, similar to the facets gem.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
