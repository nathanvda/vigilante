require 'spec_helper.rb'

describe Author do
  # an author has the line watched_by_vigilante inside
  it {should have_many :authorizations}  
  it {should respond_to :permits}
end