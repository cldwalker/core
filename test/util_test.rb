require File.join(File.dirname(__FILE__), 'test_helper')

describe "Util" do
  it "check_instance_methods finds public and private conflicts" do
    eval "module ::SomeModule; def map; end; def chomp!; end; end"
    Core::Util.check_instance_methods(Array, ::SomeModule).sort.should == ['chomp!', 'map']
  end

  it "check_instance_methods finds no conflicts" do
    eval "module ::AnotherModule; def blah; end; end"
    Core::Util.check_instance_methods(Array, ::AnotherModule).should == []
  end
  
  it "check_class_methods finds public and private conflicts" do
    eval "module ::SomeModule2; def []; end; end"
    Core::Util.check_class_methods(Array, ::SomeModule2).should == ['[]']
  end
  
  it "check_class_methods finds no conflicts" do
    eval "module ::AnotherModule; def blah; end; end"
    Core::Util.check_class_methods(Array, ::AnotherModule).should == []
  end
end
