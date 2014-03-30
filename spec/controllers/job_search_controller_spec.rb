require 'spec_helper'

describe JobSearchController do

	describe 'GET #index' do
    describe 'authenticated' do
      it 'shows the job search page' do
        sign_in User.create(email: 'foo@rattl.co.uk', password: 'password')
        get :index
        expect(response.status).to eq(200)
      end
    end

    describe 'unauthenticated' do
      it 'redirects and prompts the user to log in' do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end

end
