require 'spec_helper.rb'

# create some object that will serve as extent
# --> we need an id method!
class FakeExtentObject
  attr_reader :id

  def initialize()
    @@id ||= 0
    @@id += 1
    @id = @@id
  end
end

describe AuthorizationExtent do
  it {should belong_to :authorization}

  describe "extent helpers" do
    before (:each) do
      @extent_obj = FakeExtentObject.new
      @auth = Authorization.create(:ability_id => Ability.first.id)
      @auth_extent = @auth.authorization_extents.build
      @auth_extent.set_extent(@extent_obj)
      @auth_extent.save
    end

    describe "set extent" do

      it("should set the type correctly") { @auth_extent.extent_type.should == @extent_obj.class.name }
      it("should set the id correctly")   { @auth_extent.extent_objid.should == @extent_obj.id }

    end

    describe "match extent" do
      before (:each) do
        @other_extent = FakeExtentObject.new
      end
      it "should match the same object" do
        @auth_extent.match_extent(@extent_obj).should be_true
      end

      it "should not match a different object" do
        @auth_extent.match_extent(@other_extent).should be_false
      end
    end
  end

#  ## DPS specific code: this should me moved into DPS (out of plugin)
#  # these are helpers that can retrieve or set the extent based on the Asp-label
#  describe "Asp extent helpers" do
#    describe "on existing object" do
#      before(:each) do
#        @auth_extent = AuthorizationExtent.create
#        @auth_extent.save
#        raise @auth_extent.errors unless @auth_extent.valid?
#        @asp = Factory(:asp)
#        @asp.save
#        @auth_extent.extent = @asp.identifier
#        @auth_extent.save
#      end
#      it "should set the extent" do
#        @auth_extent.match_extent(@asp).should be_true
#      end
#
#      it "should set the extent-objid" do
#        @auth_extent.extent_objid.should == @asp.id
#      end
#      it "should set the extent-type" do
#        @auth_extent.extent_type.should == @asp.class.name
#      end
#
#      it "extent should be equal to the identifier" do
#        @auth_extent.extent.should == @asp.identifier
#      end
#    end
#
#    describe "on unsaved object" do
#      before(:each) do
#        @auth_extent = AuthorizationExtent.new
#        @asp = Factory(:asp)
#        @auth_extent.extent = @asp.identifier
#      end
#      it "should set the extent" do
#        @auth_extent.match_extent(@asp).should be_true
#      end
#      it "extent should be equal to the identifier" do
#        @auth_extent.extent.should == @asp.identifier
#      end
#      it "should not be saved" do
#        @auth_extent.should be_new_record
#      end
#    end
#  end
end