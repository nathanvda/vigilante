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


describe Authorization do
  it {should belong_to :operator, :class_name => ::VIGILANTE_CONFIG['current_user_class']}
  it {should belong_to :ability}
  it {should have_many :authorization_extents}

  # !!! TO DO: we need to use remarkable to be able to easily test for :accepts_nested_attributes_for
  #            shoulda does not offer the same level of matchers ... time to switch?
  #it {should_accept_nested_attributes_for :authorization_extents}

  describe "extent helper methods" do
    before (:each) do
      @auth_with = Authorization.create(:ability_id => Ability.first.id)
      @auth_extent = @auth_with.authorization_extents.build()
      @extent = FakeExtentObject.new
      @auth_extent.set_extent(@extent)
      @auth_extent.save

      @auth_without =Authorization.create(:ability_id => Ability.first.id)
    end

    describe "has_extent?" do
      it "returns false if there is no extent" do
        # which is most readable?
        @auth_without.should_not be_has_extent
        @auth_without.has_extent?.should be_false
      end
      it "returns true if there is extent" do
        @auth_with.should be_has_extent
        @auth_with.has_extent?.should be_true
      end
    end

    describe "match_extent" do
      describe "without extent" do
        it "should match nil" do
          @auth_without.match_extent(nil).should be_true
        end

        it "should not match any other object" do
          @auth_without.match_extent(@extent).should be_false
        end
      end

      describe "with extent" do
        it "should not match nil" do
          @auth_with.match_extent(nil).should be_false
        end

        it "should match the extent object" do
          @auth_with.match_extent(@extent).should be_true
        end

        it "should not match any other object" do
          @auth_with.match_extent(FakeExtentObject.new).should be_false
        end

      end
    end

    describe "add extent" do
      describe "a real extent" do
        before(:each) do
          @other_extent = FakeExtentObject.new
          @auth_with.add_extent(@other_extent)
        end
        it "should have 2 extents" do
          @auth_with.authorization_extents.count.should == 2
        end
        it "should match both extents" do
          @auth_with.match_extent(@extent).should be_true
          @auth_with.match_extent(@other_extent).should be_true
        end
      end
      describe "a nil extent" do
        before(:each) do
          @auth_with.add_extent(nil)
        end
        it "should still have 1 extents" do
          @auth_with.authorization_extents.count.should == 1
        end
        it "should match both extents" do
          @auth_with.match_extent(@extent).should be_true
          @auth_with.match_extent(nil).should be_false
        end
      end
    end
  end

end