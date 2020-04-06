class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
     "Hello, World!"
  end

  helpers do
    def pick_numbers
      num1 = rand(1..999)
      num2 = rand(1..999)
    end

    def pick_problems
      tasks = {
        "join" => {
          "join result" => [
            "Jill has #{num1} marbles. Her mother gives her #{num2} marbles. How many marbles does she have now?",
            "Hey"
          ],
          "join change" => [
            "Jim has #{num1} toy cars. John gives him some more toy cars. Now Jim has #{num2} toy cars. How many toy cars did John give Jim?",
            "bye"
          ],
          "join start" => [
            ""
          ]
        },

        "separate" => {
          "separate result" => [
            ""
          ],
          "separate change" => [
            ""
          ],
          "separate start" => [
            ""
          ]
        },

        "part part whole" => {
          "part unknown" => [
            ""
          ],
          "whole unknown" => [
            ""
          ]
        },

        "compare" => {
          "difference unknown" => [
            ""
          ],
          "quantity unknown" => [
            ""
          ],
          "referent unknown" => [
            ""
          ]
        },

        "equal groups" => {
          "product unknown" => [
            ""
          ],
          "group size" => [
            ""
          ],
          "number of groups" => [
            ""
          ]
        },

        "array" => {
          "product unknown" => [
            ""
          ],
          "group size" => [
            ""
          ],
          "number of groups" => [
            ""
          ]
        },

        "multiplicative comparison" => {
          "product unknown" => [
            ""
          ],
          "multiplier unknown" => [
            ""
          ],
          "referent unknown" => [
            ""
          ]
        }
      }
    end

    def choose_operation
      operation = ["addition"].sample
      puts tasks[operation][problem_type].sample
    end

    def choose_problem
      problem_type = ["join result", "join change"].sample
    end

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @user = User.find(session[:user_id])
    end
  end
end
