dir(e). dir(w). dir(n). dir(s).
inverse(e,w). inverse(w,e).
inverse(n,s). inverse(s,n).

row(X) :- field(X,Y).
col(Y) :- field(X,Y).

num_rows(X) :- row(X), not row(XX), XX = X+1.
num_cols(Y) :- col(Y), not col(YY), YY = Y+1.

goal(X,Y,0)   :- goal_on(X,Y).
reach(X,Y,0)  :- init_on(X,Y).
conn(X,Y,D,0) :- connect(X,Y,D).

step(S) :- max_steps(S),     0 < S.
step(T) :- step(S), T = S-1, 1 < S.

%%  Direct neighbors

dneighbor(n,X,Y,XX,Y) :- field(X,Y), field(XX,Y), XX = X+1.
dneighbor(s,X,Y,XX,Y) :- field(X,Y), field(XX,Y), XX = X-1.
dneighbor(e,X,Y,X,YY) :- field(X,Y), field(X,YY), YY = Y+1.
dneighbor(w,X,Y,X,YY) :- field(X,Y), field(X,YY), YY = Y-1.

%%  All neighboring fields

neighbor(D,X,Y,XX,YY) :- dneighbor(D,X,Y,XX,YY).
neighbor(n,X,Y, 1, Y) :- field(X,Y), num_rows(X).
neighbor(s,1,Y, X, Y) :- field(X,Y), num_rows(X).
neighbor(e,X,Y, X, 1) :- field(X,Y), num_cols(Y).
neighbor(w,X,1, X, Y) :- field(X,Y), num_cols(Y).


%%  Select a row or column to push

#program check(t).
neg_goal(t) :- goal(X,Y,t), not reach(X,Y,t).

#program step(t).
{ occurs(some_action,t) }.
rrpush(t)   :- neg_goal(S), S = t-1, not ccpush(t), occurs(some_action,t).
ccpush(t)   :- neg_goal(S), S = t-1, not rrpush(t), occurs(some_action,t).

orpush(X,t) :- row(X), row(XX), rpush(XX,t), X != XX.
ocpush(Y,t) :- col(Y), col(YY), cpush(YY,t), Y != YY.

rpush(X,t)  :- row(X), rrpush(t), not orpush(X,t).
cpush(Y,t)  :- col(Y), ccpush(t), not ocpush(Y,t).

push(X,e,t) :- rpush(X,t), not push(X,w,t).
push(X,w,t) :- rpush(X,t), not push(X,e,t).
push(Y,n,t) :- cpush(Y,t), not push(Y,s,t).
push(Y,s,t) :- cpush(Y,t), not push(Y,n,t).

%%  Determine new position of a (pushed) field

shift(XX,YY,X,Y,t) :- neighbor(e,XX,YY,X,Y), push(XX,e,t).
shift(XX,YY,X,Y,t) :- neighbor(w,XX,YY,X,Y), push(XX,w,t).
shift(XX,YY,X,Y,t) :- neighbor(n,XX,YY,X,Y), push(YY,n,t).
shift(XX,YY,X,Y,t) :- neighbor(s,XX,YY,X,Y), push(YY,s,t).
shift( X, Y,X,Y,t) :- field(X,Y), not push(X,e,t), not push(X,w,t), not push(Y,n,t), not push(Y,s,t).

%%  Move connections around

conn(X,Y,D,t) :- conn(XX,YY,D,S), S = t-1, dir(D), shift(XX,YY,X,Y,t).

%%  Location of goal after pushing

goal(X,Y,t) :- goal(XX,YY,S), S = t-1, shift(XX,YY,X,Y,t).

%%  Locations reachable from new position

reach(X,Y,t) :- reach(XX,YY,S), S = t-1, shift(XX,YY,X,Y,t).
reach(X,Y,t) :- reach(XX,YY,t), dneighbor(D,XX,YY,X,Y), conn(XX,YY,D,t), conn(X,Y,E,t), inverse(D,E).

%%  Goal must be reached

#program check(t).
:- neg_goal(t), query(t).

%% Project output
% #hide.
#show push/3.
