kirsten = User.create(username: "summerkaye86", password: "math", img_url:"/images/robot1.png")
kelley = User.create(username: "kelleywithlove", password: "money", img_url:"/images/robot2.png")
kyreese = User.create(username: "kyreese", password: "1010", img_url:"/images/robot3.png")
micca = User.create(username: "msmcc14", password: "1010", img_url:"/images/robot3.png")
britt = User.create(username: "adornedbybritt", password: "brady", img_url:"/images/robot3.png")

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

kelley.comments << first_comment
kelley.comments << second_comment
kelley.save

a = Friend.create(username: kelley.username)
b = Friend.create(username: kyreese.username)
c = Friend.create(username: micca.username)
d = Friend.create(username: britt.username)

kirsten.friends << a
kirsten.friends << b 
kirsten.friends << c
kirsten.friends << d


# student_solution.comments << first_comment
# student_solution.save
