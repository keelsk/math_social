require 'pry'
require 'sinatra'
require 'sinatra/flash'
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    register Sinatra::Flash
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
            "Karinna has #{@max} crayons, but she broke #{@min} crayons. How many crayons does she have now?",
            "Maurice saved #{@max} songs on his playlist, but he accidentally deleted #{@min} songs. How many songs are on his playlist now?",
            "John has #{@max} popsicles. He gives out #{@min} popsicles at his party. How many popsicles does he have now? "
          ],
          "separate change" => [
            "Mary grew #{@max} tulips in her garden. She sold some tulips. Now she has #{@min} tulips. How many tulips did Mary sell?",
            "Julia baked #{@max} brownies. Her brother ate some brownies. Now she has #{@min} brownies. How many brownies did her brother eat?",
            "The school library started the school year with #{@max} books. Some books were not returned to the library. Now the library has #{@min} books. How many books were lost during the school year? ",
            "The comic book store had #{@max} comics at the beginning of the week. During the week, some customers purchased comic books. Now the comic book store has #{@min} comics. How many comic books did the customers purchase?",
            "The museum gift shop had #{@max} souvenirs in the gift shop. Some customers bought some souvenirs. Now there are #{@min} souvenirs in the gift shop. How many souvenirs did the customers buy?"
          ],
          "separate start" => [
            "Some kids were playing on the playground. #{@max} kids went home. Now there are #{@min} kids playing on the playground. How many kids were playing at first?",
            "Stephanie had some candy. She gave Marcus #{@min} pieces of candy. Now she has #{@max} pieces of candy. How many pieces of candy did Stephanie have to begin with? ",
            "Eric has some cups of flour in the pantry. He used #{@max} cups to bake cookies. Now he has #{@min} cups of flour. How many cups of flour did he have in the pantry to start with?",
            "Joy picked some apples. She gave #{@max} apples to her mom. Now, Joy has #{@min} apples. How many apples did Joy pick to begin with?",
            "Casey has some Pokemon cards. She lost #{@max} cards. Now she has #{@min} cards. How many Pokemon cards did Casey have to start with?"
          ]
        },

        "part part whole" => {
          "part unknown" => [
            "Clariz has a treat bag. In her treat bag she has #{@min} starbursts and some skittles. If she has #{@max} pieces of candy in her treat bag, how many skittles does she have?",
            "Jeremiah has a pencil pouch with #{@min} pens and some pencils inside. If he has #{@max} writing utensils in his pencil pouch, how many are pencils?",
            "Sereniti has #{@min} comedies in her movie collection. If she has #{@max} movies in her move collection, how many movies are not comedies?",
            "Kingston has #{@max} books. Some books are fiction and #{@min} books are non-fiction. How many fiction books does Kingston have?",
            "Nicholas has #{@max} cards in his card collection. If he has #{@min} basketball cards and the rest are baseball cards, how many baseball cards does he have?"
          ],
          "whole unknown" => [
            "There are #{@max} marigolds and #{@min} daffodils in Maria's garden. How many flowers are in her garden?",
            "Jenna made #{@min} brownies and #{@max} cakes for the bake sale. How many treats did Jenna make for the bake sale?",
            "Michael has #{@max} books on his bookshelf and #{@min} books in his cabinet. How many books does Michael have?",
            "#{@min} students wrote a report for their final project, and #{@max} students performed a skit for their final project. How many students submitted a final project?",
            "The classroom library has #{@max} books about science and #{@min} books about math. How many books are in the classroom library?"
          ]
        },

        "compare" => {
          "difference unknown" => [
            "Jill has #{@min} stickers. Brad has #{@max} stickers. How many more sticers does Brad have than Jill?",
            "Mark scored #{@max} points. Fred scored #{@min} points. How many more points did Mark score than Fred?",
            "During the year, Trevin ran #{@min} miles and Elliott ran #{@max} miles. How many more miles did Elliott run than Trevin?",
            "Over the summer, Jack earned #{@max} dollars cutting grass, and Jerry earned #{@min} dollars cutting grass. How many more dollars did Jack earn than Jerry?",
            "In their first football seasons, Michael ran #{@min} yards and Todd ran #{@max} yards. How many more yards did Todd run than Michael?"
          ],
          "quantity more" => [
            "Jenna has #{@max} pieces of candy. Molly has #{@min} more pieces of candy than Jenna. How manh pieces of candy does Molly have? ",
            "Kelley has #{@min} instagram followers. Vanessa has #{@max} more instagram followers than Kelley. How many instagram followers does Vanessa have?",
            "Heather spent #{@max} dollars at the mall. Amber spent #{@min} more dollars than Heather. How much money did Amber spend at the mall?"
          ],
          "quantity less" => [
            "Jennifer has #{@max} teddy bears. Nicole has #{@min} less teddy bears than Jennifer. How many Teddy bears does Nicole have?",
            "Monica has #{@max} trophies. Helen has #{@min} less trophies than Monica. How many trophies does Helen have?"
          ],
          "referent more" => [
            "Jordan has #{@max} crayons. He has #{@min} more than Craig. How many crayons does Craig have?",
            "Jason has #{@max} marbles. He has #{@min} more than Quinton. How many marbles does Quinton have?",
            "Jori has written #{@max} stories. She has written #{@min} more stories than Kyle. How many stories has Kyle written?"
          ],
          "referent less" => [
            "Kevin has read #{@min} chapters. He has read #{@max} less chapters than Doug. How many chapters has Doug read?",
            "India has won #{@max} races. She has won #{@min} less races than Kia. How many races has Kia won?"
          ]
        },

        "equal groups" => {
          "product unknown" => [
            "Joy bought #{@min} boxes of cookies with #{@max} cookies in each box. How manhy cookies did she buy?",
            "Megan has #{@max} bookshelves with #{@min} books on each shelf. How many books does she have?",
            "There are #{@min} gardens on Mary's estate. Each garden has #{@max} flowers. How many plants are on Mary's estate?",
            "There are #{@max} chocolate factories in the United States. Each factory makes #{@min} pounds of chocolate each day. How much chocolate is made in one day in the United State?",
            "Matthew and his friends picked #{@max} cartons of strawberries. There were #{@min} strawberries in each carton. How many strawberries did they pick?"
          ],
          "group size" => [
            "Ms. Green had #{@max} treats to put in treat bags. If she made #{@min} treat bags and put the same amount of candy in each bag, how many full treat bags can she make?",
            "Gina has #{@max} bracelets. If she put the same amount of bracelets in #{@min} boxes. How many bracelets were in each box?",
            "There are #{@max} books in the library. If the librarian places the books on #{@min} bookshelves and each bookshelf holds the same amount of books, how many books fit on one bookshelf?"
          ],
          "number of groups" => [
            "The doughnut shop baked #{@max} doughnuts today. If #{@min} doughnuts fit in a box, how many boxes can be filled?",
            "If #{@min} crayons can fit in a box and there are #{@max} crayons on a table, how many boxes can be filled with these crayons?"
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
            ""
          ],
          "columns unknown" => [
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
            ""
          ],
          "referent unknown" => [
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
