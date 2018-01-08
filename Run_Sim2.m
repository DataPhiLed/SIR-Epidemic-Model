function [t,XX,YY,ZZ] = Run_Sim2(AA,R,BB,CC,X0,Y0,Y0s,N0, timestep, Tmax)

% default initial values (originals listed in comments)
if nargin == 0
   AA=1;                    % rate for Susceptibles + superspreaders(1)
   R=5;                    % NEW INFECTION RATE for Superspreaders 

   BB=0.1;                  % Recovery rate for Infected (1/10)
   CC=5e-4;                 % Birth rate = death rate (5e-4)
   N0=5000;                 % Initial population size (5000)
   Y0=ceil(CC*N0/BB);       % Initial Infected 
   Y0s=ceil(0.1*CC*N0/BB);  % NEW Initial Infected Superspreaders = 0;
                            % 10% of the infected are superspreaders
   X0=floor(BB*N0/AA);      % Initial Susceptible Population (BB*N0/AA)
   timestep=1;              % timestep is days
   Tmax=5*365;              % Total run time of simulation (2*365 days)
end

% Initial recovered population Z0
% = Initial total population - Initial Susceptibles - Initial Infectious 
Z0=N0-X0-Y0-Y0s; 

% after that, run A42 with starting values to evolve population
[t, pop]=Loop_Counter2([0 Tmax],[X0 Y0 Y0s Z0],[AA R BB CC N0 timestep]);
T=t/365; 
XX=pop(:,1); % susceptible population
YY=pop(:,2)+pop(:,3); % infectious population = average+superspreaders
ZZ=pop(:,4); % recovered population

subplot(3,1,1)
h=plot(T,XX,'-g');
xlabel 'Time in years'
ylabel 'Susceptible'

subplot(3,1,2)
h=plot(T,YY,'-r');
xlabel 'Time in years'
ylabel 'Infectious'

subplot(3,1,3)
h=plot(T,ZZ,'-k');
xlabel 'Time in years'
ylabel 'Recovered'