require 'spec_helper.rb'

describe Ability do
  it {should have_many :ability_permissions}
  it {should have_many :permissions}

  describe "that need extent" do
    before (:each) do
      @ab_with    = Ability.create(:name => "test_with",    :needs_extent => true)
      @ab_without = Ability.create(:name => "test_without", :needs_extent => false)
    end
    it "should include with neeD_extent flag" do
      Ability.that_need_extent.should include(@ab_with)
    end

    it "should not include abilities without need_extent flag" do
      Ability.that_need_extent.should_not include(@ab_without)
    end
  end
end