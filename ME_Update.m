% This function describes the master equation for updating
% 'old' is a vector from A42 = [x,y,z]
% the vector is modified by a poisson process according to six rates  
% then it gets returned as 'new_state' 

function [new_state]=ME_Update(old, Parameters)

AA=Parameters(1);               % Rate susceptibles become infected
BB=Parameters(2);               % Rate Infecteds become recovered
CC=Parameters(3);               % Birth and Death rate
N=Parameters(4);                % Total population
timestep=Parameters(5);         % timestep
X=old(1); Y=old(2); Z=old(3);   % Start by getting all the old values

%--------------------------------------------------------------------
% The six events that modify the population come next
% Each event is followed by a vector modifying the population
% e.g. rate(2) is infection and the modifier is [-1 +1 0]
% b/c infection means you lose one susceptible and gain one infected
%---------------------------------------------------------------------

PopRate(1) = CC*N;              % Birth of a new infant             
RateOfChange(1,:)=[+1 0 0];     % New arrivals are always susceptible

PopRate(2) = AA*X*Y/N;          % Infection of a Susceptible
RateOfChange(2,:)=[-1 +1 0];

PopRate(3) = BB*Y;              % Recovery of an infected
RateOfChange(3,:)=[0 -1 +1];    % NB recovery => no longer susceptible

PopRate(4) = CC*X;              % Death of a susceptible
RateOfChange(4,:)=[-1 0 0];

PopRate(5) = CC*Y;              % Death of an infected
RateOfChange(5,:)=[0 -1 0];

PopRate(6) = CC*Z;              % Death of a recovered
RateOfChange(6,:)=[0 0 -1];

new_state=old;

for i=1:6
    Num=poissrnd(PopRate(i)*timestep);
    Use=min([Num new_state(find(RateOfChange(i,:)<0))]);
    new_state=new_state+RateOfChange(i,:)*Use;
    
end