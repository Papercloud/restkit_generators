class Api::PostsController < ApplicationController

  def index
    render json: Post.all
  end

  def show
    render json: Post.find(params[:id])
  end

  def create
    render json: Post.all
  end

  def report
    render json: Post.all
  end
end