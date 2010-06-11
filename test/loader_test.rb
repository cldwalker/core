require File.join(File.dirname(__FILE__), 'test_helper')

describe "Loader" do
  before_all do
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

  def loader
    @loader ||= Core::Loader
  end
  
  describe "Core::Loader" do
  
    describe "when adding" do
      before {
        Core.default_library = ::My
      }
      it "with :only=>:instance, only includes instance methods" do
        loader.expects(:include_instance_methods).once
        loader.expects(:extend_class_methods).never
        loader.extends(Fake, :only=>:instance)
      end
      
      it "with :only=>:class only includes class methods" do
        loader.expects(:include_instance_methods).never
        loader.expects(:extend_class_methods).once
        loader.extends(Fake, :only=>:class)
      end
      
      it "with no only option includes class and instance methods" do
        loader.expects(:include_instance_methods).once
        loader.expects(:extend_class_methods).once
        loader.extends(Fake)
      end
            
      it "does not extend class methods if no class_methods class found" do
        loader.expects(:include_instance_methods).once
        loader.expects(:extend_class_methods).never
        loader.extends(String)
      end
      
      it "requires when detecting correct base extension class" do
        loader.expects(:require).with("my/file")
        capture_stdout { loader.extends(File) }.should =~ /No.*class found/
      end
      
      it "raises ArgumentError if not extending a Class" do
        should.raise(ArgumentError) { loader.extends("My") }
      end
      
      it "with monkeypatch and no with option" do
        loader.expects(:require).with("facets/fake")
        loader.extends(Fake, :lib=>{:monkeypatch=>true, :base_class=>:facets, :base_path=>"facets"})
      end
      
      it "with monkeypatch and string with option" do
        loader.expects(:require).with("facets/fake/method1")
        loader.extends(Fake, :with=>"Fake::Method1", :lib=>{:monkeypatch=>true, :base_class=>:facets, :base_path=>"facets"})
      end
      
      it "with monkeypatch and relative string with option" do
        loader.expects(:require).with("facets/fake/method1")
        loader.extends(Fake, :with=>"Method1", :lib=>{:monkeypatch=>true, :base_class=>:facets, :base_path=>"facets"})
      end
    end
    
  end
  
  describe "set_current_library" do
    it "with no default libary returns empty hash when given nil" do
      Core::Manager.reset_default_library
      loader.set_current_library(nil).should == {}
    end
    
    it "with default library returns default library when given nil" do
      default_lib = {:base_class=>"Blah", :base_path=>"blah"}
      Core.default_library = default_lib
      loader.set_current_library(nil).should == default_lib
    end
    
    it "calls find_or_create_library when given library" do
      Core::Manager.expects(:find_or_create_library).once
      loader.set_current_library(:blah)
    end
  end
  
  describe "with current library" do
    before { loader.current_library = {:base_class=>::My, :base_path=>"my"}}
    
    describe "when detecting extension class" do
      it "return nil if the detected name equals the given name" do
        eval "module ::InvalidModule; end"
        loader.detect_extension_class(InvalidModule).should == nil
      end
    
      it "returns class when found" do
        eval "module ::Blah; end; module My::Blah; end"
        loader.detect_extension_class(::Blah).should == My::Blah
      end
    end
  end
  
  describe "activate_extension_class" do
    # TODO
    # it "doesn't activate if there are conflicts" do
    #   eval "module ::BlahFake; def clear; end; end"
    #   capture_stdout {
    #     loader.include_instance_methods(Fake, BlahFake)
    #   }.should =~ /methods conflict.*clear/m
    #   Fake.ancestors.include?(BlahFake).should == false
    # end
      
    it "activates extension if forced" do
      eval "module ::Blah2Fake; def clear; end; end"
      loader.include_instance_methods(Fake, Blah2Fake, :force=>true)
      Fake.ancestors.include?(Blah2Fake).should == true
    end
    
    it "activates if there are no conflicts" do
      eval "module ::Blah3Fake; def blang; end; end"
      loader.include_instance_methods(Fake, Blah3Fake)
      Fake.ancestors.include?(Blah3Fake).should == true
    end
  end
  
end
