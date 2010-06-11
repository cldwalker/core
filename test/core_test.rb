require File.join(File.dirname(__FILE__), 'test_helper')

describe "Core" do
  before_all {
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
  before { Core.default_library = ::My2 }
  
  def get_eigenclass(object)
    class << object; self; end
  end

  def should_not_extend_classes(extended_class, instance_extension_class, class_extension_class)
    extended_class.ancestors.include?(instance_extension_class).should == false
    get_eigenclass(extended_class).ancestors.include?(class_extension_class).should == false
  end
  
  def should_extend_classes(extended_class, instance_extension_class, class_extension_class)
    extended_class.ancestors.include?(instance_extension_class).should == true
    get_eigenclass(extended_class).ancestors.include?(class_extension_class).should == true
  end
  
  it "extends class with detected extension class" do
    should_not_extend_classes(Faker, ::My2::Faker, ::My2::Faker::ClassMethods)
    Core.extends(Faker)
    should_extend_classes(Faker, ::My2::Faker, ::My2::Faker::ClassMethods)
  end
  
  it "extends class with class :with option" do
    eval "module ::My2::Faker2; ; module ClassMethods; end; end"
    should_not_extend_classes(Faker, ::My2::Faker2, ::My2::Faker2::ClassMethods)
    Core.extends(Faker, :with=>::My2::Faker2)
    should_extend_classes(Faker, ::My2::Faker2, ::My2::Faker2::ClassMethods)
  end
  
  it "extends instance methods with InstanceMethods class if detected" do
    eval "module ::My2::Faker3; ; module InstanceMethods; end; end"
    Faker.ancestors.include?(::My2::Faker3::InstanceMethods).should == false
    Core.extends(Faker, :with=>::My2::Faker3)
    Faker.ancestors.include?(::My2::Faker3::InstanceMethods).should == true
  end

  # TODO
  # it "extends class with relative string :with option" do
  #   eval "module ::My2::Faker3; ; module ClassMethods; end; end"
  #   should_not_extend_classes(Faker, ::My2::Faker3, ::My2::Faker3::ClassMethods)
  #   Core.extends(Faker, :with=>"Faker3")
  #   should_extend_classes(Faker, ::My2::Faker3, ::My2::Faker3::ClassMethods)
  # end
  
  it "extends class with full string :with option" do
    eval "module ::My2::Faker4; ; module ClassMethods; end; end"
    should_not_extend_classes(Faker, ::My2::Faker4, ::My2::Faker4::ClassMethods)
    Core.extends(Faker, :with=>"My2::Faker4")
    should_extend_classes(Faker, ::My2::Faker4, ::My2::Faker4::ClassMethods)
  end

  it "extends class with :lib option" do
    eval "module ::My3; ; module Faker; module ClassMethods; end; end; end"
    should_not_extend_classes(Faker, ::My3::Faker, ::My3::Faker::ClassMethods)
    Core.extends(Faker, :lib=>::My3)
    should_extend_classes(Faker, ::My3::Faker, ::My3::Faker::ClassMethods)
  end

  it "extends class when no default library" do
    Core::Manager.reset_default_library
    eval %[module ::Bling; module Hash; end; end]
    Hash.ancestors.include?(::Bling::Hash).should == false
    Core.extends Hash, :with=>::Bling::Hash
    Hash.ancestors.include?(::Bling::Hash).should == true
  end
  
  it "errors when no base extension class found" do
    eval "class ::InvalidClass; end"
    capture_stdout { 
      Core.extends(InvalidClass)
    }.should =~ /No.*extension class found/
  end
end
