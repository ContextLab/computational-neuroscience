function plot_labeled_peak(x)
[maxx,ix]=max(x);
[minn,in]=min(x);

plot(1:length(x),x,'k-',ix,maxx,'ro',in,minn,'bx')
