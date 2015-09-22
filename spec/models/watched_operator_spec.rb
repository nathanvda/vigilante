require 'spec_helper.rb'

describe Author do
  # test the code inserted into the Author (from the "watched_operator" module )

  # !!! TODO: fix extracted test-code
  #
  # context "validate_authorizations" do
  #   # validate_authorizations expects
  #   # - the current-operators max permission (weight)
  #   # - whether the current-operators has an extent or not
  #   #
  #   # These two are then combined to check whether added authorizations are valid or not
  #   before(:each) do
  #     @test_operator = FactoryGirl.create(:operator)
  #   end
  #   context "no authorizations added" do
  #     before(:each) do
  #       @test_operator.validate_authorizations(100, true)
  #     end
  #     it "sets an error on authorizations" do
  #       @test_operator.errors[:authorizations].size.should == 1
  #     end
  #     it "must have at least one ability" do
  #       @test_operator.errors[:authorizations].should == ["must have at least one ability"]
  #     end
  #   end
  #   context "with one authorization added that needs extent, without an extent" do
  #     before(:each) do
  #       @test_operator.abilities << Ability.find_by_name("asp_admin")
  #       @test_operator.validate_authorizations(100, true)
  #     end
  #     it "sets an error on authorizations" do
  #       @test_operator.errors[:authorizations].size.should == 1
  #     end
  #     it "this ability requires an organisation" do
  #       @test_operator.errors[:authorizations].should == ["ability asp_admin requires an organisation!"]
  #     end
  #   end
  #   context "with one authorization added that does not need an extent, but the current operator does" do
  #     before(:each) do
  #       @test_operator.abilities << Ability.find_by_name("can-read-all")
  #       @test_operator.validate_authorizations(100, true)
  #     end
  #     it "sets an error on authorizations" do
  #       @test_operator.errors[:authorizations].size.should == 1
  #     end
  #     it "this ability requires an organisation" do
  #       @test_operator.errors[:authorizations].should == ["you do not have the necessary permission to add ability can-read-all"]
  #     end
  #   end
  #   context "with one authorization added that exceeds the current operator's permissions'" do
  #     before(:each) do
  #       @test_operator.abilities << Ability.find_by_name("can-read-all")
  #       @test_operator.validate_authorizations(9, false)
  #     end
  #     it "sets an error on authorizations" do
  #       @test_operator.errors[:authorizations].size.should == 1
  #     end
  #     it "this ability requires an organisation" do
  #       @test_operator.errors[:authorizations].should == ["you do not have the necessary permission to add ability can-read-all"]
  #     end
  #   end
  #   # !!!!! should also add all the positive cases, that do NOT add an error ...
  # end


end