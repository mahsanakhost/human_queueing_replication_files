function  [v]  = MarkovSolve2(P, numOrigstate)
%for Continuous Time Markov Chains

A1=P';
for i=1:numOrigstate
    for j=1:numOrigstate
        A2(i,j)=A1(i,j);
    end
end
for j=1:numOrigstate
    A2(numOrigstate+1,j)=1;
    B(j)=0;
end
B(numOrigstate+1)=1;
try
v=linsolve(A2,B');
catch ME
end
end
