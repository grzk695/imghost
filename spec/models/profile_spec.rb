require 'spec_helper'

describe Profile do
 
  before {@profile = Profile.new }
  subject {@profile}

  it {should respond_to(:user)}

end
