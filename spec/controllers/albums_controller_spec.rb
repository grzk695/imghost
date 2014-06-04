require 'spec_helper'

describe AlbumsController do

  describe "GET 'by_user'" do
    it "returns http success" do
      get 'by_user'
      response.should be_success
    end
  end

end
