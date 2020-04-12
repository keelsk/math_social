class SolutionsController < ApplicationController

  get "/solutions" do
    redirect "/login" if !logged_in?
    question = generate_problem
    @user = current_user
    @problem = @user.problems.create(question: question, answer: @answer)
    @user.save
    erb :'solutions/new'
  end

  post "/solutions/:problem_id" do
    redirect "/solutions" if params[:explanation] == ""|| params[:student_answer] == ""
    problem = Problem.find_by_id(params[:problem_id])
    solution = Solution.create(explanation: params[:explanation], student_answer: params[:student_answer])
    problem.solution = solution
    problem.save
    redirect "/problems/#{problem.user.username}"
  end

  get "/solutions/:id" do
    redirect "/login" if !logged_in?
    @solution = Solution.find_by_id(params[:id])
    @problem = @solution.problem
    # @comments = Comment.find_by(solution_id: @solution.id)
    erb :'solutions/show'
    # id refers to solution id
  end

  get "/solutions/:id/edit" do
    redirect "/login" if !logged_in?
    @solution = Solution.find_by_id(params[:id])
    @problem = @solution.problem
    redirect "/problem-home" if current_user.id != @problem.user.id
    erb :'solutions/edit'
  end

  patch "/solutions/:id" do
    redirect "/solutions/#{params[:id]}/edit" if params[:explanation] == ""|| params[:student_answer] == ""
    solution = Solution.find_by_id(params[:id])
    solution.update(explanation: params[:explanation], student_answer: params[:student_answer])
    redirect "/solutions/#{solution.id}"
  end

  delete "/solutions/:id" do
    solution = Solution.find_by_id(params[:id])
    problem = solution.problem
    user = problem.user
    problem.destroy
    solution.destroy
    redirect "/problems/#{user.username}"
  end
end
