function x=normData_loop(x)
for row=1:size(x,1)
    m=mean(x(row,:));
    s=std(x(row,:));
    x(row,:)=(x(row,:)-m)/s;
end
