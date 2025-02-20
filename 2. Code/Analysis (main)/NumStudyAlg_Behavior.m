%Algorithm for the Numerical Study
%N=3 case
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameter Settings
%For running on the server
maxNumCompThreads(8) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%System related paramteres (KEPT)
N=3; %BASE: 3
Btot=4; %BASE: 4
%Erlang phases
PH=1; %BASE: 1
%%%%%
%%behavioral parameters (VARIED)
%%Basic setting is default --> hold unless otherwise stated
%Cmax
cm=1; %BASE: 1
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
%specify ranges
Cm_Range= [0 1 2 3]; % parameter: 3-levels ?
R_RANGE=[200 0]; %options
Add_RANGE=[true false]; %options
We_RANGE=[0.5 1 0]; %parameter: 3-levels
A_RANGE=[0 0.2 -0.2]; %parameter: 3-levels
W1N_RANGE=[0 1]; % options


%%%ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Basic setting
%[Result count]=Analysis(Result,count,N,Btot,PH,cm,r,additive,weightRUP,Work1N,a);
% Behavioral Variations
SystemSet=0;
for cm=Cm_Range
for r=R_RANGE
for additive=Add_RANGE
for a=A_RANGE
    if(additive==true)
    for weightRUP=We_RANGE
    for Work1N= W1N_RANGE
    %%core
    if(SystemSet==0) %%the first of system set to run SIM, WLA & BA 
     F=[0 0.4];
     SystemSet=1;
     else %% further ones--> system paramters remain the same
     F=[0.4];  
     end
    [Result count]=Analysis(Result,count,N,Btot,PH,cm,F,r,additive,weightRUP,Work1N,a);
    %%core
    end
    end
    else
    %%core
    if(SystemSet==0) %%the first of system set to run SIM, WLA & BA 
     F=[0 0.4];
     SystemSet=1;
     else %% further ones--> system paramters remain the same
     F=[0.4];  
     end
    [Result count]=Analysis(Result,count,N,Btot,PH,cm,F,r,additive,weightRUP,Work1N,a);
    %%core
    end
end
end
end
end





