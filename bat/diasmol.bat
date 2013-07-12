@echo off
attach smol2/?
map j:=smol2/bank:

j:
cd \diasoft\bank
vidram on > nul
call bat\m
start bank
c:
cd \
vidram off > nul
cls

logout smol2
map j:=parus/bank:
