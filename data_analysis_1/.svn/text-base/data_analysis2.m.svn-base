load c2p3
close all;
figure(1);
stim=double(stim);
latencies=1:12;
for i=1:length(latencies)
    c2=[counts((1+latencies(i)):end)' zeros(1,latencies(i))];
    indices=c2>0;
    weights=c2(indices);
    d=stim(:,:,indices);
    d=d.*repmat(shiftdim(weights,-1),[size(stim,1),size(stim,1),1]);
    curFrame(:,:,i)=sum(d,3)./sum(c2);
    subplot(3,4,latencies(end)-i+1)
    imagesc(curFrame(:,:,i));
    axis off;
    axis square
    title(sprintf('Latency %.1f ms',-15.6*i));
    set(gca,'clim',[-1 1]*max(abs(curFrame(:))));
    drawnow
end

c3=squeeze(mean(curFrame,2));

figure(2);
contourf(1:16,-15.6*latencies,c3');
ylabel('time (ms)'); xlabel('Position');
colorbar;

