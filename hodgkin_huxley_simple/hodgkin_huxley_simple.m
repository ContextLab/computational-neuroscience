function[] = hodgkin_huxley_simple()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR: Jeremy Manning                 %
% DATE: May 21, 2009                     %
% DESCRIPTION: Hodgkin-Huxley (1952)     %
%              model with some           %
%              manipulations             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

dt = 0.1; %ms
t = 0:dt:15; %ms

I_pulse = 5; %nA/mm^2
startPulse = 5; %ms
endPulse = 8; %ms

%problem 1
[t,V,ms,hs,ns] = sim_HH(t,dt,startPulse,endPulse,I_pulse);
plot_vars(1,t,V,ms,hs,ns);


%problem 3
[t,V,ms,hs,ns] = sim_HH(t,dt,startPulse,endPulse,I_pulse,[],0);
plot_vars(3,t,V,ms,hs,ns);

%problem 4
[t,V,ms,hs,ns] = sim_HH(t,dt,startPulse,endPulse,I_pulse,0);
plot_vars(4,t,V,ms,hs,ns);

%problem 5
t = 0:dt:1000;
startPulse = 250;
endPulse = 750;
I_pulse = linspace(0.01,3,25);
frs = zeros(size(I_pulse));
for i = 1:length(I_pulse)
    [t,V,ms,hs,ns,frs(i)] = sim_HH(t,dt,startPulse,endPulse,I_pulse(i));
    plot_vars(5,t,V,ms,hs,ns);
    drawnow;
end
figure(5); clf;
plot(I_pulse,frs,'k','LineWidth',2);
xlabel('I_{ext} (nA)');
ylabel('Firing rate (Hz)');






function[t,V,ms,hs,ns,FR] = sim_HH(t,dt,startPulse,endPulse,I_pulse,PK,PNa)
gL = 0.003; %mS/mm^2
gK = 0.36; %mS/mm^2
gNa = 1.2; %mS/mm^2
EL = -54.387; %mV
EK = -77; %mV
ENa = 50; %mV
E = -65; %mV
c_m = 0.1; %nF/mm^2

n0 = 0.318;%ms^-1
m0 = 0.053;%ms^-1
h0 = 0.596;%ms^-1

I_ext = zeros(size(t)); %nA/mm^2
I_ext((t >= startPulse) & (t <= endPulse)) = I_pulse;
pulse_duration = endPulse - startPulse; %ms

ap_thresh = -50; %mV (approximate; used to detect spikes)
ap_reset = -55; %mV

if exist('PNa','var') && ~isempty(PNa)
    fix_PNa = true;
else
    fix_PNa = false;
end

if exist('PK','var') && ~isempty(PK)
    fix_PK = true;
else
    fix_PK = false;
end

spikes = 0;
fired_flag = false;

V = E*ones(size(t));

ns = zeros(size(t));
ms = zeros(size(t));
hs = zeros(size(t));

if ~fix_PK
    ns(1) = n0;
end
if ~fix_PNa
    ms(1) = m0;
    hs(1) = h0;
end

for i = 2:length(t)
    if ~fix_PK
        ns(i) = ns(i-1) + dn(ns(i-1),V(i-1),dt);
        PK = ns(i)^4;
    end
    next_gK = gK*PK;
    
    if ~fix_PNa
        ms(i) = ms(i-1) + dm(ms(i-1),V(i-1),dt);
        hs(i) = hs(i-1) + dh(hs(i-1),V(i-1),dt);
        PNa = (ms(i)^3)*hs(i);
    end
    next_gNa = gNa*PNa;
    
    i_m = (gL*(V(i-1) - EL)) + next_gNa*(V(i-1) - ENa) + next_gK*(V(i-1) - EK);
    V(i) = V(i-1) + dt*(-i_m + I_ext(i))/c_m;
    
    if (V(i) >= ap_thresh) && (V(i) > V(i-1)) && ~fired_flag
        spikes = spikes+1;
        fired_flag = true;
    elseif (V(i) <= ap_reset) && (V(i) < V(i-1))
        fired_flag = false;
    end   
end
FR = 1000*spikes/pulse_duration; %Hz



%plot t, V, ms, hs, and ns in a single plot
function[] = plot_vars(n,t,V,ms,hs,ns)
figure(n);
subplot(4,1,1)
plot(t,V,'k','LineWidth',2);
ylabel('V (mV)');
axis tight;


subplot(4,1,2)
plot(t,ms,'k','LineWidth',2);
ylabel('m');

subplot(4,1,3)
plot(t,hs,'k','LineWidth',2);
ylabel('h');

subplot(4,1,4)
plot(t,ns,'k','LineWidth',2);
ylabel('n');
xlabel('Time (ms)');







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