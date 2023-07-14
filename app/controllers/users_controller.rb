class UsersController < ApplicationController
    # signup post '/signup'
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id 
        render json: user, status: :created
    rescue ActiveRecord::RecordInvalid => e 
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    # auto-login get '/me'
    def show
        user = User.find(session[:user_id])
        render json: user
    rescue ActiveRecord::RecordNotFound
        render json: { error: 'Not authorized' }, status: :unauthorized        
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end
end
