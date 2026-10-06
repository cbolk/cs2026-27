# Exam Grade Calculator

#input 
score = float(input(""))

#computation
if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

#output
print(grade)
