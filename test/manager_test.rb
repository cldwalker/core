require File.join(File.dirname(__FILE__), 'test_helper')

class Core::ManagerTest < Test::Unit::TestCase
  before(:all) { eval "module ::Base; end" }
  before(:each) { Core::Manager.reset_libraries }
  test "creates library with a hash" do
    lib = {:base_class=>"Funky", :base_path=>"funky/ext" }
    Core::Manager.create_library(lib)
    Core::Manager.libraries[:funky].should == lib
  end
  
  test "creates library with base class" do
    lib = {:base_class=>::Base, :base_path=>"base"}
    Core::Manager.create_library(::Base)
    Core::Manager.libraries[:base].should == lib
  end
  
  context "when setting default library" do
    test "with class fetches existing one" do
      Core::Manager.create_library(::Base)
      Core::Manager.default_library = ::Base
      lib = {:base_class=>::Base, :base_path=>"base"}
      Core::Manager.default_library.should == lib
    end
    
    test "with class creates new one" do
      eval "module ::Base2; end"
      Core::Manager.default_library = ::Base2
      lib = {:base_class=>::Base2, :base_path=>"base2"}
      Core::Manager.default_library.should == lib
    end
    
    test "with hash creates new one one" do
      lib = {:base_class=>::Base, :base_path=>"base"}
      Core::Manager.default_library = lib
      Core::Manager.default_library.should == lib
    end
    
    test "with symbol fetches existing one" do
      Core::Manager.create_library(::Base)
      Core::Manager.default_library = :base
      lib = {:base_class=>::Base, :base_path=>"base"}
      Core::Manager.default_library.should == lib
    end
    
    test "with invalid symbol warns nothing found" do
      capture_stdout {Core::Manager.default_library = :blah}.should =~ /not found/
    end
  end
end