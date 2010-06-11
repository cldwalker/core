require File.join(File.dirname(__FILE__), 'test_helper')

describe "Manager" do
  before_all { eval "module ::Base; end" }
  before { Core::Manager.reset_libraries }
  it "creates library with a hash" do
    lib = {:base_class=>"Funky", :base_path=>"funky/ext" }
    Core::Manager.create_library(lib)
    Core::Manager.libraries[:funky].should == lib
  end
  
  it "creates library with a hash but no base_class" do
    lib = {:base_path=>"funky/ext", :monkeypatch=>true}
    Core::Manager.create_library(lib)
    Core::Manager.libraries[:funky].should == lib
  end
  
  it "creates library with base class" do
    lib = {:base_class=>::Base, :base_path=>"base"}
    Core::Manager.create_library(::Base)
    Core::Manager.libraries[:base].should == lib
  end
  
  describe "when setting default library" do
    it "with class fetches existing one" do
      Core::Manager.create_library(::Base)
      Core::Manager.default_library = ::Base
      lib = {:base_class=>::Base, :base_path=>"base"}
      Core::Manager.default_library.should == lib
    end
    
    it "with class creates new one" do
      eval "module ::Base2; end"
      Core::Manager.default_library = ::Base2
      lib = {:base_class=>::Base2, :base_path=>"base2"}
      Core::Manager.default_library.should == lib
    end
    
    it "with hash creates new one one" do
      lib = {:base_class=>::Base, :base_path=>"base"}
      Core::Manager.default_library = lib
      Core::Manager.default_library.should == lib
    end
    
    it "with symbol fetches existing one" do
      Core::Manager.create_library(::Base)
      Core::Manager.default_library = :base
      lib = {:base_class=>::Base, :base_path=>"base"}
      Core::Manager.default_library.should == lib
    end
    
    it "with invalid symbol warns nothing found" do
      capture_stdout {Core::Manager.default_library = :blah}.should =~ /not found/
    end
  end
end
