require 'spec_helper'

describe Photo do
  before {@photo = Photo.new()}

  subject {@photo}

  it {should respond_to(:photo)}
  it {should respond_to(:title)}
  it {should respond_to(:description)}
  it {should respond_to(:profile)}

  describe "when photo is blank" do
  	before {@photo.photo=nil}
  	it{should_not be_valid}
  end

  describe "when title is too long" do
  	before {@photo.title = 'a'*31}
  	it {should_not be_valid}
  end

  describe "when description is too long" do
  	before {@photo.description='a'*201}
  	it {should_not be_valid}
  end
  
end
