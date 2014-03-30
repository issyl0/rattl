require 'spec_helper'

describe WelcomeController do
  
  describe 'GET #welcome' do
    it 'shows the homepage' do
      get :welcome
      expect(response.status).to eq(200)
    end
  end

end
