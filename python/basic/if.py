I_can_speak_French = True
I_can_speak_Russian = False

if I_can_speak_French and I_can_speak_Russian:
    print ("You can speak French and Russian")
elif I_can_speak_French and not(I_can_speak_Russian):
    print ("You can speak French but not Russian")
elif not(I_can_speak_French) and I_can_speak_Russian:
    print("You cannot speak French but Russian")
else:
    print ("You cannot speak neither of them")