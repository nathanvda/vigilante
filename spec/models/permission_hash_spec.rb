require 'spec_helper.rb'

describe PermissionHash do

  context "initializer" do
    it "should have a good default" do
      pp = PermissionHash.new
      pp.keys.count.should == 1
      pp['*']['homepage'].should == PermissionHash::DEFAULT_PERMISSIONS['*']['homepage']
    end

    it "should use the given hash as a start" do
      sample_hash = {}
      sample_hash['1'] = {'asps[index, show' => 1}
      pp = PermissionHash.new(sample_hash)
      pp.keys.count.should == 1
      pp['1'].should == sample_hash['1']
    end
  end

  context "is_allowed_by_context" do
    context "default permissions" do
      before (:each) do
        @ph = PermissionHash.new
      end
      it "can visit the homepage" do
        @ph.is_allowed_by_context('homepage', :index, nil).should be_true
      end
      it "can visit the homepage (alternative notation)" do
        @ph.is_allowed_by_context('/', :index, nil).should be_true
      end
      it "can visit the homepage in a random context" do
        @ph.is_allowed_by_context('homepage', :index, ['1', '34','69']).should be_true
      end
      it "can visit the homepage show page" do
        @ph.is_allowed_by_context('/', :show, nil).should be_true
      end
      it "cannot visit any homepage edit" do
        @ph.is_allowed_by_context('/', :edit, nil).should be_false
      end
      it "can not visit any other page" do
        @ph.is_allowed_by_context('something_else', :show, nil).should be_false
      end
    end

    context "special permissions, global and specific" do
      before (:each) do
        @ph = PermissionHash.new()
        @ph.add '1', 'posts', [:index, :show]
        @ph.add '1', 'homepage', [:index]
        @ph.add '2', 'comments', [:index, :show, :edit]
      end

      it "can visit the homepage" do
        @ph.is_allowed_by_context('homepage', :index, nil).should be_true
      end
      it "can visit the homepage in an unknown context" do
        @ph.is_allowed_by_context('homepage', :index, ['69']).should be_true
      end
      it "can visit the homepage in a context with the correct right" do
        @ph.is_allowed_by_context('homepage', :index, ['1']).should be_true
      end
      it "cannot visit the homepage in a known context without homepage rights" do
        @ph.is_allowed_by_context('homepage', :index, ['2']).should be_false
      end
      it "can visit posts index in context 1" do
        @ph.is_allowed_by_context('posts', :index, ['1']).should be_true
      end
      it "cannot visit posts index without context" do
        @ph.is_allowed_by_context('posts', :index, nil).should be_false
      end

      context "get_extent_of" do
        it "of posts index should be correct" do
          @ph.get_extent_of('posts', "index").should == ['1']
        end
        it "of comments index should be correct" do
          @ph.get_extent_of('comments', :index).should == ['2']
        end
        it "of homepage index should be correct" do
          @ph.get_extent_of('/', :index).should =~ ['1', '*']
        end
      end

      it "is not global a permission hash (or: we have extents)" do
        @ph.is_global?.should be_false
      end
    end
  end

  context "add a permission" do
    before (:each) do
      @ph = PermissionHash.new
    end

    context "on index" do
      before (:each) do
        @ph.add '1', 'asps', [:index]
      end

      it "should be added to the hash" do
        expected_result = HashWithIndifferentAccess.new(PermissionHash::DEFAULT_PERMISSIONS).merge("1"=>{"asps"=>{"index"=>1}})
        @ph.should == expected_result
      end

      it "should now be allowed" do
        @ph.is_allowed_by_context('asps', :index, ['1']).should be_true
      end
    end

    context "on new" do
      before (:each) do
        @ph.add '1', 'asps', [:new]
      end
      it "should now be allowed" do
        @ph.is_allowed_by_context('asps', :new, ['1']).should be_true
      end
      it "and create should now be allowed" do
        @ph.is_allowed_by_context('asps', :create, ['1']).should be_true
      end
    end

    context "on edit" do
      before (:each) do
        @ph.add '1', 'asps', [:edit]
      end
      it "should now be allowed" do
        @ph.is_allowed_by_context('asps', :edit, ['1']).should be_true
      end
      it "and create should now be allowed" do
        @ph.is_allowed_by_context('asps', :update, ['1']).should be_true
      end
    end
  end

  context "is_global?" do
    context "with global permissions" do
      before (:each) do
        @ph = PermissionHash.new
      end
      it "returns true" do
        @ph.is_global?.should be_true
      end
      it "returns true (alternative notation)" do
        @ph.are_only_global?.should be_true
      end
    end
    context "with global permissions" do
      before (:each) do
        @ph = PermissionHash.new
        @ph.add '1', 'posts', [:index, :show, :edit, :new]
      end
      it "returns true" do
        @ph.is_global?.should be_false
      end
      it "returns true (alternative notation)" do
        @ph.are_only_global?.should be_false
      end
    end
  end

end