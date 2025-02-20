%% Work load allocation 
function result=WLA(N,Btot,par,PH,cm,f,r,additive,weightRUP,Work1N,a)
%N=3;
%Btot=2;
%par=1;
%Erlang phases
%PH=1;
%Cmax
%cm=1; %max 1 cycle of speedup: e.g. when c=0 only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Behavioral parameters
%f=0.9; 
%r=0.00; %reaction 0:linear, OTHERWISE: extreme!
%additive=false; %%when additive not true
%weightRUP=0.5;
%Work1N=0; %0: worker 1 and N are subject to weightRUP as well 1: weight =1 for the adjacent buffer
%a=0; %0: linear fatigue, a>0 expo qick decrease a<0 saturation (less benefit from rest as accummulated fatigue approaches zero)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(N==3)
%(1):WLA 
%(Balanced Buffer allocation)
B1=Btot/2;
B2=Btot/2;
%Optimization Matrix
Aeq=[1 1 1  0 0  ; 0 0 0  1 0  ; 0 0 0  0 1]; %[w1,w2,w3,b1,b2] Formins right hand side of constraints
Beq=[3.0; B1; B2]; % Forming RHS of the costraints: w1+w2+w3=3, b1=B1, b2=B2: because they are givens at this point
%starting solution
xi=[1 1 1  B1 B2]; %initial solution is starting with 1 for all
elseif(N==4)
%(1):WLA 
%(Balanced Buffer allocation)
B1=Btot/(N-1);
B2=Btot/(N-1);
B3=Btot/(N-1);
%Optimization Matrix
Aeq=[1 1 1 1  0 0 0 ; 0 0 0 0  1 0 0  ; 0 0 0 0  0 1 0; 0 0 0 0  0 0 1]; %[w1,w2,w3,b1,b2] Formins right hand side of constraints
Beq=[4.0; B1; B2; B3]; % Forming RHS of the costraints: w1+w2+w3=3, b1=B1, b2=B2: because they are givens at this point
%starting solution
xi=[1 1 1 1  B1 B2 B3]; %initial solution is starting with 1 for all
elseif(N==5)
%(1):WLA 
%(Balanced Buffer allocation)
B1=Btot/(N-1);
B2=Btot/(N-1);
B3=Btot/(N-1);
B4=Btot/(N-1);
%Optimization Matrix
Aeq=[1 1 1 1 1  0 0 0 0 ; 0 0 0 0 0  1 0 0 0  ; 0 0 0 0 0  0 1 0 0; 0 0 0 0 0  0 0 1 0 ; 0 0 0 0 0  0 0 0 1]; %[w1,w2,w3,b1,b2] Formins right hand side of constraints
Beq=[5.0; B1; B2; B3; B4]; % Forming RHS of the costraints: w1+w2+w3=3, b1=B1, b2=B2: because they are givens at this point
%starting solution
xi=[1 1 1 1 1  B1 B2 B3 B4]; %initial solution is starting with 1 for all
end

%Objective function
funct=@(x)E_V_TH_fatigue_2(par,x,PH,cm,f,r,additive,weightRUP,Work1N,a);
options = optimoptions('fmincon','Display','iter-detailed','UseParallel',true);
%options = optimoptions('fmincon');
WLAstart=tic;
[x,fval,exitflag,output]  = fmincon(funct,xi,[],[],Aeq, Beq,[],[],[],options); %minimize 

%Report results
Result.N= N;
Result.Btot=Btot;
Result.PH=PH;
Result.cm=cm;
Result.f=f;
Result.r=r;
Result.additive= additive;
Result.weightRUP=weightRUP;
Result.Work1N=Work1N;
Result.a=a; 
Result.par=par;
Result.Exp='WLA';
Result.time=toc(WLAstart);
Result.Evcount=output.funcCount;
Result.allocation=x;
if(par==1)
Result.CT= fval;
Result.VAR=E_V_TH_fatigue_2(2,Result.allocation,PH,cm,f,r,additive,weightRUP,Work1N,a);
else %paramater=2
Result.CT= E_V_TH_fatigue_2(1,Result.allocation,PH,cm,f,r,additive,weightRUP,Work1N,a);
Result.VAR= fval;
end
Result.TH=1/Result.CT;
Result.MeasB= E_V_TH_fatigue_2(par,[1 1 1 B1 B2],PH,cm,f,r,additive,weightRUP,Work1N,a);
result=Result;
end


