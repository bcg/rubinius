require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Struct#hash" do
  
  it "returns the same fixnum for structs with the same content" do
    [Struct::Ruby.new("1.8.6", "PPC"), Struct::Car.new("Hugo", "Foo", "1972")].each do |stc|
      stc.hash.should == stc.dup.hash
      stc.hash.should be_kind_of(Fixnum)
    end
  end
  
  it "returns the same value if structs are #eql?" do
    car = Struct::Car.new("Honda", "Accord", "1998")
    similar_car = Struct::Car.new("Honda", "Accord", "1998")
    car.should eql(similar_car)
    car.hash.should == similar_car.hash
  end
  
  ruby_bug "redmine #1852", "1.9.1" do
    it "returns the same hash for recursive structs" do
      car = Struct::Car.new("Honda", "Accord", "1998")
      similar_car = Struct::Car.new("Honda", "Accord", "1998")
      car[:make] = car
      similar_car[:make] = car
      car.hash.should == similar_car.hash
      # This is because car.eql?(similar_car).
      # Objects that are eql? must return the same hash.
      # See the Struct#eql? specs
    end
  end

end