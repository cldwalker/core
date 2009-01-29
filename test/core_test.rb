require File.join(File.dirname(__FILE__), 'test_helper')

class CoreTest < Test::Unit::TestCase
  
  test "check_for_conflicts finds conflicts" do
    eval "module ::SomeModule; def chomp!; end; end"
    Core.check_for_conflicts(Array, ::SomeModule).should == ['chomp!']
  end
  
  test "check_for_conflicts finds no conflicts" do
    eval "module ::AnotherModule; def blah; end; end"
    Core.check_for_conflicts(Array, ::AnotherModule).should == []
  end
  
  context "adds_to" do
    test "auto adds Core extension class" do
      eval "module Core::Array; end"
      Array.ancestors.include?(Core::Array).should be(false)
      Core.adds_to(Array)
      Array.ancestors.include?(Core::Array).should be(true)
    end
    
    test "auto add requires correct class" do
      Core.expects(:require).with("core/class")
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
        Core.adds_to(Array, :with=>BlahArray).should be(false)
      }.should =~ /methods conflict.*clear/m
      Array.ancestors.include?(BlahArray).should be(false)
    end
    
    test "adds extension class when there are conflicts and given :force option" do
      eval "module ::Blah2Array; def clear; end; end"
      Core.adds_to(Array, :with=>Blah2Array, :force=>true)
      Array.ancestors.include?(Blah2Array).should be(true)
    end
    
    test "returns false when no extension class found" do
      eval "class ::InvalidClass; end"
      capture_stdout { 
        Core.adds_to(InvalidClass).should == false
      }.should =~ /No.*extension class found/
    end
  end
end
