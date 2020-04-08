class ProblemsController < ApplicationController
  get "/problem-home" do
    redirect "/" if !logged_in?
    @user = current_user
    @friends = @user.get_friends
    erb :'problems/home'
  end

  get "/problems/:username" do
    @user = User.find_by(username: params[:username])
    if current_user != @user
      flash[:message] = "You do not have permission to access this page."
      redirect "/problem-home"
    else
      @problems = @user.problems
      erb :'problems/index'
    end
  end

end
