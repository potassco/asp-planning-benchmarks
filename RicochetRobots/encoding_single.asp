%#const row =  1.
%#const col = -1.

dir(west, -1, 0).
dir(east,  1, 0).
dir(north, 0,-1).
dir(south, 0, 1).

dl(west, -1).
dl(north,-1).
dl(east,  1).
dl(south, 1).

dir(west, 1).   %dir(west, row).
dir(east, 1).   %dir(east, row).
dir(north, -1). %dir(north,col).
dir(south, -1). %dir(south,col).

dir(D) :- dir(D,_).

robot(R) :- pos(R,_,_).

pos(R,1,I,0) :- pos(R,I,_).  %pos(R,row,I,0) :- pos(R,I,_).
pos(R,-1,J,0) :- pos(R,_,J). %pos(R,col,J,0) :- pos(R,_,J).

barrier(I+1,J,west ) :- barrier(I,J,east ), dim(I), dim(J), dim(I+1).
barrier(I,J+1,north) :- barrier(I,J,south), dim(I), dim(J), dim(J+1).
barrier(I-1,J,east ) :- barrier(I,J,west ), dim(I), dim(J), dim(I-1).
barrier(I,J-1,south) :- barrier(I,J,north), dim(I), dim(J), dim(I-1).

conn(D,I,J) :- dir(D,-1), dir(D,_,DJ), not barrier(I,J,D), dim(I), dim(J), dim(J+DJ). %conn(D,I,J) :- dir(D,col), dir(D,_,DJ), not barrier(I,J,D), dim(I), dim(J), dim(J+DJ).
conn(D,J,I) :- dir(D,1), dir(D,DI,_), not barrier(I,J,D), dim(I), dim(J), dim(I+DI).  %conn(D,J,I) :- dir(D,row), dir(D,DI,_), not barrier(I,J,D), dim(I), dim(J), dim(I+DI).

%step(1..X) :- length(X).
step(1).
step(X+1) :- step(X), length(L), X < L. 

{ occurs(some_action,T) } :- step(T).
1 <= { selectRobot(R,T) : robot(R) } <= 1 :- step(T), occurs(some_action,T).
1 <= { selectDir(D,O,T) : dir(D,O) } <= 1 :- step(T), occurs(some_action,T).

go(R,D,O,T) :- selectRobot(R,T), selectDir(D,O,T), step(T).
go_(R,O,T)   :- go(R,_,O,T), step(T).
go(R,D,T) :- go(R,D,_,T), step(T).

sameLine(R,D,O,RR,T)  :- go(R,D,O,T), pos(R,-O,L,T-1), pos(RR,-O,L,T-1), R != RR, step(T).
blocked(R,D,O,I+DI,T) :- go(R,D,O,T), pos(R,-O,L,T-1), not conn(D,L,I), dl(D,DI), dim(I), dim(I+DI), step(T).
blocked(R,D,O,L,T)    :- sameLine(R,D,O,RR,T), pos(RR,O,L,T-1), step(T).

reachable(R,D,O,I,   T) :- go(R,D,O,T), pos(R,O,I,T-1), step(T).
reachable(R,D,O,I+DI,T) :- reachable(R,D,O,I,T), not blocked(R,D,O,I+DI,T), dl(D,DI), dim(I+DI), step(T).

:- go(R,D,O,T), pos(R,O,I,T-1), blocked(R,D,O,I+DI,T), dl(D,DI), step(T).
:- go(R,D,O,T), go(R,DD,O,T-1), step(T).

pos(R,O,I,T) :- reachable(R,D,O,I,T), not reachable(R,D,O,I+DI,T), dl(D,DI), step(T).
pos(R,O,I,T) :- pos(R,O,I,T-1), not go_(R,O,T), step(T).

selectDir(O,T) :- selectDir(D,O,T), step(T).

%:- target(R,I,_), not pos(R,1,I,X), length(X).  
:- target(R,I,_), not pos(R,1,I,X), step(X), not step(X+1).
%:- target(R,_,J), not pos(R,-1,J,X), length(X). 
:- target(R,_,J), not pos(R,-1,J,X), stpe(X), not step(X+1).
