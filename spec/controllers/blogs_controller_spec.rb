require 'spec_helper.rb'

describe BlogsController do
  # these methods are added by the 'protected_by_vigilante'
  it { should respond_to(:check_permissions) }
  it { should respond_to(:check_permission ) }

end