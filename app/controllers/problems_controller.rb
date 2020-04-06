class ProblemsController < ApplicationController
  get "/problem-home" do
    redirect "/" if !logged_in?
    @problems = Problem.all
    @user = current_user
    @users = User.all
    erb :'problems/index'
  end

  get "/:username/problems" do

  end

end
