require File.join(File.dirname(__FILE__), 'test_helper')

class Core::LoaderTest < Test::Unit::TestCase
  before(:all) do
    eval %[
      #a mock core class
      module ::Fake; end

      #main extension module
      module ::My
        module Fake
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
        @loader.extends(Fake, :only=>:instance)
      end
      
      test "with :only=>:class only includes class methods" do
        @loader.expects(:include_instance_methods).never
        @loader.expects(:extend_class_methods).once
        @loader.extends(Fake, :only=>:class)
      end
      
      test "with no only option includes class and instance methods" do
        @loader.expects(:include_instance_methods).once
        @loader.expects(:extend_class_methods).once
        @loader.extends(Fake)
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
      
      test "raises ArgumentError if not extending a Class" do
        assert_raise(ArgumentError) { @loader.extends("My") }
      end
      
      test "with monkeypatch and no with option" do
        @loader.expects(:require).with("facets/fake")
        @loader.extends(Fake, :lib=>{:monkeypatch=>true, :base_class=>:facets, :base_path=>"facets"})
      end
      
      test "with monkeypatch and string with option" do
        @loader.expects(:require).with("facets/fake/method1")
        @loader.extends(Fake, :with=>"Fake::Method1", :lib=>{:monkeypatch=>true, :base_class=>:facets, :base_path=>"facets"})
      end
      
      test "with monkeypatch and relative string with option" do
        @loader.expects(:require).with("facets/fake/method1")
        @loader.extends(Fake, :with=>"Method1", :lib=>{:monkeypatch=>true, :base_class=>:facets, :base_path=>"facets"})
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
  
  context "with current library" do
    before(:each) { @loader.current_library = {:base_class=>::My, :base_path=>"my"}}
    
    context "when detecting extension class" do
      test "return nil if the detected name equals the given name" do
        eval "module ::InvalidModule; end"
        @loader.detect_extension_class(InvalidModule).should == nil
      end
    
      test "returns class when found" do
        eval "module ::Blah; end; module My::Blah; end"
        @loader.detect_extension_class(::Blah).should == My::Blah
      end
    end
  end
  
  context "activate_extension_class" do
    test "doesn't activate if there are conflicts" do
      eval "module ::BlahFake; def clear; end; end"
      capture_stdout {
        @loader.include_instance_methods(Fake, BlahFake)
      }.should =~ /methods conflict.*clear/m
      Fake.ancestors.include?(BlahFake).should be(false)
    end
      
    test "activates extension if forced" do
      eval "module ::Blah2Fake; def clear; end; end"
      @loader.include_instance_methods(Fake, Blah2Fake, :force=>true)
      Fake.ancestors.include?(Blah2Fake).should be(true)
    end
    
    test "activates if there are no conflicts" do
      eval "module ::Blah3Fake; def blang; end; end"
      @loader.include_instance_methods(Fake, Blah3Fake)
      Fake.ancestors.include?(Blah3Fake).should be(true)
    end
  end
  
end
