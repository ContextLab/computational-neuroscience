function vec_a

sizes=10.^[1:8];

for i=1:length(sizes)
    i
    vec=createBinVec(sizes(i));
    tic;
    vec_counter(vec);
    vec_time(i)=toc;
    
    tic;
    loop_counter(vec);
    loop_time(i)=toc;
end

loglog(sizes,vec_time,sizes,loop_time)

keyboard
    
    
    

function c=vec_counter(x)
c=sum(diff(x)==1);

function c=loop_counter(x)
c=0;
for i=2:length(x)
    if x(i)==1&&x(i-1)==0
        c=c+1;
    end
end



function y=createBinVec(n)
%y=rand(1,n)>.5;
y=round(rand(1,n));

