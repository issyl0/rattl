require 'spec_helper'

describe JobResultController do

  describe 'GET #verdict' do
    describe 'authenticated' do
      before(:each) do
        $job_name = 'hairdresser'
      end
      
      it 'shows the job result verdict page' do
        sign_in User.create(email: 'foo@rattl.co.uk', password: 'password')
        get :verdict
        expect(response.status).to eq(200)
      end
    end

    describe 'unauthenticated' do
      it 'redirects and prompts the user to log in' do
        get :verdict
        expect(response.status).to eq(302)
      end
    end
  end 
end
