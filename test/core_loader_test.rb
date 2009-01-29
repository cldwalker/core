require File.join(File.dirname(__FILE__), 'test_helper')

class Core::LoaderTest < Test::Unit::TestCase
  
  context "Core::Loader" do
    before(:each) {@loader = Core::Loader.new(Core)}
    test "check_instance_methods finds conflicts" do
      eval "module ::SomeModule; def chomp!; end; end"
      @loader.check_instance_methods(Array, ::SomeModule).should == ['chomp!']
    end
  
    test "check_instance_methods finds no conflicts" do
      eval "module ::AnotherModule; def blah; end; end"
      @loader.check_instance_methods(Array, ::AnotherModule).should == []
    end
  end
  
  context "adds_to" do
    test "auto adds Core extension class" do
      eval "module Core::Array; end"
      Array.ancestors.include?(Core::Array).should be(false)
      Core.adds_to(Array)
      Array.ancestors.include?(Core::Array).should be(true)
    end
    
    test "auto add requires correct class" do
      Kernel.expects(:require).with("core/class")
      capture_stdout { Core.adds_to(Class) }
    end
    
    test "adds extension class with :with option" do
      eval "module Core::AnotherArray; end"
      Array.ancestors.include?(Core::AnotherArray).should be(false)
      Core.adds_to(Array, :with=>Core::AnotherArray)
      Array.ancestors.include?(Core::AnotherArray).should be(true)
    end
    
    test "doesn't add extension class when there are conflicts" do
      eval "module ::BlahArray; def clear; end; end"
      capture_stdout {
        Core.adds_to(Array, :with=>BlahArray)
      }.should =~ /methods conflict.*clear/m
      Array.ancestors.include?(BlahArray).should be(false)
    end
    
    test "adds extension class when there are conflicts and given :force option" do
      eval "module ::Blah2Array; def clear; end; end"
      Core.adds_to(Array, :with=>Blah2Array, :force=>true)
      Array.ancestors.include?(Blah2Array).should be(true)
    end
    
    test "errors when no extension class found" do
      eval "class ::InvalidClass; end"
      capture_stdout { 
        Core.adds_to(InvalidClass)
      }.should =~ /No.*extension class found/
    end
  end
end
