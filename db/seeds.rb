kirsten = User.create(username: "kk", password: "math", img_url:"/images/profile1")
kelley = User.create(username: "kel", password: "money", img_url:"/images/profile2")

problem = "There are 5 candies. Susie ate 3. How many candies are there now?"
answer = 5-3

problem_1 = Problem.create(question: problem, answer: answer)

problem_1.user = kirsten

student_solution = Solution.create(explanation: "I knew I needed to subtract so I did 5-3.", student_answer: 2)

problem_1.solution = student_solution

first_comment = Comment.create(content:"I agree with you!")

first_comment.user = kelley

first_comment.solution = student_solution
