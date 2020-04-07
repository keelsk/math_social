class SolutionsController < ApplicationController

  get "/solutions" do
    question = generate_problem
    @user = current_user
    @problem = @user.problems.create(question: question, answer: @answer)
    @user.save
    erb :'solutions/new'
  end

  post "/solutions/:problem_id" do
    problem = Problem.find_by_id(params[:problem_id])
    solution = Solution.create(explanation: params[:explanation], student_answer: params[:student_answer])
    problem.solution = solution
    problem.save
    redirect "solutions/#{solution.id}"
  end

  get "/solutions/:id" do
    @solution = Solution.find_by_id(params[:id])
    @problem = @solution.problem
    # @comments = Comment.find_by(solution_id: @solution.id)
    erb :'solutions/show'
    # id refers to solution id
  end

  get "/solutions/:id/edit" do
    @solution = Solution.find_by_id(params[:id])
    @problem = @solution.problem
    erb :'solutions/edit'
  end

  patch "/solutions/:id" do
    solution = Solution.find_by_id(params[:id])
    solution.update(explanation: params[:explanation], student_answer: params[:student_answer])
    redirect "/solutions/#{solution.id}"
  end

  delete "/solutions/:id" do
    solution = Solution.find_by_id(params[:id])
    solution.problem.destroy
    solution.destroy
    redirect '/problems/:username'
  end
end
