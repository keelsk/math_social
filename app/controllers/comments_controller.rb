class CommentsController < ApplicationController
  get "/comments/:solution_id" do
    redirect "/login" if !logged_in?
    @solution = Solution.find_by_id(params[:solution_id])
    @problem = @solution.problem
    erb :'comments/new'
  end

  post "/comments/:solution_id" do
    redirect "/comments/#{params[:solution_id]}" if params[:content] == ""
    @solution = Solution.find_by_id(params[:solution_id])
    new_comment = Comment.create(content: params[:content])
    @solution.comments << new_comment
    @solution.save
    user = current_user
    user.comments  << new_comment
    user.save
    redirect "/solutions/#{@solution.id}"
  end

  get "/comments/:comment_id/edit" do
    redirect "/login" if !logged_in?
    @comment = Comment.find_by_id(params[:comment_id])
    @solution = @comment.solution
    @problem = @solution.problem
    redirect "/solutions/#{@solution.id}" if current_user.id != @comment.user_id
    erb :'comments/edit'
  end

  patch "/comments/:comment_id" do
    redirect "/comments/#{params[:comment_id]}/edit" if params[:content] == ""
    comment = Comment.find_by_id(params[:comment_id])
    comment.update(content: params[:content])
    solution = comment.solution
    redirect "/solutions/#{solution.id}"
  end

  delete "/comments/:comment_id" do
    comment = Comment.find_by_id(params[:comment_id])
    solution = comment.solution
    comment.destroy
    redirect "/solutions/#{solution.id}"
  end
end
