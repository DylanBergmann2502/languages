x = 1 # 1
# Notice that 1 = x is a valid expression,
# and it matched because both the left and
# right side are equal to 1. When the sides
# do not match, a MatchError is raised.
1 = x # 1
2 = x # ** (MatchError) no match of right hand side value: 1
