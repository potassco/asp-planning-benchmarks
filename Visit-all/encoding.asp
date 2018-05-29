atrobot(X,0) :- at(X).

#program step(t).
{ occurs(some_action,t) }.
atrobot(N,T) :- connected(C,N), C != N, T=t, not atother(N,T),     occurs(some_action,T).
atother(N,T) :- connected(C,N), C != N, T=t, atrobot(O,T), O != N, occurs(some_action,T).

%1 <= { atrobot( Nextpos,T ) : connected( Curpos,Nextpos ), Curpos != Nextpos } <= 1 :- T=t.

move(C,N,T) :- atrobot(C,T-1), atrobot(N,T), connected(C,N), C != N, T=t.
done(T)     :- move(C,N,T), T=t.

:- T=t, not done(T), occurs(some_action,T).

visited(X,T) :- visited(X,T-1), T=t.
visited(X,T) :- atrobot(X,T), T=t.

#program check(t).
:- visit(X), not visited(X,T), query(T), T=t.
