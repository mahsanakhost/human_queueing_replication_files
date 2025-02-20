%function [result1 result2]=Analysis_Large(Result,count,N,Btot,PH,cm,r,additive,weightRUP,Work1N,a)
% 
clear

maxNumCompThreads(56) 

for cm= [1]
for N=[5 4]
%%System related paramteres
%Objective
%N=4; %%%N=4 or 5
Btot=2*(N-1);
%Erlang phases
PH=1; %BASE: 1
%%Basic setting is default --> hold unless otherwise stated
%Cmax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Behavioral parameters
% f varied in each in {0, 0.4} 
r=200.00; %%BASE: 200
additive=true; %%BASE: true
weightRUP=0.5; %BASE: 0.5
Work1N=0; %BASE: 0
a=0; %%BASE: 0

count=0;
F_RANGE=[0 0.4];

par=1;  %expected measure
for f= F_RANGE
count=count+1;
%(1):WLA (Balanced Buffer allocation)
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
par=2;  %variability measure
for f= F_RANGE
count=count+1;
%(3): SIM allocation
Result(count)=SIM(N,Btot,par,PH,cm,f,r,additive,weightRUP,Work1N,a);

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
%(2): Buffer allocation
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
end
%%

%result1=Result;
%result2=count;
%end