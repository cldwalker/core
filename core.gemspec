# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{core}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gabriel Horner"]
  s.date = %q{2009-05-03}
  s.description = %q{Provides an easy way of using/sharing Ruby extension libraries (think activesupport) with a bias to monkeypatch-agnostic extensions.}
  s.email = %q{gabriel.horner@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/core.rb",
    "lib/core/interface.rb",
    "lib/core/loader.rb",
    "lib/core/manager.rb",
    "lib/core/util.rb",
    "test/core_test.rb",
    "test/loader_test.rb",
    "test/manager_test.rb",
    "test/test_helper.rb",
    "test/util_test.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/cldwalker/core}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Provides an easy way of using/sharing Ruby extension libraries (think activesupport) with a bias to monkeypatch-agnostic extensions.}
  s.test_files = [
    "test/core_test.rb",
    "test/loader_test.rb",
    "test/manager_test.rb",
    "test/test_helper.rb",
    "test/util_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
