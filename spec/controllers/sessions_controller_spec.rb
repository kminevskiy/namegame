require_relative '../spec_helper'

describe SessionsController do
    describe '#create' do
        context 'with unauthenticated user' do
            let(:user) { Fabricate(:user) }

            context 'with valid credentials' do
                before do
                    post :create, params: { email: user.email, password: user.password }
                end

                it 'successfully authenticates user' do
                    expect(session[:user_id]).to eq user.id
                end

                it 'redirects user to her profile' do
                    expect(response).to redirect_to users_path
                end
            end

            context 'with invalid credentials' do
                before do
                    post :create, params: { user: { email: 'invalid', password: user.password }}
                end

                it 'renders new template' do
                    expect(response).to render_template :new
                end

                it 'does not create new session' do
                    expect(session[:user_id]).to eq nil
                end
            end
        end
    end

    describe '#new' do
        context 'with authenticated user' do
            let(:user) { Fabricate(:user) }

            before do
                session[:user_id] = user.id

                get :new
            end

            it 'redirects to user\'s profile' do
                expect(response).to redirect_to user_path user
            end

            it 'returns 302 (Redirect) status code' do
                expect(response.status).to eq 302
            end
        end
    end

    describe '#destroy' do
        let(:user) { Fabricate(:user) }

        context 'with authenticated user' do
            before do
                session[:user_id] = user.id

                delete :destroy, params: { id: user.id }
            end

            it 'deletes user' do
                expect(session[:user_id]).to eq nil
            end

            it 'redirects to index page' do
                expect(response).to redirect_to users_path
            end
        end
    end
end