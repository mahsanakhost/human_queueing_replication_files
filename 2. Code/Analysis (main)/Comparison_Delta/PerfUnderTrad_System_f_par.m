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
3	4	1	0	0	200	1	0.5	0	0	2	102	1.044140976	0.911718013	1.044141012	2	2	;
3	4	1	0	0	200	1	0.5	0	0	2	103	1.044140976	0.911718013	1.044141012	2	2	;
3	4	1	0	0	200	1	0.5	0	0	2	104	1	1	1	2	2	;
3	4	2	1	0	200	1	0.5	0	0	1	101	1.025689637	0.948620787	1.025689577	2	2	;
3	4	2	1	0	200	1	0.5	0	0	2	102	1.025689637	0.948620787	1.025689577	2	2	;
3	4	2	1	0	200	1	0.5	0	0	2	103	1.025689637	0.948620787	1.025689577	2	2	;
3	4	2	1	0	200	1	0.5	0	0	2	104	1	1	1	2	2	;
3	6	1	1	0	200	1	0.5	0	0	1	101	1.034739119	0.930521829	1.034739052	3	3	;
3	6	1	1	0	200	1	0.5	0	0	2	102	1.034739119	0.930521829	1.034739052	3	3	;
3	6	1	1	0	200	1	0.5	0	0	2	103	1.034739119	0.930521829	1.034739052	3	3	;
3	6	1	1	0	200	1	0.5	0	0	2	104	1	1	1	3	3	;
3	8	1	1	0	200	1	0.5	0	0	1	101	1.028441431	0.943116963	1.028441606	4	4	;
3	8	1	1	0	200	1	0.5	0	0	2	102	1.028441431	0.943116963	1.028441606	4	4	;
3	8	1	1	0	200	1	0.5	0	0	2	103	1.028441431	0.943116963	1.028441606	4	4	;
3	8	1	1	0	200	1	0.5	0	0	2	104	1	1	1	4	4	;
3	10	1	1	0	200	1	0.5	0	0	1	101	1.023981958	0.952036134	1.023981908	5	5	;
3	10	1	1	0	200	1	0.5	0	0	2	102	1.023981958	0.952036134	1.023981908	5	5	;
3	10	1	1	0	200	1	0.5	0	0	2	103	1.023981958	0.952036134	1.023981908	5	5	;
3	10	1	1	0	200	1	0.5	0	0	2	104	1	1	1	5	5	;
3	4	3	1	0	200	1	0.5	0	0	1	101	1.018066691	0.96386641	1.018066899	2	2	;
3	4	3	1	0	200	1	0.5	0	0	2	102	1.018066691	0.96386641	1.018066899	2	2	;
3	4	3	0	0	200	1	0.5	0	0	2	103	1.018066691	0.96386641	1.018066899	2	2	;
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
AllVar_System_f_par(newrun).cm=cm;
AllVar_System_f_par(newrun).f=f;
AllVar_System_f_par(newrun).r=r;
AllVar_System_f_par(newrun).par=par;
AllVar_System_f_par(newrun).meas=E_V_TH_fatigue_2(par,x,PH,cm,f,r,additive,weightRUP,Work1N,a);
save('AllVar_System_f_par', 'AllVar_System_f_par')
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
AllVar_System_f_par(newrun).cm=cm;
AllVar_System_f_par(newrun).f=f;
AllVar_System_f_par(newrun).r=r;
AllVar_System_f_par(newrun).par=par;
AllVar_System_f_par(newrun).meas=E_V_TH_fatigue_2(par,x,PH,cm,f,r,additive,weightRUP,Work1N,a);
save('AllVar_System_f_par', 'AllVar_System_f_par')
end
%%
end
%end