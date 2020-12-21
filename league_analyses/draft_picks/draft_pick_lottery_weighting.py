from random import choices

teams = [ i + 1 for i in range(6)]

def results(tm):
    cnt1 = 0
    cnt2 = 0
    cnt3 = 0
    cnt4 = 0
    cnt5 = 0
    cnt6 = 0

    for m in tm:
        if m == 1:
            cnt1 += 1
        if m == 2:
            cnt2 += 1
        if m == 3:
            cnt3 += 1
        if m == 4:
            cnt4 += 1
        if m == 5:
            cnt5 += 1
        if m == 6:
            cnt6 += 1
    return [cnt1,cnt2,cnt3,cnt4,cnt5,cnt6]

tm1 = []
tm2 = []
tm3 = []
tm4 = []
tm5 = []
tm6 = []

trials = 100000
def reset_weights():
    new = []
    for w in official_weights:
        new.append(w)
    return new


official_weights = [10, 7, 5, 3, 2, 1]

for x in range(trials):
    weights = reset_weights()
    
    res = []

    for i in range(6):

        probabilities = [count/sum(weights) for count in weights]

        team_picked = choices(teams, probabilities)[0]

        res.append(team_picked)

        # update probabilities by discarding all the tickets

        # belonging to picked team

        weights[team_picked-1] = 0

    tm1.append(res[0])
    tm2.append(res[1])
    tm3.append(res[2])
    tm4.append(res[3])
    tm5.append(res[4])
    tm6.append(res[5])

print("the following percentages are based on ",trials," simulations")
print("           pk1       pk2       pk3       pk4       pk5       pk6")
print("12th place: ",100*results(tm1)[0]/trials," ",100*results(tm1)[1]/trials," ",100*results(tm1)[2]/trials," ",
      100*results(tm1)[3]/trials," ",100*results(tm1)[4]/trials," ",100*results(tm1)[5]/trials)
print("11th place: ",100*results(tm2)[0]/trials," ",100*results(tm2)[1]/trials," ",100*results(tm2)[2]/trials," ",
      100*results(tm2)[3]/trials," ",100*results(tm2)[4]/trials," ",100*results(tm2)[5]/trials)
print("10th place: ",100*results(tm3)[0]/trials," ",100*results(tm3)[1]/trials," ",100*results(tm3)[2]/trials," ",
      100*results(tm3)[3]/trials," ",100*results(tm3)[4]/trials," ",100*results(tm3)[5]/trials)
print(" 9th place: ",100*results(tm4)[0]/trials," ",100*results(tm4)[1]/trials," ",100*results(tm4)[2]/trials," ",
      100*results(tm4)[3]/trials," ",100*results(tm4)[4]/trials," ",100*results(tm4)[5]/trials)
print(" 8th place: ",100*results(tm5)[0]/trials," ",100*results(tm5)[1]/trials," ",100*results(tm5)[2]/trials," ",
      100*results(tm5)[3]/trials," ",100*results(tm5)[4]/trials," ",100*results(tm5)[5]/trials)
print(" 7th place: ",100*results(tm6)[0]/trials," ",100*results(tm6)[1]/trials," ",100*results(tm6)[2]/trials," ",
      100*results(tm6)[3]/trials," ",100*results(tm6)[4]/trials," ",100*results(tm6)[5]/trials) 