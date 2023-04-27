class Questions:
   def __init__ (self, prompt, answer):
        self.prompt = prompt
        self.answer = answer
question_prompt = [
    "What how many cases in Russian? \n A. 4 \n B. 5 \n C. 6 \n\n",
    "What how many cases in German? \n A. 4 \n B. 5 \n C. 6 \n\n"
]
questions = (
    Questions(question_prompt[0], "c"), 
    Questions(question_prompt[1], "a")
)
def run_test(questions):
    score = 0
    for question in questions:
        answer = input (question.prompt)
        if answer == question.answer:
            score += 1
    print ("You got " + str(score) + " right!")
    
run_test(questions)
        

    