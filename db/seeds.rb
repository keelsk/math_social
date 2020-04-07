kirsten = User.create(username: "kk", password: "math", img_url:"/images/robot1.png")
kelley = User.create(username: "kel", password: "money", img_url:"/images/robot2.png")

problem = "There are 5 candies. Susie ate 3. How many candies are there now?"
answer = 5-3

problem_1 = Problem.create(question: "There are 5 candies. Susie ate 3. How many candies are there now?", answer: answer)
kirsten.problems << problem_1
kirsten.save
# problem_1.user = kirsten


student_solution = Solution.create(explanation: "I knew I needed to subtract so I did 5-3.", student_answer: 2)
problem_1.solution = student_solution
problem_1.save

first_comment = Comment.create(content: "I agree with you.")
student_solution.comments << first_comment
student_solution.save

second_comment = Comment.create(content: "I changed my mind.")
student_solution.comments << second_comment
student_solution.save
# first_comment = Comment.create(content: "I agree with you!")

# kelley.comments << first_comment
# kelley.save

# student_solution.comments << first_comment
# student_solution.save
