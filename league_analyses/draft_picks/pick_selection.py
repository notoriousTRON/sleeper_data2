from random import choices
import time

#adjust the timers for added suspense (in seconds)
prob_timer=3
btw_prob_lottery_timer = 5
sleep_timer_lottery = 2
sleep_timer_playoffs = 1

#weights as agreed upon in the bylaws
official_weights = [10, 7, 5, 3, 2, 1]

#update with standings:
#team_finishes20 = ['Troey','Dave','Rapp','Turd','Richmond','Swoff']
#team_finishes21 = ['Swoff','Justin','Troey','Richmond','Brent','Dave']
team_finishes = {'12th place':'Swoff',
                 '11th place':'Justin',
                 '10th place':'Troey',
                 '9th place':'Richmond',
                 '8th place':'Brent',
                 '7th place':'Dave'
                }

#go through each team and update the pick ownership:
pick_held_by = {'Troey':'Jcon',
                'Dave':'Bryce',
                'Justin':'Bryce',
                'Turd':'Troey',
                'Richmond':'Bryce',
                'Swoff':'Bryce',
                'Landry':'Jcon',
                'Alex':'Richmond',
                'Bryce':'Swoff',
                'Ryan':'Dave',
                'Taco':'Richmond',
                'Brent':'Bryce'
               }

#update the 
#playoff_finishes = ['Landry','Alex','Bryce','Ryan','Taco','Brent']
playoff_finishes = {'1st place':'Taco',
                     '2nd place':'Turd',
                     '3rd place':'Landry',
                     '4th place':'Alex',
                     '5th place':'Bryce',
                     '6th place':'Ryry'
                    }

teams = [ i + 1 for i in range(6)]

def reset_weights():
    new = []
    for w in official_weights:
        new.append(w)
    return new

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
tm_dict = {'12th place':tm1,
           '11th place':tm2,
           '10th place':tm3,
           '9th place':tm4,
           '8th place':tm5,
           '7th place':tm6,}

trials = 100000

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
    
def finish(num):
    if num == 1:
        return str(num)+'st place'
    elif num == 2:
        return str(num)+'nd place'
    elif num == 3:
        return str(num)+'rd place'
    else:
        return str(num)+'th place'

print("the following percentages are based on ",trials," simulations")   
for f in range(6):
    time.sleep(prob_timer)
    current_owner = pick_held_by[team_finishes[finish(12-f)]]
    if team_finishes[finish(12-f)] == current_owner:
        print(finish(12-f)+" - "+team_finishes[finish(12-f)])
    else:
        print(finish(12-f)+" - "+team_finishes[finish(12-f)]+" (picked owned by "+current_owner+"):")
    print("1st overall:",str(100*results(tm_dict[finish(12-f)])[0]/trials)+"%")
    print("2nd overall:",str(100*results(tm_dict[finish(12-f)])[1]/trials)+"%")
    print("3rd overall:",str(100*results(tm_dict[finish(12-f)])[2]/trials)+"%")
    print("4th overall:",str(100*results(tm_dict[finish(12-f)])[3]/trials)+"%")
    print("5th overall:",str(100*results(tm_dict[finish(12-f)])[4]/trials)+"%")
    print("6th overall:",str(100*results(tm_dict[finish(12-f)])[5]/trials)+"%")

time.sleep(btw_prob_lottery_timer)
print("            ")
print("lottery selections:")

official_selection = 1
for x in range(official_selection):
    weights = reset_weights()
    res = []

    for i in range(6):
        time.sleep(sleep_timer_lottery)
        probabilities = [count/sum(weights) for count in weights]

        team_picked = choices(teams, probabilities)[0]
        pick_holder = pick_held_by[team_finishes[finish(13 - team_picked)]]
        orig_pick_owner = team_finishes[finish(13 - team_picked)]
        print('pick', i+1,': ', finish(13 - team_picked)+' - ',pick_holder,'('+orig_pick_owner+"'s pick"+')')
        
        res.append(team_picked)

        # update probabilities by discarding all the tickets
        # belonging to picked team
        weights[team_picked-1] = 0

"""        
time.sleep(sleep_timer_playoffs)
print("            ")
print("playoff finishes:")

for y in range(0,len(playoff_finishes)):
    time.sleep(sleep_timer_playoffs)
    pick_holder = pick_held_by[playoff_finishes[finish(6-y)]]
    orig_pick_owner = playoff_finishes[finish(6-y)]
    print('pick '+ str(y+7),': ',finish(6-y),' - ',pick_holder,'('+orig_pick_owner+"'s pick"+')')
"""