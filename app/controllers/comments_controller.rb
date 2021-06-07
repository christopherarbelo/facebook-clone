class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)

    if @comment.save
      redirect_to root_path
    else
      flash[:error] = 'Something went wrong!'
      redirect_to root_path
    end
  end

  def destroy
  end

  private

  def comment_params
    hash = params.require(:comment).permit(:message)
    hash[:user_id] = current_user.id
    hash
  end
end
