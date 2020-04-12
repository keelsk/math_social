class ProblemsController < ApplicationController
  get "/problem-home" do
    redirect "/" if !logged_in?
    user = current_user
    @friends = user.get_friends
    @friends_problems = user.get_friends_problems
    erb :'problems/home'
  end

  get "/problems/:username" do
    redirect "/login" if !logged_in?
    @user = User.find_by(username: params[:username])
    @solution_count = 0 if !@user.problems
    @solution_count = @user.problems.count do |problem|
        !problem.solution.nil?
    end
    erb :'problems/index'
  end

end
