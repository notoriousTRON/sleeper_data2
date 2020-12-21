from random import choices
import time

#update with standings:
team_finishes = ['Troey','Dave','Rapp','Turd','Richmond','Swoff']
pick_held_by = ['Bryce','Landry','Landry','Dave','Taco','Swoff']



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

trials = 1

for x in range(trials):

    weights = [10, 7, 5, 3, 2, 1]

    res = []

    for i in range(6):
        time.sleep(5)
        probabilities = [count/sum(weights) for count in weights]

        team_picked = choices(teams, probabilities)[0]
        print('pick ', i+1,': ',team_picked,' - ',pick_held_by[team_picked-1],'('+team_finishes[team_picked-1]+"'s pick"+')')
        
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
