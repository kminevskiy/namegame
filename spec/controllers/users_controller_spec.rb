require_relative '../spec_helper'

describe UsersController do
    describe '#index' do
        context 'with unauthenticated user' do
            it 'renders index template' do
                get :index

                expect(response).to render_template :index
            end

            it 'returns 200 (OK) status code' do
                get :index

                expect(response.status).to eq 200
            end

            it 'returns list of first 10 users' do
                10.times do
                    user = Fabricate(:user)
                    user.games.create(Fabricate.attributes_for(:game))
                end

                get :index

                expect(assigns(:users).length).to eq 10
            end

            it 'returns list of first 10 users sorted by their score' do
                tim = Fabricate(:user, first_name: 'Tim')
                3.times do
                    tim.games.create(Fabricate.attributes_for(:game, score: 10 ))
                end

                jim = Fabricate(:user, first_name: 'Jim')
                3.times do
                    jim.games.create(Fabricate.attributes_for(:game, score: 20 ))
                end

                mike = Fabricate(:user, first_name: 'Mike')
                3.times do
                    mike.games.create(Fabricate.attributes_for(:game, score: 5))
                end

                get :index

                users = assigns(:users)
                expect(users.pluck(:first_name)).to match %w(Jim Tim Mike)
                expect(users.first.total_score).to eq 60
            end
        end
    end

    describe '#show' do
        let(:user) { Fabricate(:user) }

        context 'with unauthenticated user' do
            before do
                get :show, params: { id: user.id }
            end

            it 'redirects to login page' do
                expect(response).to redirect_to login_path
            end

            it 'returns 302 (Redirect) status code' do
                expect(response.status).to eq 302
            end
        end

        context 'with authenticated user' do
            let(:other_user) { Fabricate(:user) }

            it 'redirects to edit profile page for current user' do
                session[:user_id] = user.id

                get :show, params: { id: user.id }

                expect(response).to redirect_to edit_user_path user
            end

            it 'renders other user page' do
                session[:user_id] = user.id

                get :show, params: { id: other_user.id }

                expect(response).to render_template :show
            end
        end
    end

    describe '#new' do
        let(:user) { Fabricate(:user) }

        context 'with unauthenticated user' do
            before do
                get :new
            end

            it 'renders new template' do
                expect(response).to render_template :new
            end

            it 'returns 200 (OK) status code' do
                expect(response.status).to eq 200
            end

            it 'sets new User object' do
                expect(assigns(:user)).to be_instance_of User
            end
        end

        context 'with authenticated user' do
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

    describe '#create' do
        context 'with unauthenticated user' do
            context 'with valid credentials' do
                before do
                    post :create, params: { user: Fabricate.attributes_for(:user) }
                end

                it 'creates new user' do
                    expect(User.count).to eq 1
                end

                it 'redirects to login page' do
                    expect(response).to redirect_to login_path
                end
            end

            context 'with invalid credentials' do
                before do
                    post :create, params: { user: { first_name: 'Tim' } }
                end

                it 'does not create new user' do
                    expect(User.count).to eq 0
                end

                it 'renders new template again' do
                    expect(response).to render_template :new
                    expect(assigns(:user).first_name).not_to be nil
                end
            end
        end
    end

    describe '#edit' do
        let(:user) { Fabricate(:user) }

        context 'with unauthenticated user' do
            context 'with valid input' do
                before do
                    get :edit, params: { id: user.id }
                end
                
                it 'redirects to login page' do
                    expect(response).to redirect_to login_path    
                end

                it 'returns 302 (Redirect) status code' do
                    expect(response.status).to eq 302
                end
            end

            context 'with invalid input' do
                before do
                    get :edit, params: { id: 100 }
                end

                it 'redirects to login page' do
                    expect(response).to redirect_to login_path    
                end

                it 'returns 302 (Redirect) status code' do
                    expect(response.status).to eq 302
                end
            end
        end

        context 'with authenticated user' do
            context 'with valid input' do
                before do
                    session[:user_id] = user.id

                    get :edit, params: { id: user.id }
                end

                it 'renders edit template' do
                    expect(response).to render_template :edit
                end

                it 'returns 200 (OK) status code' do
                    expect(response.status).to eq 200
                end

                it 'sets existing User object' do
                    expect(assigns(:user)).to eq User.first
                end
            end

            context 'with invalid input' do
                let(:other_user) { Fabricate(:user) }

                before do
                    session[:user_id] = user.id

                    get :edit, params: { id: other_user.id }
                end

                it 'redirects to current user\'s page' do
                    expect(response).to redirect_to user_path user
                end

                it 'returns 302 (Redirect) status code' do
                    expect(response.status).to eq 302
                end
            end
        end
    end

    describe '#update' do
        let(:user) { Fabricate(:user) }

        context 'with unauthenticated user' do
            before do
                put :update, params: { id: user.id, user: Fabricate.attributes_for(:user)}
            end

            it 'redirects to login page' do
                expect(response).to redirect_to login_path
            end

            it 'returns 302 (Redirect) status code' do
                expect(response.status).to eq 302
            end
        end

        context 'with authenticated user' do
            context 'with valid input' do
                before do
                    session[:user_id] = user.id

                    put :update, params: { id: user.id, user: Fabricate.attributes_for(:user, first_name: 'Jim')}
                end

                it 'updates user profile' do
                    expect(User.first.first_name).to eq 'Jim'
                end

                it 'redirects to user page' do
                    expect(response).to redirect_to user_path user
                end

                it 'returns 302 (Redirect) status code' do
                    expect(response.status).to eq 302
                end
            end

            context 'with invalid input' do
                before do
                    session[:user_id] = user.id

                    put :update, params: { id: user.id, user: Fabricate.attributes_for(:user, first_name: '', last_name: 'Timson')}
                end

                it 'does not update current user' do
                    existing_user = User.first

                    expect(existing_user.first_name).to eq user.first_name
                    expect(existing_user.last_name).not_to eq 'Timson'
                end

                it 'renders edit template' do
                    expect(response).to render_template :edit
                end
            end
        end
    end

    describe '#destroy' do
        let!(:user) { Fabricate(:user) }
        let!(:other_user) { Fabricate(:user) }

        context 'with unauthenticated user' do
            context 'with valid input' do
                before do
                    delete :destroy, params: { id: other_user.id }
                end

                it 'does not delete existing user' do
                    expect(User.count).to eq 2
                end

                it 'redirects to login page' do
                    expect(response).to redirect_to login_path
                end

                it 'returns 302 (Redirect) status code' do
                    expect(response.status).to eq 302
                end
            end

            context 'with invalid input' do
                before do
                    delete :destroy, params: { id: 42 }
                end

                it 'does not delete existing user' do
                    expect(User.count).to eq 2
                end

                it 'redirects to login page' do
                    expect(response).to redirect_to login_path
                end

                it 'returns 302 (Redirect) status code' do
                    expect(response.status).to eq 302
                end
            end
        end

        context 'with authenticated user' do
            before { session[:user_id] = user.id }

            context 'with valid input' do
                before do
                    delete :destroy, params: { id: user.id }
                end

                it 'deletes current user' do
                    expect(User.count).to eq 1
                    expect(User.find_by(id: user.id)).to eq nil
                end

                it 'redirects to users page' do
                    expect(response).to redirect_to users_path
                end

                it 'returns 302 (Redirect) status code' do
                    expect(response.status).to eq 302
                end
            end

            context 'with invalid input' do
                before { session[:user_id] = user.id }
                
                before do
                    delete :destroy, params: { id: other_user.id }
                end

                it 'does not delete other user' do
                    expect(User.count).to eq 2
                    expect(User.find_by(id: user.id)).to be_instance_of User
                end

                it 'redirects to users page' do
                    expect(response).to redirect_to users_path
                end

                it 'returns 302 (Redirect) status code' do
                    expect(response.status).to eq 302
                end 
            end
        end
    end
end