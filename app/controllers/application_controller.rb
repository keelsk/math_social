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
    @session = session
    redirect '/problem-home' if logged_in?
    erb :index
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      user = User.find(session[:user_id])
    end

    def generate_image
      ["/images/robot1.png", "/images/robot2.png", "/images/robot3.png", "/images/robot4.png", "/images/robot5.png", "/images/robot6.png", "/images/robot7.png"].sample
    end

    def generate_problem
      @structure = choose_structure
      @problem_type = choose_problem_type
      pick_numbers
      generate_answer
      pick_problem
    end

    def choose_structure
      ["join", "separate", "part part whole", "compare", "equal groups", "array", "multiplicative comparison"].sample
    end

    def choose_problem_type
      problem_type = ["join result", "join change", "join start"].sample if @structure == "join"
      problem_type = ["separate result", "separate change", "separate start"].sample if @structure == "separate"
      problem_type = ["part unknown", "whole unknown"].sample if @structure == "part part whole"
      problem_type = ["difference unknown", "quantity more", "quantity less", "referent more", "referent less"].sample if @structure == "compare"
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

    def generate_answer
      @answer = @min * @max if @problem_type == "product unknown"
      if @problem_type != "product unknown" && (@structure == "equal groups" || @structure == "array" || @structure == "multiplicative comparison")
        quotient = @max / @min
        remainder = @max % @min
        @answer = quotient if remainder == 0
        @answer = "#{quotient} r #{remainder}"
      end
      if ["join change", "join start", "separate result", "separate change", "part unknown", "difference unknown", "quantity less", "referent more"].any? {|option| option == @problem_type}
        @answer = @max - @min
      end
      if ["join result", "separate start", "whole unknown", "quantity more", "referent less"].any? {|option| option == @problem_type}
        @answer = @max + @min
      end
    end

    def pick_problem
      tasks = {
        "join" => {
          "join result" => [
            "Jill has #{@min} marbles. Her mother gives her #{@max} marbles. How many marbles does she have now?",
            "Molly has #{@max} marbles in her collection. She buys #{@min} more marbles for her collection. How many marbles does she have now?",
            "Micca made #{@min} brownies for the school bake sale. Her mom baked #{@max} more brownies for the bake sale. How many brownies can be sold at the bake sale?",
            "James has #{@max} Pokémon cards at home. His best friend gave him #{@min} more Pokemon cards on his birthday. How many cards does James have now?",
            "Eric has #{@min} dollars in his piggy bank. He earned #{@max} dollars for cutting grass in the neighborhood. How much money does Eric have now?"
          ],
          "join change" => [
            "Jim has #{@min} toy cars. John gives him some more toy cars. Now Jim has #{@max} toy cars. How many toy cars did John give Jim?",
            "Kassidy earned #{@min} points while playing a game. He earned some more points during the next week. At the end of that week, he has #{@max} points. How many points did he earn that week?",
            "Akeelah read #{@min} words this morning. After lunch, she reads some more words. At the end of the day, she has read #{@max} words. How many words did Akeelah read after lunch",
            "Blake has #{@min} toy airplanes. Blythe gives him some more airplanes. Now he has #{@max} airplanes. How many airplanes did Blythe give Blake?",
            "James has #{@min} model cars. Nicholas gives him some more model cars. Now he has #{@max} model cars. How many cars did Nicholas give James?"
          ],
          "join start" => [
            "There are some birds perched in a tree. #{@min} more birds perch on the tree's branches. Now there are #{@max} birds in the tree. How many birds were in the tree before the other birds joined them?",
            "Molly has some money in her bank account. She put #{@min} dollars in her account. Now she has #{@max} dollars. How much money did Molly have to start with?",
            "Jenny has some marbles. Kelley gave her #{@min} marbles. Now Jenny has #{@max} marbles. How many marbles did Jenny have before Kelley gave her some more?",
            "Chris has some toys. His mom gave him #{@min} toys. Now, he has #{@max} toys. How many toys did Chris have before his mom gave him some more?",
            "Micca baked some cakes for the bake sale. She made #{@min} more cakes, because she didn't think she had enough. Now she has #{@max} cakes. How many cakes did Micca have before she baked some more?"
          ]
        },

        "separate" => {
          "separate result" => [
            "Ryan has #{@max} seashells in his collection. He lost #{@min}. How many seashells are in his collection now?",
            "Maria has #{@max} cookies. She gives #{@min} cookies to her best friend. How many cookes does Maria have now?",
            "",
            "",
            ""
          ],
          "separate change" => [
            "",
            "",
            "",
            "",
            ""
          ],
          "separate start" => [
            "",
            "",
            "",
            "",
            ""
          ]
        },

        "part part whole" => {
          "part unknown" => [
            "",
            "",
            "",
            "",
            ""
          ],
          "whole unknown" => [
            "",
            "",
            "",
            "",
            ""
          ]
        },

        "compare" => {
          "difference unknown" => [
            "",
            "",
            "",
            "",
            ""
          ],
          "quantity more" => [
            "",
            "",
            ""
          ],
          "quantity less" => [
            "",
            ""
          ],
          "referent more" => [
            "",
            "",
            ""
          ],
          "referent less" => [
            "",
            ""
          ]
        },

        "equal groups" => {
          "product unknown" => [
            "",
            "",
            "",
            "",
            ""
          ],
          "group size" => [
            "",
            "",
            "",
            "",
            ""
          ],
          "number of groups" => [
            "",
            "",
            "",
            "",
            ""
          ]
        },

        "array" => {
          "product unknown" => [
            "",
            "",
            "",
            "",
            ""
          ],
          "rows unknown" => [
            "",
            "",
            "",
            "",
            ""
          ],
          "columns unknown" => [
            "",
            "",
            "",
            "",
            ""
          ]
        },

        "multiplicative comparison" => {
          "product unknown" => [
            "",
            "",
            "",
            "",
            ""
          ],
          "multiplier unknown" => [
            "",
            "",
            "",
            "",
            ""
          ],
          "referent unknown" => [
            "",
            "",
            "",
            "",
            ""
          ]
        }
      }
      tasks[@structure][@problem_type].sample
    end
  end
end
