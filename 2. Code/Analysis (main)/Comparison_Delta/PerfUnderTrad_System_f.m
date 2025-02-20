%Traditional in the sense of modeling a state independent behavior for
%optimization
%The system itself moves state-dependent

clear
tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%System related paramteres
%Objective
maxNumCompThreads(4) 
%%
Parset=[3	4	1	0	0	200	1	0.5	0	0	1	101	1.044140976	0.911718013	1.044141012	2	2	;
3	4	1	0	0	200	1	0.5	0	0	2	102	1.087657943	0.933278674	0.979063383	3	1	;
3	4	1	0	0	200	1	0.5	0	0	2	103	1.027205234	0.943388507	1.029406259	2	2	;
3	4	1	0	0	200	1	0.5	0	0	2	104	1	1	1	2	2	;
3	4	2	1	0	200	1	0.5	0	0	1	101	1.025689637	0.948620787	1.025689577	2	2	;
3	4	2	1	0	200	1	0.5	0	0	2	102	0.994212013	0.932414454	1.073373533	2	2	;
3	4	2	1	0	200	1	0.5	0	0	2	103	0.994212013	0.932414454	1.073373533	2	2	;
3	4	2	1	0	200	1	0.5	0	0	2	104	1	1	1	2	2	;
3	6	1	1	0	200	1	0.5	0	0	1	101	1.034739119	0.930521829	1.034739052	3	3	;
3	6	1	1	0	200	1	0.5	0	0	2	102	1.062480414	0.945535871	0.991983715	4	2	;
3	6	1	1	0	200	1	0.5	0	0	2	103	1.023464524	0.951052411	1.025483065	3	3	;
3	6	1	1	0	200	1	0.5	0	0	2	104	1	1	1	3	3	;
3	8	1	1	0	200	1	0.5	0	0	1	101	1.028441431	0.943116963	1.028441606	4	4	;
3	8	1	1	0	200	1	0.5	0	0	2	102	1.04767271	0.954105088	0.998222202	5	3	;
3	8	1	1	0	200	1	0.5	0	0	2	103	1.020413827	0.957422294	1.022163879	4	4	;
3	8	1	1	0	200	1	0.5	0	0	2	104	1	1	1	4	4	;
3	10	1	1	0	200	1	0.5	0	0	1	101	1.023981958	0.952036134	1.023981908	5	5	;
3	10	1	1	0	200	1	0.5	0	0	2	102	1.038110981	0.960399502	1.001489517	6	4	;
3	10	1	1	0	200	1	0.5	0	0	2	103	1.017982037	0.962539408	1.019478555	5	5	;
3	10	1	1	0	200	1	0.5	0	0	2	104	1	1	1	5	5	;
3	4	3	1	0	200	1	0.5	0	0	1	101	1.018066691	0.96386641	1.018066899	2	2	;
3	4	3	1	0	200	1	0.5	0	0	2	102	0.986898855	0.931101138	1.082000007	2	2	;
3	4	3	0	0	200	1	0.5	0	0	2	103	0.98689889	0.931101093	1.082000017	2	2	;
3	4	3	0	0	200	1	0.5	0	0	2	104	1	1	1	2	2	];
%%
%%Actual behavioral seting
cm=1;
Sett=24;
%%all others as read from above r=200 or 0 ect.
newrun=0;
for i=1:Sett
for f= [0 0.4]
%considered parameter setting
PH= Parset(i, 3) ;
r= Parset(i, 6) ;
if Parset(i, 7)==1
additive= true;
else
additive= false;   
end
weightRUP= Parset(i, 8) ;
Work1N= Parset(i, 9) ;
a= Parset(i, 10) ;
par= Parset(i, 11) ;
x=Parset(i, 13:17) ;
%%%%%%%%%%%%%%%%%%%%%
newrun=newrun+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
AllVar_System_f(newrun).cm=cm;
AllVar_System_f(newrun).f=f;
AllVar_System_f(newrun).r=r;
AllVar_System_f(newrun).par=par;
AllVar_System_f(newrun).meas=E_V_TH_fatigue_2(par,x,PH,cm,f,r,additive,weightRUP,Work1N,a);
save('AllVar_System_f', 'AllVar_System_f')
end
%%
end
%%%AGain for r=0 case
for i=1:Sett
for f= 0.4 %% ONLY!!
%considered parameter setting
PH= Parset(i, 3) ;
r= 0; %% GIVEN!!!
if Parset(i, 7)==1
additive= true;
else
additive= false;   
end
weightRUP= Parset(i, 8) ;
Work1N= Parset(i, 9) ;
a= Parset(i, 10) ;
par= Parset(i, 11) ;
x=Parset(i, 13:17) ;
%%%%%%%%%%%%%%%%%%%%%%
newrun=newrun+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
AllVar_System_f(newrun).cm=cm;
AllVar_System_f(newrun).f=f;
AllVar_System_f(newrun).r=r;
AllVar_System_f(newrun).par=par;
AllVar_System_f(newrun).meas=E_V_TH_fatigue_2(par,x,PH,cm,f,r,additive,weightRUP,Work1N,a);
save('AllVar_System_f', 'AllVar_System_f')
end
%%
end
%end