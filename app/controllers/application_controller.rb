require 'pry'
require 'rack-flash'
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    use Rack::Flash
  end

  get '/' do
     erb :index
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @user = User.find(session[:user_id])
    end

    def generate_image
      ["/images/robot1.png", "/images/robot2.png", "/images/robot3.png", "/images/robot4.png", "/images/robot5.png", "/images/robot6.png", "/images/robot7.png"].sample
    end

    def generate_problem
      @structure = choose_structure
      @problem_type = choose_problem_type
      pick_numbers
      @problem = pick_problem
    end

    def choose_structure
      ["join", "separate", "part part whole", "compare", "equal groups", "array", "multiplicative comparison"].sample
    end

    def choose_problem_type
      problem_type = ["join result", "join change", "join start"].sample if @structure == "join"
      problem_type = ["separate result", "separate change", "separate start"].sample if @structure == "separate"
      problem_type = ["part unknown", "whole unknown"].sample if @structure == "part part whole"
      problem_type = ["difference unknown", "quantity unknown", "referent unknown"].sample if @structure == "compare"
      problem_type = ["product unknown", "group size", "number of groups"].sample if @structure == "equal groups"
      problem_type = ["product unknown", "rows unknown", "columns unknown"].sample if @structure == "array"
      problem_type = ["product unknown", "multiplier unknown", "referent unknown"].sample if @structure == "multiplicative comparison"
      problem_type
    end

    def pick_numbers
      numbers = [[rand(2..9),rand(13..999)], [rand(10..99),rand(10..99)]].sample if @problem_type == "product unknown"
      numbers = [rand(2..9),rand(13..999)] if @problem_type != "product unknown" && (@structure == "equal groups" || @structure == "array" || @structure == "multiplicative comparison")
      numbers = [rand(1..999), rand(1..999)] if @structure == "join" || @structure == "separate" || @structure == "part part whole" || @structure == "compare"
      @min = numbers.min
      @max = numbers.max
    end

    def pick_problem
      tasks = {
        "join" => {
          "join result" => [
            "Jill has #{@min} marbles. Her mother gives her #{@max} marbles. How many marbles does she have now?",
            "Hey"
          ],
          "join change" => [
            "Jim has #{@min} toy cars. John gives him some more toy cars. Now Jim has #{@max} toy cars. How many toy cars did John give Jim?",
            "bye"
          ],
          "join start" => [
            "-"
          ]
        },

        "separate" => {
          "separate result" => [
            "-"
          ],
          "separate change" => [
            "-"
          ],
          "separate start" => [
            "-"
          ]
        },

        "part part whole" => {
          "part unknown" => [
            "-"
          ],
          "whole unknown" => [
            "-"
          ]
        },

        "compare" => {
          "difference unknown" => [
            "-"
          ],
          "quantity unknown" => [
            "-"
          ],
          "referent unknown" => [
            "-"
          ]
        },

        "equal groups" => {
          "product unknown" => [
            "-"
          ],
          "group size" => [
            "-"
          ],
          "number of groups" => [
            "-"
          ]
        },

        "array" => {
          "product unknown" => [
            "-"
          ],
          "rows unknown" => [
            "-"
          ],
          "columns unknown" => [
            "-"
          ]
        },

        "multiplicative comparison" => {
          "product unknown" => [
            "1"
          ],
          "multiplier unknown" => [
            "1"
          ],
          "referent unknown" => [
            "1"
          ]
        }
      }
      tasks[@structure][@problem_type].sample
    end
  end
end
