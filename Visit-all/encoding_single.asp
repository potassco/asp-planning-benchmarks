atrobot(X,0) :- at(X).

{ occurs(some_action,T) } :- step(T).
atrobot(N,T) :- connected(C,N), C != N, step(T), not atother(N,T),     occurs(some_action,T).
atother(N,T) :- connected(C,N), C != N, step(T), atrobot(O,T), O != N, occurs(some_action,T).

%1 <= { atrobot( Nextpos,T ) : connected( Curpos,Nextpos ), Curpos != Nextpos } <= 1 :- T=t.

move(C,N,T) :- atrobot(C,T-1), atrobot(N,T), connected(C,N), C != N, step(T).
done(T)     :- move(C,N,T), step(T).

:- step(T), not done(T), occurs(some_action,T).

visited(X,T) :- visited(X,T-1), step(T).
visited(X,T) :- atrobot(X,T), step(T).

:- visit(X), not visited(X,T), step(T), not step(T+1).
