%
% Nomystery for ASP 2013.
%
% Domain specification freely adapted from the plasp PDDL-to-ASP output
% (http://potassco.sourceforge.net/labs.html)
%
% Author (2013) GB Ianni
%
%
%
truck(T) :- fuel(T,_).
package(P) :- at(P,L), not truck(P).
location(L) :- fuelcost(_,L,_).
location(L) :- fuelcost(_,_,L).
locatable(O) :- at(O,L).
%
at(O,L,0) :- at(O,L).
fuel(T,F,0) :- fuel(T,F).
%

action(unload(P,T,L))  :- package( P ), truck( T ), location( L ).
action(load(P,T,L))    :- package( P ), truck( T ), location( L ).
action(drive(T,L1,L2)) :- fuelcost( Fueldelta,L1,L2 ) , truck( T ).

%
% GENERATE  >>>>>

{ occurs(A,S) : action(A) } <= 1 :- step(S). % :- step(S), 0 < S.

done(S) :- occurs(A,S), step(S).
:- done(S), not done(S-1), 1 < S, step(S).

unload( P,T,L,S )  :- occurs(unload(P,T,L),S), step(S).
load( P,T,L,S )    :- occurs(load(P,T,L),S), step(S).
drive( T,L1,L2,S ) :- occurs(drive(T,L1,L2),S), step(S).
% <<<<<  GENERATE

% unload/4, effects
at( P,L,S ) :- unload( P,T,L,S ), step(S).
del( in( P,T ),S ) :- unload( P,T,L,S ), step(S).

% load/4, effects
del( at( P,L ),S ) :- load( P,T,L,S ), step(S).
in( P,T,S ) :- load( P,T,L,S ), step(S).

% drive/4, effects
del( at( T,L1 ), S ) :- drive( T,L1,L2,S ), step(S).
at( T,L2,S ) :- drive( T,L1,L2,S), step(S).
del( fuel( T,Fuelpre ),S ) :- drive( T,L1,L2,S ), fuel(T, Fuelpre,S-1), step(S).
fuel( T,Fuelpre - Fueldelta,S ) :- drive( T,L1,L2,S ), fuelcost(Fueldelta,L1,L2), fuel(T,Fuelpre,S-1), Fuelpre >= Fueldelta, step(S).
% <<<<<  EFFECTS APPLY
%
% INERTIA  >>>>>
at( O,L,S ) :- at( O,L,S-1 ), not del( at( O,L ),S  ), step(S).
in( P,T,S ) :- in( P,T,S-1 ), not del( in( P,T ),S  ), step(S).
fuel( T,Level,S ) :- fuel( T,Level,S-1 ), not del( fuel( T,Level) ,S ), truck( T ), step(S).
% <<<<<  INERTIA
%

%
%
% PRECONDITIONS CHECK  >>>>>

% unload/4, preconditions
 :- unload( P,T,L,S ), not preconditions_u( P,T,L,S ), step(S).
preconditions_u( P,T,L,S ) :- step(S), at( T,L,S-1 ), in( P,T,S-1 ), package( P ), truck( T ).

% load/4, preconditions
 :- load( P,T,L,S ), not preconditions_l( P,T,L,S ), step(S).
preconditions_l( P,T,L,S ) :- step(S), at( T,L,S-1 ), at( P,L,S-1 ).

% drive/5, preconditions
 :- drive( T,L1,L2,S ), not preconditions_d( T,L1,L2,S ), step(S).
preconditions_d( T,L1,L2,S ) :- step(S), at( T,L1,S-1 ), fuel( T, Fuelpre, S-1), fuelcost(Fueldelta,L1,L2), Fuelpre >= Fueldelta.
% <<<<<  PRECONDITIONS HOLD
%

% GOAL CHECK
:- goal(P,L), not at(P,L,S), step(S), not step(S+1).
%:- goal(P,L), step(S), not step(S+1), not at(P,L,S).

% goalreached :- step(S),  N = #count{ P,L : at(P,L,S) , goal(P,L) }, N = #count{ P1,L1 : goal(P1,L1) }.
% :- not goalreached.

% Gringo directives to show / hide particular literals
%#hide.
%#show unload/4.
%#show load/4.
%#show drive/4.
%#show at/2.
%#show at/3.
#show occurs/2.

