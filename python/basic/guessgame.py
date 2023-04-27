sw = "socks"
guess = ""
guess_count = 0
guess_limit = 3
no_more_guesses = False
while guess != sw and not (no_more_guesses):
    if guess_count < guess_limit :
        guess = input("Enter guess: ")
        guess_count += 1
    else:
        no_more_guesses = True
if no_more_guesses:
    print ("you lose!")
else:
    print ("you win!")