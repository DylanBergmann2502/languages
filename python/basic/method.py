class Language:
    def __init__ (self, name, cases, verb_group):
        self.name = name
        self.cases= cases
        self.verb_group = verb_group
    def has_multiple_noun_declensions(self):
        if self.cases >= 4:
            return True
        else:
            return False

#from main import Language

language1 = Language ("russian", 4, 3)
language2 = Language ("french", 0, 3)
language3 = Language ("german", 4, 2)
language4 = Language ("english", 0, 1)

print (language1.has_multiple_noun_declensions())
