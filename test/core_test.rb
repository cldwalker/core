require File.join(File.dirname(__FILE__), 'test_helper')

class CoreTest < Test::Unit::TestCase
  def get_eigenclass(object)
    class << object; self; end
  end

  before(:all) {
    eval %[
      #mocks a core class
      module ::Faker; end

      #main extension module
      module ::My2
        module Faker
          module ClassMethods; end
        end
      end
    ]
  }
  before(:each) {Core.default_library = ::My2 }
  
  test "extends class and instance methods with detected extension class" do
    Faker.ancestors.include?(::My2::Faker).should be(false)
    get_eigenclass(Faker).ancestors.include?(::My2::Faker::ClassMethods).should be(false)
    Core.extends(Faker)
    Faker.ancestors.include?(::My2::Faker).should be(true)
    get_eigenclass(Faker).ancestors.include?(::My2::Faker::ClassMethods).should be(true)
  end
  
  test "extends class and instance methods with class :with option" do
    eval "module ::My2::Faker2; ; module ClassMethods; end; end"
    Faker.ancestors.include?(::My2::Faker2).should be(false)
    get_eigenclass(Faker).ancestors.include?(::My2::Faker2::ClassMethods).should be(false)
    Core.extends(Faker, :with=>::My2::Faker2)
    Faker.ancestors.include?(::My2::Faker2).should be(true)
    get_eigenclass(Faker).ancestors.include?(::My2::Faker2::ClassMethods).should be(true)
  end
  
  test "extends instance methods with InstanceMethods class if detected" do
    eval "module ::My2::Faker3; ; module InstanceMethods; end; end"
    Faker.ancestors.include?(::My2::Faker3::InstanceMethods).should be(false)
    Core.extends(Faker, :with=>::My2::Faker3)
    Faker.ancestors.include?(::My2::Faker3::InstanceMethods).should be(true)
  end
  
  #td: with :with string option
  
  test "extends class with relative string :with option" do
    eval "module ::My2::Faker3; ; module ClassMethods; end; end"
    Faker.ancestors.include?(::My2::Faker3).should be(false)
    get_eigenclass(Faker).ancestors.include?(::My2::Faker3::ClassMethods).should be(false)
    Core.extends(Faker, :with=>"Faker3")
    Faker.ancestors.include?(::My2::Faker3).should be(true)
    get_eigenclass(Faker).ancestors.include?(::My2::Faker3::ClassMethods).should be(true)
  end
  
  test "extends class when no default library" do
    Core::Manager.reset_default_library
    eval %[module ::Bling; module Hash; end; end]
    Hash.ancestors.include?(::Bling::Hash).should be(false)
    Core.extends Hash, :with=>::Bling::Hash
    Hash.ancestors.include?(::Bling::Hash).should be(true)
  end
  
  test "errors when no base extension class found" do
    eval "class ::InvalidClass; end"
    capture_stdout { 
      Core.extends(InvalidClass)
    }.should =~ /No.*extension class found/
  end
end
