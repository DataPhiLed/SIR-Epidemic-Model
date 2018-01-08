% This function describes the master equation for updating
% 'old' is a vector from A42 = [x,y,z]
% the vector is modified by a poisson process according to six rates  
% then it gets returned as 'new_state' 

function [new_state]=ME_Update2(old, Parameters)

AA=Parameters(1);               % Rate susceptibles become infected
R = Parameters(2)
BB=Parameters(3);               % Rate Infecteds become recovered
CC=Parameters(4);               % Birth and Death rate
N=Parameters(5);                % Total population
timestep=Parameters(6);         % timestep
X=old(1); Y=old(2); Ys=old(3); Z=old(4);  % modified

%--------------------------------------------------------------------
% The events that modify the population come next
% Each event is followed by a vector modifying the population
% e.g. rate(2) is infection and the modifier is [-1 +1 0]
% b/c infection means you lose one susceptible and gain one infected
%---------------------------------------------------------------------

PopRate(1) = CC*N;              % Birth of a new infant             
RateOfChange(1,:)=[+1 0 0 0];   % New arrivals are always susceptible

PopRate(2) = (AA)*X*(Y-Ys)/N +R*X*Ys/N; % Infection of Susceptible
RateOfChange(2,:)=[-1 +1 0 0];  %(modified)

PopRate(3) = BB*(Y-Ys);         % Recovery of an average infected
RateOfChange(3,:)=[0 -1 0 +1];  % (modified)

PopRate(4) = CC*X;              % Death of a susceptible
RateOfChange(4,:)=[-1 0 0 0];

PopRate(5) = CC*(Y-Ys);         % Death of average infected
RateOfChange(5,:)=[0 -1 0 0];   % (modified)    

PopRate(6) = CC*Z;              % Death of a recovered
RateOfChange(6,:)=[0 0 0 -1];

PopRate(7) = AA*X*(Y-Ys)/N +R*X*Ys/N;         % Infection of a super spreader (NEW)
RateOfChange(7,:)=[-1 0 +1 0];

PopRate(8) = BB*(Ys);           % Recovery of a super spreader (NEW)
RateOfChange(8,:)=[0 0 -1 +1];

PopRate(9) = CC*(Ys);           % Death of a super spreader (NEW)
RateOfChange(9,:)=[0 0 -1 0];

new_state=old;

for i=1:9
    Num=poissrnd(PopRate(i)*timestep);
    Use=min([Num new_state(find(RateOfChange(i,:)<0))]);
    new_state=new_state+RateOfChange(i,:)*Use;
    
end