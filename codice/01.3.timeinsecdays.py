# CONSTANT / ARBITRARY ASPECTS OF THE SOLUTION
SEC_IN_MIN = 60
MIN_IN_HR = 60
HR_IN_DAY = 24
SEC_IN_HR = (SEC_IN_MIN * MIN_IN_HR)
SEC_IN_DAY = SEC_IN_HR * HR_IN_DAY

# DATA ACQUISITION
timesec = int(input())

# COMPUTATION
num_days = timesec // SEC_IN_DAY
trem = timesec % SEC_IN_DAY

num_hr = trem // SEC_IN_HR
trem = trem % SEC_IN_HR

num_min = trem // SEC_IN_MIN
num_sec = trem % SEC_IN_MIN

# VISUALISATION
print(num_days, num_hr, num_min, num_sec)
