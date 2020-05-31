require "./spec_helper"

include Radix::Sort

class Thing < RSable(Int32)
  def initialize(@value : Int32)
  end

  def get_key : Int32
    @value
  end
end

describe Radix::Sort do
  # TODO: Write tests

  it "insertion sorts" do
    test_array = [
      Thing.new(2), Thing.new(7), Thing.new(32), Thing.new(50), Thing.new(1), Thing.new(70),
    ]
    insertion_sort!(test_array)
    test_array.map { |t| t.get_key }.should eq([1, 2, 7, 32, 50, 70])
  end
  it "insertion sorts small" do
    test_array = [
      Thing.new(50), Thing.new(1),
    ]
    insertion_sort!(test_array)
    test_array.map { |t| t.get_key }.should eq([1, 50])
  end
  it "insertion sorts one" do
    test_array = [
      Thing.new(50),
    ]
    insertion_sort!(test_array)
    test_array.map { |t| t.get_key }.should eq([50])
  end

  it "radix sorts" do
    test_array = [
      Thing.new(2), Thing.new(7), Thing.new(32), Thing.new(50), Thing.new(1), Thing.new(70),
    ]

    radix_sort!(test_array)
    test_array.map { |t| t.get_key }.should eq([1, 2, 7, 32, 50, 70])
  end
  it "radix sorts small" do
    test_array = [
      Thing.new(50), Thing.new(1),
    ]

    radix_sort!(test_array)
    test_array.map { |t| t.get_key }.should eq([1, 50])
  end
  it "radix sorts one" do
    test_array = [
      Thing.new(50),
    ]

    radix_sort!(test_array)
    test_array.map { |t| t.get_key }.should eq([50])
  end
end
