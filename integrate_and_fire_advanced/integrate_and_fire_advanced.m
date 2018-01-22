function[] = integrate_and_fire_advanced()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR: Josh Jacobs (w/ help from JRM) %
% DATE: May, 2009                        %
% DESCRIPTION: Simple integrate-and-fire %
%              neuron with basic         %
%              manipulations.            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;


dt = 0.1;
t = 1:dt:1000; %ms

%problem 1
pulse=.4*(t>=250 & t<=750);
dG_sra=.03; t_sra=200; E_sra=-70; %parameters for spike-rate adaptation

run_model_sra(dt,t,pulse,dG_sra,t_sra,E_sra,true);

%problem 2
figure
pulse=3*(t>=250 & t<=750);
run_model_refrac(dt,t,pulse,0,true);

figure
pulse=3*(t>=250 & t<=750);
run_model_refrac(dt,t,pulse,5,true);


figure
amps=[0:.1:20];
for i=1:length(amps)
  pulse=amps(i)*(t>=250 & t<=750);
  fr(i)=2*run_model_refrac(dt,t,pulse,5,false);
end
plot(amps,fr);
xlabel('Input current amplitude (nA)');
ylabel('Mean firing rate (Hz)');


%problem 3
%pulse=.4*(t>=250 & t<=750);
t = 1:dt:100; %ms
pulse=10*(t>=50 & t<=70);
dG_sra=0; t_sra=10; E_sra=-70; %parameters for spike-rate adaptation
run_model_sra(dt,t,pulse,dG_sra,t_sra,E_sra,true);

dG_sra=50; t_sra=5; E_sra=-70; %parameters for spike-rate adaptation
run_model_sra(dt,t,pulse,dG_sra,t_sra,E_sra,true);

%problem 4
t = 1:dt:1000; %ms
dG_sra=3; t_sra=50; E_sra=-70; %parameters for spike-rate adaptation
pulse=.5*(.5+.5*sin(10*2*pi*t./1000)).*(t>=250 & t<=750);

run_model_sra(dt,t,pulse,dG_sra,t_sra,E_sra,true);
freqs=[1:50];
for i=1:length(freqs)
  pulse=.5*(.5+.5*sin(freqs(i)*2*pi*t./1000)).*(t>=250 & t<=750);
    n(i)=run_model_sra(dt,t,pulse,dG_sra,t_sra,E_sra,false);
end

figure;
plot(freqs,n)
xlabel('Frequency of oscillating input current (Hz)');
ylabel('Output Firing Rate (Hz)');


pulse=.5*(.5+.5*sin(4*2*pi*t./1000)).*(t>=250 & t<=750);
run_model(dt,t,pulse,true);

keyboard

function n_spikes = run_model_sra(dt,t,I_ext,dG_sra,t_sra,E_sra,plotIt)
%main parameters
E = -70; %mV
c_m = 10; %nF/mm^2
r_m = 1; %M ohm * mm^2
A = 0.025; %mm^2
V_reset = -80; %mV
V_thresh = -55; %mV
V_peak = 40; %mV

G_sra=0;

V_m = zeros(size(t)); %mV
V_m(1) = E;
n_spikes = 0;
for i = 2:length(t)
    if V_m(i-1) > V_thresh
        V_m(i-1) = V_peak;
        V_m(i) = V_reset;
        G_sra(i)=G_sra(i-1)+dG_sra;
        n_spikes = n_spikes + 1;
    else
        dV = ((E - V_m(i-1) - G_sra(i-1)*(V_m(i-1)-E_sra)+(r_m/A)*I_ext(i))/(c_m*r_m))*dt;
        G_sra(i)=G_sra(i-1)-(G_sra(i-1)/t_sra)*dt;
        V_m(i) = V_m(i-1) + dV;

    end        
end


if plotIt
    figure;
    subplot(3,1,1)
    plot(t,V_m,'k','LineWidth',2);
    ylabel('Membrane voltage (mV)');
%    title(sprintf('%d spikes. dG_{sra} = %f',n_spikes,dG_sra));
    title(sprintf('%d spikes',n_spikes));
    
    
    subplot(3,1,2)
    plot(t,I_ext,'k','LineWidth',2);
    xlabel('Time (ms)');
    ylabel('I_{ext} (nA)');

    subplot(3,1,3)
    plot(t,G_sra,'k','LineWidth',2);
    xlabel('Time (ms)');
    ylabel('G_{sra} (nA)');


end


function n_spikes = run_model(dt,t,I_ext,plotIt)
%main parameters
E = -70; %mV
c_m = 10; %nF/mm^2
r_m = 1; %M ohm * mm^2
A = 0.025; %mm^2
V_reset = -80; %mV
V_thresh = -55; %mV
V_peak = 40; %mV


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



function n_spikes = run_model_refrac(dt,t,I_ext,refrac,plotIt)
%main parameters
E = -70; %mV
c_m = 10; %nF/mm^2
r_m = 1; %M ohm * mm^2
A = 0.025; %mm^2
V_reset = -80; %mV
V_thresh = -55; %mV
V_peak = 40; %mV
last_spike_time=-inf;

V_m = zeros(size(t)); %mV
V_m(1) = E;
n_spikes = 0;
for i = 2:length(t)
    if V_m(i-1) > V_thresh && (t(i)-last_spike_time)>refrac
        V_m(i-1) = V_peak;
        V_m(i) = V_reset;
        n_spikes = n_spikes + 1;
        last_spike_time=t(i);
    else
        dV = ((E - V_m(i-1) + (r_m/A)*I_ext(i))/(c_m*r_m))*dt;
        V_m(i) = V_m(i-1) + dV;
    end        
end

if plotIt
    figure;
    subplot(2,1,1)
    plot(t,V_m,'k','LineWidth',2);
    ylabel('Membrane voltage (mV)');
    title(sprintf('%d spikes. refrac = %d',n_spikes,refrac));
    
    subplot(2,1,2)
    plot(t,I_ext,'k','LineWidth',2);
    xlabel('Time (ms)');
    ylabel('I_{ext} (nA)');
end



