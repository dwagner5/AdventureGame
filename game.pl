/*
	Dakota Wagner's Adventure Game
	11/8/2018
*/

/*
   First, text descriptions of all the places in the game.
*/

description(house,
   'Wow! It\'s a great day outside!\nYou are standing in your driveway at your house. In front of you is the street, and to your right is your car.').
description(street,
	'You walk into the street.\n').
description(car,
   'You are in your car driving down the road. You can turn the wheel right, left, or continue forward.').
description(traffic,
	'You turn the wheel to the left.\n').
description(river,
	'You turn the wheel to the right.\n').
description(tintersection,
	'You arrive at a T-Intersection. You stop. Ahead is a nice playground where little Timmy is playing with his friends. A left yields Walmart. A right yields Starbucks.').
description(playground,
  'You drive forward into the playground.\n').
description(walmart(0),
  'You arrive at Walmart front entrance. There are lots of aisles. Wow. You could get lost in here!').
description(walmart(1),
    'This aisle looks kind of funny.\n').
description(walmart(3),
  'You are standing in an aisle. On your right is Axe "Chocolate Man" deodorant. On your left is the brand new Paul Gibson and the Barbershop Boiz music CD.').
description(walmart(_),
  'You are in Walmart. There are lots of aisles. Wow. You could get lost in here!').
description(deodorant,
  'You pick up the deodorant. Smells pretty good. This might come in handy! You buy it. Ahead is your car.').
description(musiccd,
  'You pick up the Paul Gibson and the Barbershop Boiz music CD. Paul is on the cover. He is wearing a unitard. You decide to purchase the CD. Ahead is your car.').
description(starbucks,
  'You arrive at the Starbucks. You order an iced vanilla soy latte with two pumps of raspberry, an extra half shot of espresso, with light whipped cream and a swirly straw.\n A strange looking man in a labcoat glares at you from his seat in the corner of the coffee shop.\nYour car is ahead.').
description(road,
  'You are driving down the road, you flip the radio on. To your left you see your friend Joel on the sidewalk. Pick him up or go forward?').
description(joel,
  'You stop and pick up Joel. He smells pretty bad. The raunch is similar to a sweaty oxen after a rough day plowing the fields. Go forward to continue ahead.').
description(roadtocrush,
  'You are driving on a road. Ahead is your crush\'s house! To your left is what appears to be a scenic detour.').
description(detour,
  'This detour is so pretty! Look at all those canyons and mountains! Wouldn\'t want to be driving distracted!').
description(crushhouse,
     'You arrive at your crush\'s house. Your nervously knock on the door. Her sister opens the door. She looks like a mashup of a troll and an ape. She is grumpy, and smells of month-old pudding.').



/*
   report prints the description of your current location.
*/
report :-
   at(you,X),
   description(X,Y),
   write(Y), nl.

/*
   These connect predicates establish the map.
   The meaning of connect(X, Dir, Y) is that if you
   are at X and you move in direction Dir, you
   get to Y. Recognized directions are
   forward, right, and left.
*/

connect(house, forward, street).
connect(house, right, car).
connect(car, left, traffic).
connect(car, right, river).
connect(car, forward, tintersection).
connect(tintersection, left, walmart(0)).
connect(tintersection, right, starbucks).
connect(tintersection, forward, playground).
connect(walmart(0), left, walmart(2)).
connect(walmart(0), right, walmart(1)).
connect(walmart(2), right, walmart(3)).
connect(walmart(3), right, deodorant).
connect(walmart(3), left, musiccd).
connect(walmart(_), _, walmart(0)).
connect(starbucks, forward, road).
connect(deodorant, forward, road).
connect(musiccd, forward, road).
connect(road, left, joel).
connect(joel, forward, roadtocrush).
connect(road, forward, roadtocrush).
connect(roadtocrush, left, detour).
connect(detour, forward, crushhouse).
connect(roadtocrush, forward, crushhouse).




/*
   move(Dir) moves you in direction Dir, then
   prints the description of your new location.
*/

move(Dir) :-
   at(you, Loc),
   connect(Loc, Dir, Next),
   retract(at(you, Loc)),
   assert(at(you, Next)),
   report.

/*
   But if the argument was not a legal direction,
   print an error message and don't move.
*/

move(_) :-
   write('That is not a legal move.\n'),
   report.

/*
   Shorthand for moves.
*/

f :- move(forward).
l :- move(left).
r :- move(right).
forward :- move(forward).
left :- move(left).
right :- move(right).

% These definitions determine whether you win when you get to the end


% if you have joel and the deodorant you win
crush :-
   at(friendjoel, crushhouse),
   at(axedeodorant, crushhouse),
   at(crush, crushhouse),
   at(you, crushhouse),
   write('You use the deodorant on Joel.\n'),
   write('He smells great now, and is able to distract the ugly sister while you head inside.\n'),
   write('You are able to use your charm on your crush, and you win her over.\n'),
   write('Congratulations, you won!\n'),
   retract(at(you,crushhouse)),
   assert(at(you,done)).
% if you have joel then the sister doesn't let you in
crush :-
  at(friendjoel, crushhouse),
  at(crush, crushhouse),
  at(you, crushhouse),
  write('Joel stinks so badly, the troll sister angrily slams the door shut.\n'),
  write('You lose. Go home and wallow in the fact that nobody loves you.\n'),
  retract(at(you,crushhouse)),
  assert(at(you,done)).
% if you come by yourself the sister kills you
crush :-
    at(crush, crushhouse),
    at(you, crushhouse),
    write('The troll sister instantly falls in love with you, and latches on to you.\n'),
    write('Her fat rolls smother you and you suffocate.\n'),
    write('You lose. You go home and cry.\n'),
    retract(at(you,crushhouse)),
    assert(at(you,done)).

crush.

% you 'bought' the cd

paulmusiccd :-
	at(you, musiccd),
	retract(at(paulmusiccd, musiccd)),
	assert(at(paulmusiccd, detour)).

% the cd causes you to die if you go to the detour

paulmusiccd :-
   at(paulmusiccd, detour),
   at(you, detour),
   write('You are distracted by the sweet sweet music of Paul Gibson.\n'),
   write('You veer off the road and tumble into a ravine.\n'),
   write('Your car explodes and your insides soar into the air like birthday confetti.\n'),
   write('You lose.\n'),
   retract(at(you, detour)),
   assert(at(you,done)).

paulmusiccd.

% you die if you walk into the street

street :-
   at(you, street),
   write('A schoolbus screams by, pasting you into the pavement. Oopsies!\n'),
   retract(at(you, street)),
   assert(at(you, done)).

street.

% if you go down the wrong aisle you die

walmart :-
  at(you, walmart(1)),
  write('You slip on a "cleanup" in aisle 3. You hit your head on Grandma Ethel\'s shopping cart and suffer severe brain trauma.'),
  retract(at(you, walmart(1))),
  assert(at(you, done)).

walmart.

% you die if you drive into the river

river :-
   at(you, river),
   write('Your car violently jerks as it hits the guardrail and your car explodes and barrel rolls into the river.'),
   retract(at(you, river)),
   assert(at(you, done)).

river.

% you die if you turn onto oncoming traffic

traffic :-
   at(you, traffic),
   write('You veer into oncoming traffic and are speared by the antennae of the Channel 6 news van.'),
   retract(at(you, traffic)),
   assert(at(you, done)).

traffic.

% you lose if you drive into the playground

playground :-
   at(you, playground),
   write('You explode Timmy and his friends and get the death sentence.'),
   retract(at(you, playground)),
   assert(at(you, done)).

playground.

% you 'bought' the deodorant

axedeodorant :-
	at(you, deodorant),
	retract(at(axedeodorant, deodorant)),
	assert(at(axedeodorant, crushhouse)).
axedeodorant.

% you picked up joel

friendjoel :-
	at(you, joel),
	retract(at(friendjoel, joel)),
	assert(at(friendjoel, crushhouse)).

friendjoel.


% if you go to starbucks, it engages this event

strangeman :-
  at(you, starbucks),
  assert(at(strangeman, roadtocrush)).

% if you have joel you don't die
strangeman :-
  at(you, roadtocrush),
  at(strangeman, roadtocrush),
  at(friendjoel, crushhouse),
  write('The man you saw at Starbucks is standing in the middle of the road.\nHe pulls you out of your car and tries to kill you.\n'),
  write('Fortunately, the stench from Joel\'s body is revolting and scares him away.\n').  
  
% if you get to the final road and strangeman is there, you die
strangeman :-
  at(you, roadtocrush),
  at(strangeman, roadtocrush),
  write('The man you saw at Starbucks is standing in the middle of the road.\nHe pulls you out of your car and dissects you.\n'),
  write('You are now dead. Oops!\n'),
  retract(at(you, roadtocrush)),
  assert(at(you, done)).




strangeman.



/*
   Main loop. Stop if player won or lost.
*/

main :-
   at(you, done),
   write('Thanks for playing.\n').
/*
   Main loop. Not done, so get a move from the user
   and make it. Then run all our special behaviors.
   Then repeat.
*/

main :-
   write('\nNext move? -> '),
   read(Move),
   call(Move),
   playground,
   street,
   river,
   traffic,
   walmart,
   axedeodorant,
   paulmusiccd,
   friendjoel,
   crush,
   strangeman,
   main.

/*
   This is the starting point for the game. We
   assert the initial conditions, print an initial
   report, then start the main loop.
*/

go:-
   retractall(at(_,_)), % clean up from previous runs
   assert(at(you, house)),
   assert(at(axedeodorant, deodorant)),
   assert(at(paulmusiccd, musiccd)),
   assert(at(friendjoel, joel)),
   assert(at(crush, crushhouse)),
   assert(at(strangeman, starbucks)),
   write('This is an adventure game. \n'),
   write('Legal moves are (l) left, (r) right, or (f) forward.\n'),
   write('End each move with a period. \n\n'),
   report,
   main.
