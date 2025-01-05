# Strict boolean operators: and, or, not
true and true    # Returns: true
true and false   # Returns: false
# 1 and true     # Raises ArgumentError
false or true    # Returns: true
not true         # Returns: false
# not 1          # Raises ArgumentError

# Truthy boolean operators: &&, ||, !
1 && 2          # Returns: 2
nil && 1        # Returns: nil
false && 1      # Returns: false
1 || 2          # Returns: 1
nil || 2        # Returns: 2
false || 2      # Returns: 2
!nil            # Returns: true
!false          # Returns: true
!5              # Returns: false
