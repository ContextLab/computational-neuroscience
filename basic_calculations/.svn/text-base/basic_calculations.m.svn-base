%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR: JEREMY MANNING              %
% DATE: May 10, 2009                  %
% DESCRIPTION: Basic neuron equations %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all;

%% PROBLEM 1
%capacitance as a function of surface area
figure;
c_m = 10; %nF/mm^2
A = linspace(0.01,0.1,5); %surface area (mm^2)

plot(A,c_m.*A,'k','LineWidth',2);
xlabel('A (mm^2)')
ylabel('C_m (nF)');
set(get(gca,'XLabel'),'FontSize',20);
set(get(gca,'YLabel'),'FontSize',20);
set(gca,'FontSize',20);
axis tight;

%membrane resistance as a function of surface area
figure;
r_m = 1; %M ohms * mm^2

plot(A,r_m./A,'k','LineWidth',2);
xlabel('A (mm^2)');
ylabel('R_m (M\Omega)');
set(get(gca,'XLabel'),'FontSize',20);
set(get(gca,'YLabel'),'FontSize',20);
set(gca,'FontSize',20);
axis tight;

%% PROBLEM 3
%external electrode current required to hold neuron at set membrane
%potential as a function of set potential and surface area
figure;
V_infinity = -80:5:-50; %mV
E = -70; %mV

colors = jet(length(A));
labels = cell(1,length(A));
for i = 1:length(A)
    labels{i} = sprintf('%0.3f mm^2',A(i));
    I_ext = nan(1,length(V_infinity));
    for j = 1:length(V_infinity)
        I_ext(j) = (V_infinity(j) - E)/(r_m/A(i));
    end
    
    hold on;
    plot(V_infinity,I_ext,'LineWidth',2,'Color',colors(i,:));
    xlabel('V_\infty (mV)');
    ylabel('I_{ext} (nA)');
    set(get(gca,'XLabel'),'FontSize',20);
    set(get(gca,'YLabel'),'FontSize',20);
    set(gca,'FontSize',20);
    hold off;
end
lgnd = legend(labels,'Location','Northwest');
set(lgnd,'FontSize',10);

%% PROBLEM 4 
%time to reach membrane potential of V_target mV as a function of
% V_target > E and surface area.  I_ext = 0.1 nA.  Asume R_m = 40 M Ohms
figure;
I_ext = 8; %nA
V_target = -70:5:-50; %mV
tau_m = c_m*r_m; %ms

for i = 1:length(A)
    R_m = r_m/A(i);
    V_inf = E + R_m*I_ext; %mV
    labels{i} = sprintf('%0.3f mm^2',A(i));
    t = nan(1,length(V_target));
    for j = 1:length(V_target)        
        x = (V_target(j) - V_inf)/(E - V_inf);
        if x > 0
            t(j) = -tau_m*log(x);
        end
    end
    
    hold on;
    plot(V_target,t,'LineWidth',2,'Color',colors(i,:));
    xlabel('V_{target} (mV)');
    ylabel('Time (ms)');
    set(get(gca,'XLabel'),'FontSize',20);
    set(get(gca,'YLabel'),'FontSize',20);
    set(gca,'FontSize',20);
    hold off;
end
lgnd = legend(labels,'Location','Northwest');
set(lgnd,'FontSize',9);

% %% firing rate as a function of surface area and external current
% figure;
% V_reset = -80; %mV
% V_thresh = -55; %mV
% I_ext = 1:10; %nA
% for i = 1:length(A)
%     R_m = r_m/A(i);
%     r_isi = nan(1,length(I_ext));
%     for j = 1:length(I_ext)
%         if (R_m*I_ext(j) + E) < V_thresh
%             r_isi(j) = 0;
%         else
%             r_isi(j) = (tau_m*log((R_m*I_ext(j) + E - V_reset)/(R_m*I_ext(j) + E - V_thresh)))^-1;
%         end
%     end
%     
%     hold on;
%     plot(I_ext,r_isi,'LineWidth',2,'Color',colors(i,:));
%     xlabel('I_{ext} (mV)');
%     ylabel('Firing rate (Hz)');
%     set(get(gca,'XLabel'),'FontSize',20);
%     set(get(gca,'YLabel'),'FontSize',20);
%     set(gca,'FontSize',20);
%     hold off;
% end
% lgnd = legend(labels,'Location','Northwest');
% set(lgnd,'FontSize',9);
