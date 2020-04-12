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
    no_solution = @user.problems.count do |problem|
        problem.solution.nil?
    end
    @solution_count = @user.problems.size - no_solution
    # if current_user.id != @user.id
    #   flash[:message] = "You do not have permission to access this page."
    #   redirect "/problem-home"
    # else
      # @problems = @user.problems || ""
      erb :'problems/index'
    # end
  end

end
