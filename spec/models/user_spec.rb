require 'spec_helper'

describe User do
  before {@user = User.new()}
  subject {@user}

  it{should respond_to(:profile)}
  it{should respond_to(:email)}
  it{should respond_to(:password)}
end
