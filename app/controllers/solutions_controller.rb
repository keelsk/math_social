class SolutionsController < ApplicationController
  get "/solutions/:id" do
    @solution = Solution.find_by_id(params[:id])
    @problem = @solution.problem
    # @comments = Comment.find_by(solution_id: @solution.id)
    erb :'solutions/show'
    # id refers to solution id
  end
end
