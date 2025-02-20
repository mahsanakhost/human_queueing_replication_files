function result=SIM(N,Btot,par,PH,cm,f,r,additive,weightRUP,Work1N,a)
% clear
% N=3;
% Btot=4;
% par=2;
% %Erlang phases
% PH=1;
% %Cmax
% cm=1; %max 1 cycle of speedup: e.g. when c=0 only
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Behavioral parameters
% f=0.2; 
% r=2.00; %reaction 0:linear, OTHERWISE: extreme!
% additive=true; %%when additive not true
% weightRUP=0.5;
% Work1N=0; %0: worker 1 and N are subject to weightRUP as well 1: weight =1 for the adjacent buffer
% a=0; %0: linear fatigue, a>0 expo qick decrease a<0 saturation (less benefit from rest as accummulated fatigue approaches zero)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Objective function
funct=@(x)E_V_TH_fatigue_2(par,x,PH,cm,f,r,additive,weightRUP,Work1N,a);

SIMstart=tic;
%%Enumerations
if(N==3)
i=0;
for B1=1:Btot-1 %The size of the first buffer from 1 to total#-1
B2=Btot-B1; %The size of the second buffer: what remains from B1
i=i+1;
%Matrix
%Optimization Matrix
Aeq=[1 1 1  0 0  ; 0 0 0  1 0  ; 0 0 0  0 1]; %[w1,w2,w3,b1,b2] Formins right hand side of constraints
Beq=[3.0; B1; B2]; % Forming RHS of the costraints: w1+w2+w3=3, b1=B1, b2=B2: because they are givens at this point
%starting solution
xi=[1 1 1  B1 B2]; %initial solution is starting with 1 for all
options = optimoptions('fmincon','Display','iter-detailed','UseParallel',true);
%options = optimoptions('fmincon');
[x,fval,exitflag,output]  = fmincon(funct,xi,[],[],Aeq, Beq,[],[],[],options); %minimize 
BufferResult(i).allocation=x;
BufferResult(i).objective=fval;
BufferResult(i).Evcount=output.funcCount;
Candidate_OBJ(i)=BufferResult(i).objective;
end
elseif (N==4)
    %%%% N=4 %%%%%
i=0;
for B1=1:Btot-2 %The size of the first buffer from 1 to total#-1
for B2=1:Btot-B1-1 %The size of the second buffer: what remains from B1 and leave 1 for the third
B3=Btot-B1-B2; %% All to make up to 6
i=i+1;
%Optimization Matrix
Aeq=[1 1 1 1  0 0 0 ; 0 0 0 0  1 0 0  ; 0 0 0 0  0 1 0; 0 0 0 0  0 0 1]; %[w1,w2,w3,b1,b2] Formins right hand side of constraints
Beq=[4.0; B1; B2; B3]; % Forming RHS of the costraints: w1+w2+w3=3, b1=B1, b2=B2: because they are givens at this point
%starting solution
xi=[1 1 1 1  B1 B2 B3]; %initial solution is starting with 1 for all
options = optimoptions('fmincon','Display','iter-detailed','UseParallel',true);
%options = optimoptions('fmincon');
[x,fval,exitflag,output]  = fmincon(funct,xi,[],[],Aeq, Beq,[],[],[],options); %minimize 
BufferResult(i).allocation=x;
BufferResult(i).objective=fval;
BufferResult(i).Evcount=output.funcCount;
Candidate_OBJ(i)=BufferResult(i).objective;
if(B1==B2 && B2==B3)
Balanced= BufferResult(i).objective;
end
end
end
elseif (N==5)
    %%%% N=5 %%%%%
i=0;
for B1=1:Btot-3 %The size of the first buffer from 1 to total#-1
for B2=1:Btot-B1-2 %The size of the second buffer: what remains from B1 and leave 2 for the third&4th
for B3=1:Btot-B1-B2-1 %The size of the second buffer: what remains from B1 and leave 1 for the 4th
B4=Btot-B1-B2-B3; %% All to make up to 6
i=i+1;
%Optimization Matrix
Aeq=[1 1 1 1 1  0 0 0 0 ; 0 0 0 0 0  1 0 0 0  ; 0 0 0 0 0  0 1 0 0; 0 0 0 0 0  0 0 1 0 ; 0 0 0 0 0  0 0 0 1 ]; %[w1,w2,w3,b1,b2] Formins right hand side of constraints
Beq=[5.0; B1; B2; B3; B4]; % Forming RHS of the costraints: w1+w2+w3=3, b1=B1, b2=B2: because they are givens at this point
%starting solution
xi=[1 1 1 1 1  B1 B2 B3 B4]; %initial solution is starting with 1 for all
options = optimoptions('fmincon','Display','iter-detailed','UseParallel',true);
%options = optimoptions('fmincon');
[x,fval,exitflag,output]  = fmincon(funct,xi,[],[],Aeq, Beq,[],[],[],options); %minimize 
BufferResult(i).allocation=x;
BufferResult(i).objective=fval;
BufferResult(i).Evcount=output.funcCount;
Candidate_OBJ(i)=BufferResult(i).objective;
if(B1==B2 && B2==B3 && B3==B4)
Balanced= BufferResult(i).objective;
end
end
end
end
end

%Pick the minimum
Sonuc=min(Candidate_OBJ);
%Sum number of iterations
numit=0;
for j=1:i
    numit=numit+BufferResult(j).Evcount;
end


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
Result.Exp='SIM';
Result.time=toc(SIMstart);
Result.Evcount=numit;
Result.allocation=BufferResult(find(cellfun(@(x)isequal(x,Sonuc),{BufferResult.objective}))).allocation;
if(par==1)
Result.CT= Sonuc;
Result.VAR=E_V_TH_fatigue_2(2,Result.allocation,PH,cm,f,r,additive,weightRUP,Work1N,a);
else %paramater=2
Result.CT= E_V_TH_fatigue_2(1,Result.allocation,PH,cm,f,r,additive,weightRUP,Work1N,a);
Result.VAR= Sonuc;
end
Result.TH=1/Result.CT;
Result.MeasB= E_V_TH_fatigue_2(par,[1 1 1 Btot/2 Btot/2],PH,cm,f,r,additive,weightRUP,Work1N,a);
result=Result;
end