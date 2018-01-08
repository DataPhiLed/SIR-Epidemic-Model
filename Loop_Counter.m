% this function evolves an initial population from A41 using a master
% equation
% Time is a vector containing the start time (0) and end time (Tmax)
% Initial is a vector containing X0, Y0, and Z0 initial populations
% Parameters is a vector containing AA, BB, CC, N0, and the timestep

function [T,P]=Loop_Counter(Time,Initial,Parameters)

Xstart=Initial(1);         % set Xstart = X0 = initial Susceptibles 
Ystart=Initial(2);         % set Ystart = Y0 = initial Infected
Zstart=Initial(3);         % set Zstart = Z0 = initial Recovered
timestep=Parameters(5);    % set the timestep

T=[0:timestep:Time(2)]; P(1,:)=[Xstart Ystart Zstart];
old=[Xstart Ystart Zstart];

loopcount=1;

% after setting everything up, A42 just runs the loop counter. 
% at each iteration it updates Ppopulation vector P = (X,Y,Z) 
% according to the master equation described in A43.

while (T(loopcount)<Time(2))  
    [new]=ME_Update(old,Parameters);
    loopcount=loopcount+1;
    P(loopcount,:)=new;
    old=new;
end