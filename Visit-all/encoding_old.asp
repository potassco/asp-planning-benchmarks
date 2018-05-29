atrobot(X,0) :- at(X).

atrobot(N,T) :- connected(C,N), C != N, step(T), not atother(N,T).
atother(N,T) :- connected(C,N), C != N, step(T), atrobot(O,T), O != N.

% 1 <= { atrobot( Nextpos,T ) : connected( Curpos,Nextpos ), Curpos != Nextpos } <= 1 :- step(T).

move(C,N,T) :- atrobot(C,T-1), atrobot(N,T), connected(C,N), C != N.
done(T)     :- move(C,N,T).

:- step(T), not done(T).

visited(X) :- atrobot(X,T).

:- visit(X), not visited(X).
