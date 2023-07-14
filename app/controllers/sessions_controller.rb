class SessionsController < ApplicationController
    # login post '/login'
    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: { errors: ['Invalid username or password'] }, status: :unauthorized
        end
    end

    # logout delete '/logout'
    def destroy
        user = User.find(session[:user_id])
        session.delete :user_id
        head :no_content
    rescue ActiveRecord::RecordNotFound => e
        render json: { errors: [e] }, status: :unauthorized
    end
end
