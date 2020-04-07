class ProblemsController < ApplicationController
  get "/problem-home" do
    redirect "/" if !logged_in?
    @problems = Problem.all
    @user = current_user
    @users = User.all
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

  get "/problems" do
    question = generate_problem
    @user = current_user
    @problem = @user.problems.create(question: question, answer: @answer)
    @user.save
    erb :'problems/new'
  end

  post "/problems/:id" do
    problem = Problem.find_by_id(params[:id])
    solution = Solution.create(explanation: params[:explanation], student_answer: params[:student_answer])
    problem.solution = solution
    problem.save
    redirect "solutions/#{solution.id}"
  end

end
