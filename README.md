# Repository of ASP Planning Benchmarks
This repository contains ASP Planning problems. 
So far, all of them are from ASP Competitions.

File `incmode.lp` includes the clingo incremental mode.

Each folder contains files of one benchmark class:
* A bunch of instances
* A file `encoding.asp' with an incremental encoding to be used in clingo incmode. Example call:
```bash
clingo HanoiTower/0004-hanoi_tower-60-0.asp HanoiTower/encoding.asp incmode.lp
```
* A file `encoding_single.asp' with a normal encoding to be used in clingo normal mode. Example call:
```bash
clingo HanoiTower/0004-hanoi_tower-60-0.asp HanoiTower/encoding_single.asp
```
* A file `encoding_old.asp' with the original encoding of the ASP competition. Example call:
```bash
clingo HanoiTower/0004-hanoi_tower-60-0.asp HanoiTower/encoding_old.asp
```


