class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @posts = Post.all.includes(:user)
  end

  def show
    
  end

  def new
    
  end

  def create
    
  end

  def edit
    
  end

  def update
    
  end

  def destroy

  end
end
