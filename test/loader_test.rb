require File.join(File.dirname(__FILE__), 'test_helper')

class Core::LoaderTest < Test::Unit::TestCase
  before(:all) do
    #define main test module
    eval %[
      module ::My
        module Array
          module ClassMethods; end
        end
      module String; end
    end
    ]
  end

  before(:each) {
    @loader = Core::Loader
  }
  
  context "Core::Loader" do
  
    context "when adding" do
      before(:each) {
        Core.default_library = ::My
      }
      test "with :only=>:instance, only includes instance methods" do
        @loader.expects(:include_instance_methods).once
        @loader.expects(:extend_class_methods).never
        @loader.extends(Array, :only=>:instance)
      end
      
      test "with :only=>:class only includes class methods" do
        @loader.expects(:include_instance_methods).never
        @loader.expects(:extend_class_methods).once
        @loader.extends(Array, :only=>:class)
      end
      
      test "with no only option includes class and instance methods" do
        @loader.expects(:include_instance_methods).once
        @loader.expects(:extend_class_methods).once
        @loader.extends(Array)
      end
      
      test "does not extend class methods if no class_methods class found" do
        @loader.expects(:include_instance_methods).once
        @loader.expects(:extend_class_methods).never
        @loader.extends(String)
      end
      
      test "requires when detecting correct base extension class" do
        @loader.expects(:require).with("my/file")
        capture_stdout { @loader.extends(File) }.should =~ /No.*class found/
      end      
    end
    
  end
  
  context "set_current_library" do
    test "with no default libary returns empty hash when given nil" do
      Core::Manager.reset_default_library
      @loader.set_current_library(nil).should == {}
    end
    
    test "with default library returns default library when given nil" do
      default_lib = {:base_class=>"Blah", :base_path=>"blah"}
      Core.default_library = default_lib
      @loader.set_current_library(nil).should == default_lib
    end
    
    test "calls find_or_create_library when given library" do
      Core::Manager.expects(:find_or_create_library).once
      @loader.set_current_library(:blah)
    end
  end
  
  context "when detecting extension class" do
    before(:each) { @loader.current_library = {:base_class=>::My, :base_path=>"my"}}
    test "return nil if invalid name" do
      eval "module ::InvalidModule; end"
      @loader.detect_extension_class(InvalidModule).should == nil
    end
    
    test "return nil if the detected name equals the given name" do
      @loader.detect_extension_class(Regexp).should == nil
    end
    
    test "returns class when found" do
      eval "module ::Blah; end; module My::Blah; end"
      @loader.detect_extension_class(::Blah).should == My::Blah
    end
  end
  
  context "activate_extension_class" do
    test "doesn't activate if there are conflicts" do
      eval "module ::BlahArray; def clear; end; end"
      capture_stdout {
        @loader.include_instance_methods(Array, BlahArray)
      }.should =~ /methods conflict.*clear/m
      Array.ancestors.include?(BlahArray).should be(false)
    end
      
    test "activates extension if forced" do
      eval "module ::Blah2Array; def clear; end; end"
      @loader.include_instance_methods(Array, Blah2Array, :force=>true)
      Array.ancestors.include?(Blah2Array).should be(true)
    end
    
    test "activates if there are no conflicts" do
      eval "module ::Blah3Array; def blang; end; end"
      @loader.include_instance_methods(Array, Blah3Array)
      Array.ancestors.include?(Blah3Array).should be(true)
    end
  end
  
end
