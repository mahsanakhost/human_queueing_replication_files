function result=E_V_TH_fatigue_2(par,x0,PH,cm,f0,r,additive,weightRUP,Work1N,a)
%Calculate the expected TH and varience of the cycle time (inter-competion times)
%   Detailed explanation goes here

% This version is an extended version of E_V_TH_fatigue_SIMPLE_submission
% (the model used when first time submitting to MSOM)
% (1) Models fatigue accumulations that differ based on the amount of speed up.
% (2) Models ph/w as the rate --> mean is kept same as k=1 case.
% (3) Allows non symmetrical reactions

% (4) Models adjacent workers -1 impact on idle ones rather than all completions -1.
% (5) Models the option to run nonadditive adjustments

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%System related paramteres
%Objective
%par=3; %which measure to return
%N and B are specified here
%x0=[1 1 1 2 2];
%Erlang phases
%PH=1;
%Cmax
%cm=2; %max 1 cycle of speedup: e.g. when c=0 only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Behavioral parameters
%f0=0.9; 
%r=0.00; %reaction 0:linear, OTHERWISE: extreme!
%additive=false; %%when additive not true
%weightRUP=0.5;
%Work1N=0; %0: worker 1 and N are subject to weightRUP as well 1: weight =1 for the adjacent buffer
%a=0; %0: linear fatigue, a>0 expo qick decrease a<0 saturation (less benefit from rest as accummulated fatigue approaches zero)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%those nt needed anymore
Item=1; %distribution of time until Item^th item to be produced!!!
JIT=5.2;

Cmax=[cm cm cm cm cm]; %upto 5
f=@(c,max)(f0*exp(-a*c)*(1-heaviside(max-0.5)*c/(max+heaviside(0.5-max))));

%%% Draw accumulated fatigue versus speedup parameter
%for ci=1:cm+1
%x(ci)=ci-1;
%drawf(ci)=f(ci-1,cm);
%end
%plot(x,drawf)
%%%

numStage=int32(length(x0)/2);
mu_0=[0.00 0.00 0.00 0.00 0.00]; %initialize mu's as if it is a 5 stage system
b=[0 0 0 0 ]; %initialize b's as if it is a 5 stage system
n=[0 0 0 0 ]; %initialize n's as if it is a 5 stage system

for i = 1:numStage 
mu_0(i)=double(PH/x0(i));
end
for i = 1:numStage-1
b(i)=int8(x0(numStage+i));
end
for i = 1:numStage-1
n(i)=int32(b(i)+2); %ith system can take 2 more than the max buffer size because of its definition including the number in the workstations
end


for i = 1:numStage 
weightRU(i)=weightRUP;
weightRD(i)=1-weightRU(i);
end

if(Work1N==1)
weightRU(1)=0;
weightRD(1)=1;
weightRU(numStage)=1;
weightRD(numStage)=0;
end


E_THsol=double(0);
V_CTsol=double(0);
%fullness
for i=1:(numStage-1)
    for j=1:(numStage)-i
full(i,j)= sum(b(j:j+i-1))+i+1; %%  The maximum number that the system can take (# of systems, starting workstation)
    end
end
for i=1:4
    if(numStage-1>=i)
upperbound(i)= n(numStage-i);
    else
upperbound(i)=0;
    end
end

for i=1:5
    if(numStage>=i)
upperboundc(i)= Cmax(i);
    else
upperboundc(i)=0;
    end
end

for i=1:5
    if(numStage>=i)
upperboundp(i)= PH;
    else
upperboundp(i)=1;
    end
end

%Build the state space!
numOrigstate=0;
for ph1=1:upperboundp(1)
    for ph2=1:upperboundp(2)
        for ph3=1:upperboundp(3)
            for ph4=1:upperboundp(4)
                for ph5=1:upperboundp(5)
for c1=0:upperboundc(1)
    for c2=0:upperboundc(2)
        for c3=0:upperboundc(3)
            for c4=0:upperboundc(4)
                for c5=0:upperboundc(5)
for  i=0:upperbound(1) %system 1
for  j=0:upperbound(2) %system 2
for  k=0:upperbound(3) %system 3
for  l=0:upperbound(4) %system 4
if numStage==5 && i+j+k+l<=full(4,1) && l+k+j<=full(3,1) && k+j+i<=full(3,2) && l+k<=full(2,1) && k+j<=full(2,2) && j+i<=full(2,3)
  numOrigstate=numOrigstate+1; 
  state(numOrigstate).content = [l k j i c1 c2 c3 c4 c5 ph1 ph2 ph3 ph4 ph5]; 
  state(numOrigstate).number=numOrigstate;
end
if numStage==4 &&  i+j+k<=full(3,1) && k+j<=full(2,1) && j+i<=full(2,2)
  numOrigstate=numOrigstate+1;  
  state(numOrigstate).content = [k j i c1 c2 c3 c4 ph1 ph2 ph3 ph4]; 
  state(numOrigstate).number=numOrigstate;
end
if numStage==3 &&  i+j<=full(2,1) 
  numOrigstate=numOrigstate+1; 
  state(numOrigstate).content = [j i c1 c2 c3 ph1 ph2 ph3]; 
  state(numOrigstate).number=numOrigstate;
end
end
end
end
end
        end     
    end
end
    end
end
        end
    end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Idle and busy cases for all workstations
% (1) workstation 1, first, can't be starved! Only the fullness
workstation=1;
for s = 1:numOrigstate
    if sum(arrayfun(@(x) sum(state(s).content(workstation:workstation+x-1))==full(x,workstation) , 1:numStage-workstation))>=1
        state(s).mu(workstation) =double(0) ;
    else
        state(s).mu(workstation) =double(mu_0(workstation)) ;
        state(s).maxBUSY=workstation;
    end
end
% (2) intermediate workstations can be starved and blocked (rest of the system is full)
for workstation=2:numStage-1
for s = 1:numOrigstate
    if  sum([ state(s).content(workstation-1) ==  0  arrayfun(@(x) sum(state(s).content(workstation:workstation+x-1))==full(x,workstation) , 1:numStage-workstation)])>=1
        state(s).mu(workstation) =0 ;
    else
        state(s).mu(workstation) =mu_0(workstation);
        state(s).maxBUSY=workstation;
    end
end
end
% (3) Last workstation can only  be starved
workstation=numStage;
for s = 1:numOrigstate
    if state(s).content(workstation-1) == 0 
        state(s).mu(workstation) = double(0) ;
    else
        state(s).mu(workstation) =double(mu_0(workstation)) ;
        state(s).maxBUSY=workstation;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Obtain the buffer contents in each state
for s = 1:numOrigstate
for i=1:numStage-1
if state(s).content(i)==n(i)    
       state(s).bufcont(i)=b(i);
elseif state(s).content(i)==0 
     state(s).bufcont(i)=0;      
elseif i+1 ~= numStage && state(s).mu(i+1)==0 % i+1: not the last WS and idle although not starved (blocked)
   if i>1 && state(s).mu(i)==0 && state(s).content(i-1)>0  % i: idle although not starved (blocked)
      state(s).bufcont(i)=state(s).content(i)-1; 
   elseif i==1 && state(s).mu(i)==0 %because WS1 can only be blocked
     state(s).bufcont(i)=state(s).content(i)-1;  
   else %not idle or idle due to starvation
      state(s).bufcont(i)=state(s).content(i); 
   end
elseif   i+1== numStage  || state(s).mu(i+1)>0 % i+1: is the last WS or not idle (not blocked)
    if i>1 && state(s).mu(i)==0 && state(s).content(i-1)>0  % i: idle although not starved (blocked)
     state(s).bufcont(i)=state(s).content(i)-2; 
    elseif i==1 && state(s).mu(i)==0  %because WS1 can only be blocked
     state(s).bufcont(i)=state(s).content(i)-2;    
   else %not idle or idle due to starvation
      state(s).bufcont(i)=state(s).content(i)-1; 
   end
end
end
end


%Link nominal mu's to adjusted mu's dependent on the buffer contents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for s = 1:numOrigstate
    for k=1:numStage
    state(s).ReactPerc(k)=0; %initialize the reaction to be zero for all
    adjustment(k)=0;
    RU(k)=0;
    RD(k)=0;
    end
%%%%%%%% For the first worker
workstation=1;
if state(s).mu(workstation)>0 %not idle
bb=state(s).bufcont(workstation); %current
B=b(workstation);%max
%%% Reaction type
if r==0 %%Linear
RD(workstation)=(B-bb)/B;  %downstream adjstment
else %% Extreme state
if bb==0 RD(workstation)=1; else RD(workstation)=0; end %react full if empty none otherwise
end
state(s).ReactPerc(workstation)=RD(workstation)/1; %%This gives a percentage: how much of the total reaction is necessary. Divide by one because 100% comes from 1 buffer (RD)
if(additive==true)
adjustment(workstation)=RD(workstation)*weightRD(workstation);
else
adjustment(workstation)=max(RU(workstation),RD(workstation)); %maximum
end
state(s).muADJ(workstation)=1.0/(1/state(s).mu(workstation)-1/state(s).mu(workstation)*f(state(s).content(numStage-1+workstation),Cmax(workstation))*adjustment(workstation));     
end
%%%%%%%%% For interim workers
for workstation=2:numStage-1
if state(s).mu(workstation)>0
  bbek1=state(s).bufcont(workstation-1); %current
  Bek1=b(workstation-1);%max  
  bb=state(s).bufcont(workstation); %current
  B=b(workstation);%max
if r==0 %%Linear
RU(workstation)=bbek1/Bek1;
RD(workstation)=(B-bb)/B;  %downstream adjstment
else %% Extreme state
%%%%upstream
if bbek1==Bek1 RU(workstation)=1; else RU(workstation)=0; end %react full if full, none otherwise
%%%%downstream
if bb==0 RD(workstation)=1; else RD(workstation)=0; end %react full if empty, none otherwise
end
state(s).ReactPerc(workstation)=(RU(workstation)+RD(workstation))/2; %%This gives a percentage: how much of the total reaction is necessary. Divide by 2 because 100% comes from 2 buffer (RU+RD)
if(additive==true)
adjustment(workstation)=RU(workstation)*weightRU(workstation)+RD(workstation)*weightRD(workstation); %%weighted sum 
else
adjustment(workstation)=max(RU(workstation),RD(workstation)); %maximum
end
state(s).muADJ(workstation)=1.0/(1/state(s).mu(workstation)-1/state(s).mu(workstation)*f(state(s).content(numStage-1+workstation),Cmax(workstation))*adjustment(workstation));     
end
end
%%%%%%%% For the last worker
workstation=numStage;
if state(s).mu(workstation)>0
bbek1=state(s).bufcont(workstation-1); %current
Bek1=b(workstation-1);%max 
%%% Reaction type
if r==0 %%Linear
RU(workstation)=bbek1/Bek1;  %downstream adjstment
else %% Extreme state
if bbek1==Bek1 RU(workstation)=1; else RU(workstation)=0; end %react full if full, none otherwise
end
state(s).ReactPerc(workstation)=(RU(workstation))/1; %%This gives a percentage: how much of the total reaction is necessary. Divide by 1 because 100% comes from 1 buffer (RU)
if(additive==true)
adjustment(workstation)=RU(workstation)*weightRU(workstation);
else
adjustment(workstation)=RU(workstation); %maximum
end
state(s).muADJ(workstation)=1.0/(1/state(s).mu(workstation)-1/state(s).mu(workstation)*f(state(s).content(numStage-1+workstation),Cmax(workstation))*adjustment(workstation));      
else state(s).muADJ(workstation)=0;
end
end

spN=ones([1 numOrigstate]);
G=double(zeros([numOrigstate]));
Q=double(zeros([numOrigstate]));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Transition Rates (Prepare Matrix Q)
for s=1:numOrigstate
if state(s).mu(1)>0
%% Workstation 1
%current content
mu1s=state(s).content; %Take the current content of the state for N=3: (n1,n2,c1,c2,c3,ph1,ph2,ph3)
%adjust the content BEGIN
if mu1s(2*numStage-1+1)<PH %% phase has not reached the upperbound k=PH
mu1s(2*numStage-1+1)=state(s).content(2*numStage-1+1)+1; % adjust the phase. Meaning that the rest is kept the same
else %all phases completed
%%%%% phase refresh
mu1s(2*numStage-1+1)=1; % refresh the phase. Meaning that the rest is kept the same
%%%%% buffer grow
mu1s(1)=state(s).content(1)+1; % adjust the first one. Meaning that the rest is kept the same
%what happens to worker 1 when he finishes an item
%if state(s).muADJ(1)>state(s).mu(1) && state(s).ReactPerc(1)<=0.5  % eger adjusted mu nominaldan büyükse AMA reaction<=0.5
%mu1s(numStage-1+1)=state(s).content(numStage-1+1); % +0 && -0
if state(s).muADJ(1)>state(s).mu(1) && state(s).ReactPerc(1)>0.5 % eger adjusted mu nominaldan büyükse VE reaction>0.5
mu1s(numStage-1+1)=min(Cmax(1),state(s).content(numStage-1+1)+1); % more tired  +1
elseif state(s).muADJ(1)==state(s).mu(1) % adj daha buyuk degil 
mu1s(numStage-1+1)= max(0,state(s).content( numStage-1+1)-1);  %less tired     
end %what happens to worker 1 when he finishes an item
adjacent=[2];
for w= adjacent %what happens to other workers when worker 1 competes an item
if state(s).mu(w)==0  %%Others?: check from 2 to the end if there was an idle one in state s (current) whose accum. fatigue is still larger than 0 :Decrease it
mu1s(numStage-1+w)=max(0,state(s).content(numStage-1+w)-1);     %rest for idle ones (others)  
end
end % END of what happens to other workers when worker 1 competes an item
end
%%check if the transition is feasile & go
if isempty(find(cellfun(@(x)isequal(x,mu1s),{state.content}) ))==0 % if there is a matching state with this one (transition is within the state space)
    sp1=find( cellfun(@(x)isequal(x,mu1s),{state.content}) ); %then, find the number/ID of the the state that should be visited next
    Q(s,sp1)=double(state(s).muADJ(1)); %calculate & assign the transition rate (transition rate is the adjusted mu1 regardless of whether it is equal to or larger than the nominal)
end
end
%% Intermediate Workstations
for i=2:numStage-1 
if state(s).mu(i)>0
%current content
muis=state(s).content; %Take the current content of the state
%adjust the content BEGIN
if muis(2*numStage-1+i)<PH %% phase has not reached the upperbound k=PH
muis(2*numStage-1+i)=state(s).content(2*numStage-1+i)+1; % adjust the phase. Meaning that the rest is kept the same
else %all phases completed
 %muisold=muis
muis(i-1)=state(s).content(i-1)-1; % item moves from left to right
muis(i)=state(s).content(i)+1;  
%% phase refresh
muis(2*numStage-1+i)=1; % adjust the phase. Meaning that the rest is kept the same
%% what happens to worker
%if state(s).muADJ(i)>state(s).mu(i) && state(s).ReactPerc(i)<=0.5
%muis(numStage-1+i)=state(s).content(numStage-1+i); %+0 && -0
if state(s).muADJ(i)>state(s).mu(i) && state(s).ReactPerc(i)>0.5
muis(numStage-1+i)=min(Cmax(i),state(s).content(numStage-1+i)+1); %more tired    
elseif state(s).muADJ(i)==state(s).mu(i)
muis(numStage-1+i)=max(0,state(s).content(numStage-1+i)-1); %rest (if no need to speedup and if cant speedup: both lead to mu=muADJ)
end
%what happens to other workers
adjacent=[i-1 i+1];
for w= adjacent
    if state(s).mu(w)==0 
muis(numStage-1+w)=max(0,state(s).content(numStage-1+w)-1);     %rest for idle ones  
    end
end
end
%% check if transition is feasible and go
    if isempty(find(cellfun(@(x)isequal(x,muis),{state.content}) ))==0
    %     muisnew=muis
    spi=find( cellfun(@(x)isequal(x,muis),{state.content}) );
    Q(s,spi)=double(state(s).muADJ(i));
    end
    end
end
%% The last workstation
if state(s).mu(numStage)>0
%current state
muNs=state(s).content;
%
if muNs(3*numStage-1)<PH %% phase has not reached the upperbound k=PH
muNs(3*numStage-1)=state(s).content(3*numStage-1)+1; % adjust the phase. Meaning that the rest is kept the same
else %all phases completed
muNs(numStage-1)=state(s).content(numStage-1)-1;
% phase refresh
muNs(3*numStage-1)=1; % adjust the phase. Meaning that the rest is kept the same
%% what happens to this worker
%if state(s).muADJ(numStage)>state(s).mu(numStage) && state(s).ReactPerc(numStage)<=0.5
%muNs(2*numStage-1)=state(s).content(2*numStage-1); %+0 & -0
if state(s).muADJ(numStage)>state(s).mu(numStage) && state(s).ReactPerc(numStage)> 0.5
muNs(2*numStage-1)=min(Cmax(numStage),state(s).content(2*numStage-1)+1); %more tired
elseif state(s).muADJ(numStage)==state(s).mu(numStage) 
muNs(2*numStage-1)=max(0,state(s).content(2*numStage-1)-1); %less tired
end
adjacent=[numStage-1];
for w= adjacent 
    if state(s).mu(w)==0 
muNs(numStage-1+w)=max(state(s).content(numStage-1+w)-1,0);     %rest for idle ones  
    end
end
end
    if isempty(find(cellfun(@(x)isequal(x,muNs),{state.content}) ))==0
    spN(s)=find( cellfun(@(x)isequal(x,muNs),{state.content}) );
      Q(s,spN(s))=double(state(s).muADJ(numStage));    
    if state(s).content(3*numStage-1)==PH 
    G(s,spN(s))=double(1);
    else
    G(s,spN(s))=double(0);   
          end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%minus values to diagonal, for the CTMC case
for s=1:numOrigstate
    for sp=1:numOrigstate
        if s==sp
  Q(s,sp)=double(-sum(state(s).muADJ)); 
        end
    end
end

%solution=MarkovSolve2(Q,numOrigstate)
%sum(solution)

%Buiding necessary Matrices
Rd_hat=double(Q.*G); %exits
Qd_hat=double(Q-Rd_hat); %no exits

numExstate=numOrigstate*Item;
Qd=double(zeros([numExstate]));
Rd=double(zeros([numExstate]));

%Construct Qd
%Put Qd_hats
for i=1:Item
    start=(i-1)*numOrigstate+1;
    ende=start+numOrigstate-1;
    Qd(start:ende,start:ende)=double(Qd_hat);
end
%Put Rd_hats
for i=1:Item-1
    start1=(i-1)*numOrigstate+1;
    ende1=start1+numOrigstate-1;
    start2=start1+numOrigstate;
    ende2=ende1+numOrigstate;
    Qd(start1:ende1,start2:ende2)=double(Rd_hat);
end

%Construct Rd
%Put Rd_hat
    %last row range
    start1=(Item-1)*numOrigstate+1;
    ende1=start1+numOrigstate-1;
    %first column range
    start2=1;
    ende2=start2+numOrigstate-1;
    Rd(start1:ende1,start2:ende2)=double(Rd_hat);

IQd=double(inv(double(Qd)));
Express=double(eye(numExstate))+IQd*Rd;
solution2=MarkovSolve2(Express,numExstate); %dogru cözüyor (extended MC)
u=ones([numExstate 1]); %column

pi_entry=solution2';
%(1) Calculate expected time to produce "Item" many items
E_CT=-pi_entry*IQd*u;
%E_THsol=-1/E_CT; % negative value is sent because we are using a minimization function

%(2) Calculate variance of the cycle time
V_CTsol=2*(pi_entry)*IQd^2*u-(-E_CT)^2;

%(3) service Level
%Fcum=@(t)(1-pi_entry*expm(Qd*t)*u);
%%%%
%SL=Fcum(JIT);

%DoubleChecking the distributions
%fdens=@(t)(-pi_entry*Qd*expm(Qd*t)*u);
%syms x
%DoubleCheckMean=double(int(-pi_entry*Qd*expm(Qd*x)*u*x, 0, 100))
%DoubleCheckEx2=double(int(-pi_entry*Qd*expm(Qd*x)*u*x^2, 0, 100));
%DoubleCheckVar=DoubleCheckEx2-DoubleCheckMean^2
if par==1
result=E_CT;
elseif par==2
result=V_CTsol;
elseif par==3
result=[1/E_CT E_CT V_CTsol];
end
end
%}
