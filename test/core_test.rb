require File.join(File.dirname(__FILE__), 'test_helper')

class CoreTest < Test::Unit::TestCase
  def get_eigenclass(object)
    class << object; self; end
  end
  before(:all) {Core::Loader.default_library = Core }
  
  test "extends class and instance methods when detecting extension class" do
    eval "module Core::Array; module ClassMethods; end; end"
    Array.ancestors.include?(Core::Array).should be(false)
    get_eigenclass(Array).ancestors.include?(Core::Array::ClassMethods).should be(false)
    Core.extends(Array)
    Array.ancestors.include?(Core::Array).should be(true)
    get_eigenclass(Array).ancestors.include?(Core::Array::ClassMethods).should be(true)
  end
  
  test "extends class and instance methods with :with option" do
    eval "module Core::AnotherArray; ; module ClassMethods; end; end"
    Array.ancestors.include?(Core::AnotherArray).should be(false)
    get_eigenclass(Array).ancestors.include?(Core::AnotherArray::ClassMethods).should be(false)
    Core.extends(Array, :with=>Core::AnotherArray)
    Array.ancestors.include?(Core::AnotherArray).should be(true)
    get_eigenclass(Array).ancestors.include?(Core::AnotherArray::ClassMethods).should be(true)
  end
  
  test "errors when no base extension class found" do
    eval "class ::InvalidClass; end"
    capture_stdout { 
      Core.extends(InvalidClass)
    }.should =~ /No.*extension class found/
  end
end
