function x=normData_vec(x)
m=mean(x,2);
s=std(x,[],2);
%x=(x-repmat(m,1,size(x,2)))./repmat(s,1,size(x,2));
x=bsxfun(@rdivide,bsxfun(@minus,x,m),s);
