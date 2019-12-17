import string
import sys

for line in sys.stdin:
    pp_line = []
    tokens = line.split()
    for token in tokens:
        if (token not in string.punctuation and
            token != "¿"):
            pp_line.append(token)
    print(' '.join(pp_line))
    
