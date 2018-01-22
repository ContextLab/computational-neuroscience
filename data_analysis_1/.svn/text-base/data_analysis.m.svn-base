function data_analysis
close all;
load c1p8

spikeTimes=find(rho==1);
relTimes=-150:150;
%spikeTimes=spikeTimes(spikeTimes>150&spikeTimes<(length(stim)-150));

%problem 1
singleSta=get_sta(stim,spikeTimes,relTimes);
plot(2*relTimes,singleSta);
xlabel('time (ms)'); ylabel('mean value of stim relative to each spike');
title('Problem 1');

%problem 2: get spikes with various separations
allSeps=0:50;
for sep=allSeps
    template=[1 zeros(1,sep) 1];
    inds=find(conv(rho,template)==2);
    %the index matches the last spike in the template
    sta2(sep+1,:)=get_sta(stim,inds,relTimes);
    sta2_sim(sep+1,:)=get_sta(stim,spikeTimes,relTimes)+...
        get_sta(stim,spikeTimes+1+sep,relTimes);
end

figure(2)
plot(sta2(1:15,:)');
title('First 15 two-spike-triggered averages');

figure(3);
x=sum(abs(sta2-sta2_sim),2);
plot(allSeps,x);
xlabel('Separation between the two triggering spikes');
ylabel('Difference from the 2 \times the single STA');

% old problem 3
% for sep=allSeps
%     template=[1 zeros(1,sep) 1];    
%     template2=ones(1,sep+2);
%     inds=find(conv(rho,template)==2 & conv(rho,template2)==2);
%     sta3(sep+1,:)=get_sta(stim,inds,relTimes);
% end
% 
% toPlot=[1:2:20];
% for i=1:length(toPlot)
%     sepNum=toPlot(i); sepName=allSeps(sepNum);
%     subplot(length(toPlot),1,i);
%     plot(relTimes,sta2(sepNum,:),relTimes,sta3(sepNum,:));
%     legend('inclusive','exclusive');
% end
keyboard



function out=get_sta(data,indices,offsets)
out=zeros(1,length(offsets));

indices=indices((indices+min(offsets)>0 )& (indices+max(offsets)<=length(data)));
for i=1:length(indices)
    inds=indices(i)+offsets;
    out=out+data(inds)';
end
out=out./length(indices); %normalize