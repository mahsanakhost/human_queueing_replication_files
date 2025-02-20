%Algorithm for the Numerical Study
%N=3 case
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameter Settings
%For running on the server
maxNumCompThreads(8) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%System related paramteres
%Objective
N=3; %BASE: 3
Btot=2*(N-1); %BASE: 4
%Erlang phases
PH=1; %BASE: 1
%%Basic setting is default --> hold unless otherwise stated
%Cmax
cm=0; %BASE: 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Behavioral parameters
% f varied in each in {0, 0.4} 
r=200.00; %%BASE: 200
additive=true; %%BASE: true
weightRUP=0.5; %BASE: 0.5
Work1N=0; %BASE: 0
a=0; %%BASE: 0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialize  Results struct
Result.N= N;
Result.Btot=Btot;
Result.PH=PH;
Result.cm=cm;
Result.f=-1;
Result.r=r;
Result.additive= additive;
Result.weightRUP=weightRUP;
Result.Work1N=Work1N;
Result.a=a; 
Result.par=0;
Result.Exp=' ';
Result.time=-1;
Result.Evcount=-1;
Result.allocation=-1;
Result.CT= 0;
Result.VAR= 0;
Result.TH=0;
Result.MeasB= 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count=0;  
F=[0.0];


%BELOW N=3

%Vary Btot
% Btot=6;
% Analysis(Result,count,N,Btot,PH,cm,F,r,additive,weightRUP,Work1N,a);
% Btot=8;
% Analysis(Result,count,N,Btot,PH,cm,F,r,additive,weightRUP,Work1N,a);
% Btot=10;
% Analysis(Result,count,N,Btot,PH,cm,F,r,additive,weightRUP,Work1N,a);
% Btot=12;
% Analysis(Result,count,N,Btot,PH,cm,F,r,additive,weightRUP,Work1N,a);

%Vary PH
Btot=4;
% PH=2;
% Analysis(Result,count,N,Btot,PH,cm,F,r,additive,weightRUP,Work1N,a);
PH=3;
Analysis(Result,count,N,Btot,PH,cm,F,r,additive,weightRUP,Work1N,a);
