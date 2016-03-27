function x=backSubstitution(U,b)
n=size(b,1);
x=zeros(n,1);
for j=n:-1:1
    if (U(j,j)==0) 
        error('Matrix is singular!'); 
    end;
    x(j)=b(j)/U(j,j);
    b(1:j-1)=b(1:j-1)-U(1:j-1,j)*x(j);
end