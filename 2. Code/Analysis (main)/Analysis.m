function [result1 result2]=Analysis(Result,count,N,Btot,PH,cm,F,r,additive,weightRUP,Work1N,a)
% 
%clear
%  N_last=0;
%  Btot_last=0;
%  par_last=0;
%  PH_last=0;
%  Pr_last=0; %%last run problem
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

%% 
F_RANGE=F;
% for par=1:2  %for both measures
% for f= F_RANGE
% count=count+1;
% %(1): Simultaneous allocation
% Result(count)=SIM(N,Btot,par,PH,cm,f,r,additive,weightRUP,Work1N,a);
% %Write to Excel
% T=struct2table(Result);
% s1 = 'Results (N=';
% s2 = int2str(N);
% s3 = ', Btot=';
% s4 = int2str(Btot);
% s5 = ', k=';
% s6 = int2str(PH);
% s7= ').xlsx';
% NameFile=strcat(s1,s2,s3,s4,s5,s6,s7);
% writetable(T,NameFile);
% end
% end

for par=2:2  %only for variability measure
%%check % set f rang
for f= F_RANGE
count=count+1;
%(2):WLA (Balanced Buffer allocation)
Result(count)=WLA(N,Btot,par,PH,cm,f,r,additive,weightRUP,Work1N,a);
%Write to Excel
T=struct2table(Result);
s1 = 'Results (N=';
s2 = int2str(N);
s3 = ', Btot=';
s4 = int2str(Btot);
s5 = ', k=';
s6 = int2str(PH);
s7= ').xlsx';
NameFile=strcat(s1,s2,s3,s4,s5,s6,s7);
writetable(T,NameFile);
end
for f= F_RANGE
count=count+1;
%(3): Buffer allocation
Result(count)=BA(N,Btot,par,PH,cm,f,r,additive,weightRUP,Work1N,a);
%Write to Excel
T=struct2table(Result);
s1 = 'Results (N=';
s2 = int2str(N);
s3 = ', Btot=';
s4 = int2str(Btot);
s5 = ', k=';
s6 = int2str(PH);
s7= ').xlsx';
NameFile=strcat(s1,s2,s3,s4,s5,s6,s7);
writetable(T,NameFile);
end
end

result1=Result;
result2=count;
end