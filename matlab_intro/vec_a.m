function vec_a

sizes=[1 10 100 1000 10000 100000];

for i=1:length(sizes)
    x=randn(sizes(i),3);

    tic;
    c=loop_dist(x);
    loop_time(i)=toc;
    
    tic;
    c=vec_dist(x);
    vec_time(i)=toc;
    

end

loglog(sizes,vec_time,sizes,loop_time)
legend('vec','loop');

keyboard
    
function d=loop_dist(x)
for i=1:size(x,1)
    d(i)=sqrt(x(i,1)^2+x(i,2)^2+x(i,3)^2);
end

    
function d=vec_dist(x)
d=sqrt(sum(x.^2,2));