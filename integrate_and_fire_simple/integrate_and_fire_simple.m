function[] = integrate_and_fire_simple()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR: Jeremy Manning                 %
% DATE: May 11, 2009                     %
% DESCRIPTION: Simple integrate-and-fire %
%              neuron with basic         %
%              manipulations.            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear all; close all;

E = -70; %mV
c_m = 10; %nF/mm^2
r_m = 1; %M ohm * mm^2
A = 0.025; %mm^2
V_reset = -80; %mV
V_thresh = -55; %mV
V_peak = 40; %mV

dt = 0.1;
t = 1:dt:1000; %ms
I_pulse = 0.5; %nA
startPulse = 250; %ms
endPulse = 750; %ms

%problem 1
run_model(E,c_m,r_m,A,V_reset,V_thresh,V_peak,dt,t,I_pulse,startPulse,endPulse,true);



%problem 2
figure(2);
I_pulse = linspace(0,1,50); %nA
model_frs = zeros(size(I_pulse));
predicted_frs = zeros(size(I_pulse));
for i = 1:length(I_pulse)
    model_frs(i) = run_model(E,c_m,r_m,A,V_reset,V_thresh,V_peak,dt,t,I_pulse(i),startPulse,endPulse,false);
    predicted_frs(i) = predict_fr(E,c_m,r_m,A,V_reset,V_thresh,I_pulse(i));
end
plot(model_frs,predicted_frs,'k.','LineWidth',2);
xlabel('Model FR (Hz)');
ylabel('Predicted FR (Hz)');



%problem 3
fr = 0;
I_pulse = 0; %nA
dPulse = 0.01; %nA
while fr == 0
    I_pulse = I_pulse + dPulse;
    fr = run_model(E,c_m,r_m,A,V_reset,V_thresh,V_peak,dt,t,I_pulse,startPulse,endPulse,false);
end
fprintf('Minimum pulse current that elicits non-zero FR: %0.3f nA\n',I_pulse);

maxFR = run_model(E,c_m,r_m,A,V_reset,V_thresh,V_peak,dt,t,inf,startPulse,endPulse,false);
fprintf('Maximum firing rate: %0.3f Hz\n',maxFR);



%problem 4
figure(4);
pulse_interval = linspace(10,500,20); %ms
I_pulse = logspace(log10(0.1),log10(5),10); %nA
colors = jet(length(I_pulse));
labels = cell(1,length(I_pulse));
for i = 1:length(I_pulse)
    labels{i} = sprintf('%0.3f nA',I_pulse(i));
    frs = zeros(1,length(pulse_interval));
    for j = 1:length(pulse_interval)
        startPulse = (max(t) - pulse_interval(j))/2;
        endPulse = max(t) - startPulse;
        frs(j) = run_model(E,c_m,r_m,A,V_reset,V_thresh,V_peak,dt,t,I_pulse(i),startPulse,endPulse,false);
    end
    
    figure(4);
    hold on;
    plot(pulse_interval,frs,'LineWidth',2,'Color',colors(i,:));
    hold off;
    xlabel('Pulse interval (ms)');
    ylabel('Firing rate (Hz)');
end
legend(labels,'Location','EastOutside');


%problem 5
figure;
%plot firing rate as a function of resting potential
I_pulse = 0.5;
subplot(4,1,1)
E = linspace(-100,-50,50);
frs = zeros(size(E));
for i = 1:length(E)
    frs(i) = run_model(E(i),c_m,r_m,A,V_reset,V_thresh,V_peak,dt,t,I_pulse,startPulse,endPulse,false);
end
plot(E,frs,'k','LineWidth',2);
xlabel('Resting potential (mV)');
ylabel('Firing rate (Hz)');

%plot firing rate as a function of specific capacitance
E = -70;
c_m = linspace(1,20,50);
frs = zeros(size(c_m));
subplot(4,1,2)
for i = 1:length(c_m)
    frs(i) = run_model(E,c_m(i),r_m,A,V_reset,V_thresh,V_peak,dt,t,I_pulse,startPulse,endPulse,false);
end
plot(c_m,frs,'k','LineWidth',2);
xlabel('Specific capacitance (nF/mm^2)');
ylabel('Firing rate (Hz)');

%plot firing rate as a function of specific resistance
c_m = 10;
r_m = linspace(0.01,20,50);
frs = zeros(size(r_m));
subplot(4,1,3)
for i = 1:length(r_m)
    frs(i) = run_model(E,c_m,r_m(i),A,V_reset,V_thresh,V_peak,dt,t,I_pulse,startPulse,endPulse,false);
end
plot(r_m,frs,'k','LineWidth',2);
xlabel('Specific resistance (M\Omega \cdot mm^2)');
ylabel('Firing rate (Hz)');

%plot firing rate as a function of surface area
r_m = 1;
A = linspace(0.01,1,50);
frs = zeros(size(A));
subplot(4,1,4)
for i = 1:length(A)
    frs(i) = run_model(E,c_m,r_m,A(i),V_reset,V_thresh,V_peak,dt,t,I_pulse,startPulse,endPulse,false);
end
plot(A,frs,'k','LineWidth',2);
xlabel('Surface area (mm^2)');
ylabel('Firing rate (Hz)');


function[fr] = run_model(E,c_m,r_m,A,V_reset,V_thresh,V_peak,dt,t,I_pulse,startPulse,endPulse,plotIt)
I_ext = zeros(size(t)); %nA
I_ext((t >= startPulse) & (t <= endPulse)) = I_pulse;
V_m = zeros(size(t)); %mV
V_m(1) = E;
n_spikes = 0;
for i = 2:length(t)
    if V_m(i-1) > V_thresh
        V_m(i-1) = V_peak;
        V_m(i) = V_reset;
        n_spikes = n_spikes + 1;
    else
        dV = ((E - V_m(i-1) + (r_m/A)*I_ext(i))/(c_m*r_m))*dt;
        V_m(i) = V_m(i-1) + dV;
    end        
end
fr = 1000*n_spikes/(endPulse - startPulse); %Hz

if plotIt
    figure;
    subplot(2,1,1)
    plot(t,V_m,'k','LineWidth',2);
    ylabel('Membrane voltage (mV)');

    subplot(2,1,2)
    plot(t,I_ext,'k','LineWidth',2);
    xlabel('Time (ms)');
    ylabel('I_{ext} (nA)');
end

function[fr] = predict_fr(E,c_m,r_m,A,V_reset,V_thresh,I_pulse)
tau = c_m*r_m;
R_m = r_m/A;

if R_m*I_pulse + E > V_thresh
    fr = 1000/(tau*log((R_m*I_pulse + E - V_reset)/(R_m*I_pulse + E - V_thresh))); %Hz
else
    fr = 0;
end