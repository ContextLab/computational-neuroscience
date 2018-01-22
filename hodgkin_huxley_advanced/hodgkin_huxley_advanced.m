function[] = hodgkin_huxley_advanced()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR: Jeremy Manning                 %
% DATE: May 22, 2009                     %
% DESCRIPTION: Stochastic ion channels   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all;

%problem 1
figure(1)

set_a_n = a_n(10); %1/ms
set_B_n = B_n(10); %1/ms

dt = 0.01; %ms
t = 0:dt:20; %ms

subplot(3,1,1);
plot(t,simulate_K_channels(1,set_a_n,set_B_n,t,dt),'k','LineWidth',2);
ylabel('Current (pA)');
title('N = 1');

subplot(3,1,2);
plot(t,simulate_K_channels(10,set_a_n,set_B_n,t,dt),'k','LineWidth',2);
ylabel('Current (pA)');
title('N = 10');

subplot(3,1,3);
plot(t,simulate_K_channels(100,set_a_n,set_B_n,t,dt),'k','LineWidth',2);
xlabel('Time (ms)');
ylabel('Current (pA)');
title('N = 100');


%problem 2
figure(2);
N = 1000; %channels
V = 10; %mV
hold on;
plot(t,simulate_K_channels(N,set_a_n,set_B_n,t,dt),'k','LineWidth',2);
plot(t,HH_K_channels(N,0.318,V,t,dt),'r--','LineWidth',2);
xlabel('Time (ms)');
ylabel('Current (pA)')


%problem 3
figure(3)
set_a_m = a_m(10);
set_a_h = a_h(10);
set_B_m = B_m(10);

subplot(3,1,1)
plot(t,-simulate_Na_channels(1,set_a_m,set_a_h,set_B_m,t,dt),'k','LineWidth',2);
ylabel('Current (pA)');
title('N = 1');

subplot(3,1,2)
plot(t,-simulate_Na_channels(10,set_a_m,set_a_h,set_B_m,t,dt),'k','LineWidth',2);
ylabel('Current (pA)');
title('N = 10');

subplot(3,1,3)
plot(t,-simulate_Na_channels(100,set_a_m,set_a_h,set_B_m,t,dt),'k','LineWidth',2);
ylabel('Current (pA)');
xlabel('Time (ms)');
title('N = 100');



%problem 4
figure(4)
N = 1000;
V = 10; %mV
hold on;
plot(t,-simulate_Na_channels(N,set_a_m,set_a_h,set_B_m,t,dt),'k','LineWidth',2);
plot(t,-HH_Na_channels(N,0.053,0.596,V,t,dt),'r--','LineWidth',2);
hold off;
xlabel('Time (ms)');
ylabel('Current (pA)');



%problem 5
gL = 0.003; %mS/mm^2
gK = 0.36; %mS/mm^2
gNa = 1.2; %mS/mm^2
EL = -54.387; %mV
EK = -77; %mV
ENa = 50; %mV
E = -65; %mV

dt = 0.1; %ms
t = 0:dt:20; %ms

I_pulse = 0.5; %nA
I_ext = zeros(size(t));
startPulse = 5;
endPulse = 8;
I_ext((t >= startPulse) & (t <= endPulse)) = I_pulse;

V = E*ones(size(t));
PK = zeros(size(V));
PNa = zeros(size(V));

N = 1000;
K_states = ones(1,N);
Na_states = ones(1,N);
for i = 2:length(t)
    [PK(i),K_states] = simulate_K_channels(N,a_n(V(i-1)),B_n(V(i-1)),1,dt,K_states);
    PK(i) = PK(i)/N;
    next_gK = gK*PK(i);
    
    [PNa(i),Na_states] = simulate_Na_channels(N,a_m(V(i-1)),a_h(V(i-1)),B_m(V(i-1)),1,dt,Na_states);
    PNa(i) = PNa(i)/N;
    next_gNa = gNa*PNa(i);
   
    V(i) = V(i-1) - (gL*(V(i-1) - EL)) - next_gNa*(V(i-1) - ENa) - next_gK*(V(i-1) - EK) + I_ext(i);
end

figure(5);
subplot(3,1,1)
plot(t,V,'k','LineWidth',2);
ylabel('V (mV)');

subplot(3,1,2)
plot(t,PK,'k','LineWidth',2);
ylabel('P_K');

subplot(3,1,3)
plot(t,PNa,'k','LineWidth',2);
ylabel('P_{Na}');
xlabel('Time (ms)');


function[pK] = HH_K_channels(N,n0,V,t,dt)
pK = zeros(size(t));
n = n0;
for i = 1:length(t)
    n = n+dn(n,V,dt);
    pK(i) = N*n^4;
end


function[n_Kopen,K_states] = simulate_K_channels(N,a_n,B_n,t,dt,K_states)
if ~exist('K_states','var')
    K_states = ones(1,N);
end
n_Kopen = zeros(size(t));
pOpen = [4*a_n 3*a_n 2*a_n 1*a_n 0];
pClose = [0 B_n 2*B_n 3*B_n 4*B_n];
for i = 1:length(t)
    open_chooser = rand(size(K_states)) < (dt*pOpen(K_states));
    K_states(open_chooser) = K_states(open_chooser) + 1;

    close_chooser = rand(size(K_states)) < (dt*pClose(K_states));
    K_states(close_chooser) = K_states(close_chooser) - 1;

    n_Kopen(i) = sum(K_states == 5);
end

function[pNa] = HH_Na_channels(N,m0,h0,V,t,dt)
pNa = zeros(size(t));
m = m0;
h = h0;
for i = 1:length(t)
    m = m+dm(m,V,dt);
    h = h+dh(h,V,dt);
    pNa(i) = N*(m^3)*h;
end

function[n_Naopen,Na_states] = simulate_Na_channels(N,a_m,a_h,B_m,t,dt,Na_states)
if ~exist('Na_states','var')
    Na_states = ones(1,N);
end
n_Naopen = zeros(size(t));
pOpen_subunits = [3*a_m 2*a_m a_m 0 0];
pClose_subunits = [0 B_m 2*B_m 3*B_m 0];

pOpen_gate = [0 0 0 0 a_h];
pClose_gate = [0 0.24 0.4 1.5 0];

for i = 1:length(t)
    %subunits
    open_chooser = rand(size(Na_states)) < (dt*pOpen_subunits(Na_states));
    Na_states(open_chooser) = Na_states(open_chooser) + 1;
    
    close_chooser = rand(size(Na_states)) < (dt*pClose_subunits(Na_states));
    Na_states(close_chooser) = Na_states(close_chooser) - 1;
    
    %inactivation gate
    deinactivation_chooser = rand(size(Na_states)) < (dt*pOpen_gate(Na_states));
    Na_states(deinactivation_chooser) = 3;
    
    inactivation_chooser = rand(size(Na_states)) < (dt*pClose_gate(Na_states));
    Na_states(inactivation_chooser) = 5;
    
    n_Naopen(i) = sum(Na_states == 4);
end



    
function[d] = dn(n,V,dt)
d = ((n_infty(V) - n)/T_n(V))*dt;

function[d] = dm(m,V,dt)
d = ((m_infty(V) - m)/T_m(V))*dt;

function[d] = dh(h,V,dt)
d = ((h_infty(V) - h)/T_h(V))*dt;

function[n] = n_infty(V)
n = a_n(V)/(a_n(V) + B_n(V));

function[m] = m_infty(V)
m = a_m(V)/(a_m(V) + B_m(V));

function[h] = h_infty(V)
h = a_h(V)/(a_h(V) + B_h(V));

function[a] = a_n(V)
a = (0.01*(V+55))/(1 - exp(-.1*(V+55)));

function[a] = a_m(V)
a = (0.1*(V+40))/(1 - exp(-.1*(V+40)));

function[a] = a_h(V)
a = 0.07*exp(-.05*(V+65));

function[B] = B_n(V)
B = 0.125*exp(-0.0125*(V+65));

function[B] = B_m(V)
B = 4*exp(-.0556*(V+65));

function[B] = B_h(V)
B = 1/(1 + exp(-.1*(V+35)));

function[T] = T_n(V)
T = 1/(a_n(V) + B_n(V));

function[T] = T_m(V)
T = 1/(a_m(V) + B_m(V));

function[T] = T_h(V)
T = 1/(a_h(V) + B_h(V));