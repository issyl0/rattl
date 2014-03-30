require 'spec_helper'

describe SkillsController do

  describe 'GET #new' do
    describe 'authenticated' do
      it 'shows the create skills page' do
        sign_in User.create(email: 'foo@rattl.co.uk', password: 'password')
        get :new
        expect(response.status).to eq(200)
      end
    end

    describe 'unauthenticated' do
      it 'redirects and prompts the user to log in' do
        get :new
        expect(response.status).to eq(302)
      end
    end
  end

end
