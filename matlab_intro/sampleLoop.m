clear
x=rand(1,10)
for i=1:length(x)
    if x(i)>.5
        x(i)=x(i)+10;
    end
end
x
