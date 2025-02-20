clear
%for determining the service level
par=1;
PH=1;
cm=1;
f=0.4;
r=0;
additive=true;
weightRUP=0.5;
Work1N=0;
a=0; %fatigue (a=0 means linear fatigue)


count=0;
vq=WLA(3,4,par,PH,cm,f,r,additive,weightRUP,Work1N,a);

%%
N=10;
%t=zeros(3*N+1,3*N+1);
clear t;
for i=1:3*N+1
    for j=1:3*N+1
    w1=(i-1)/N
    w2=(j-1)/N;
    w3=3-w1-w2;
    t(j, i)=E_V_TH_fatigue_2(par,[w1 w2 w3 2 2],PH,cm,f,r,additive,weightRUP,Work1N,a)
    end
end

%%
figure('Name','Expected with speedup and fatigue');
ylabel('Population')
xlabel('Population2')
x=0.0:1/N:3
y=0.0:1/N:3
surf(x,y,t)
%%
E_V_TH_fatigue_2(par,[0.9 1.2 0.9 2 2],PH,cm,f,r,additive,weightRUP,Work1N,a)