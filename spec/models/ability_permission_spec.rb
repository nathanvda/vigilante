require 'spec_helper.rb'

describe AbilityPermission do
  it {should belong_to :ability}
  it {should belong_to :permission}
end