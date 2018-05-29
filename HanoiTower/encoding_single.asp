% The meaning of the time predicate is self-evident. As for the disk
% predicate, there are k disks 1,2,...,k. Disks 1, 2, 3, 4 denote pegs. 
% Disks 5, ... are "movable". The larger the number of the disk, 
% the "smaller" it is.
%
% The program uses additional predicates:
% on(T,N,M), which is true iff at time T, disk M is on disk N
% move(t,N), which is true iff at time T, it is disk N that will be
% moved
% where(T,N), which is true iff at time T, the disk to be moved is moved
% on top of the disk N.
% goal, which is true iff the goal state is reached at time t
% steps(T), which is the number of time steps T, required to reach the goal (provided part of Input data)

% Read in data
on(0,N1,N) :- on0(N,N1).
%onG(K,N1,N) :- ongoal(N,N1), steps(K).

% Specify valid arrangements of disks
% Basic condition. Smaller disks are on larger ones

:- time(T), on(T,N1,N), N1>=N.

% Specify a valid move (only for T<t)
% pick a disk to move

{ occurs(some_action,T) } :- time(T), T>0.
1 { move(T,N) : disk(N) } 1 :- occurs(some_action,T).

% pick a disk onto which to move
1 { where(T,N) : disk(N) }1 :- occurs(some_action,T).

% pegs cannot be moved
:- move(T,N), N<5.

% only top disk can be moved
:- on(T-1,N,N1), move(T,N).

% a disk can be placed on top only.
:- on(T-1,N,N1), where(T,N).

% no disk is moved in two consecutive moves
:- move(T,N), move(TM1,N), TM1=T-1.

% Specify effects of a move
on(T,N1,N) :- move(T,N), where(T,N1).
on(T,N,N1) :- time(T), T>0,
              on(T-1,N,N1), not move(T,N1).


% Goal description
:- not on(T,N,N1), ongoal(N1,N), steps(T).
:- on(T,N,N1), not ongoal(N1,N), steps(T).

% Solution
#show put(M,N,T) : move(T,N), where(T,M).

