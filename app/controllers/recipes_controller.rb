class RecipesController < ApplicationController
    before_action :authorize

    def index
        render json: Recipe.all, include: :user
    end

    def create
        recipe = Recipe.create!(recipe_params.merge(user_id: session[:user_id]))
        render json: recipe, status: :created
    rescue ActiveRecord::RecordInvalid => e 
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    private

    def authorize
        return render json: { errors: ['Not authorized'] }, status: :unauthorized unless session.include? :user_id
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end
end
