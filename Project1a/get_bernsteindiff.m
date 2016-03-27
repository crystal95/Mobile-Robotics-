function [ base1 ] = getbernsteindiff(t,to,tf)

u=(t-to)/(tf-to);

for i=0:5
    if(i==0)
      Bd0= ( - ( (5-i)*nchoosek(5,i)* power(1-u,5-i-1) * power(u,i)  ))/(tf-to);
    elseif(i==1)
        Bd1= ((i*nchoosek(5,i)* power(1-u,5-i) * power(u,i-1) ) - ( (5-i)*nchoosek(5,i)* power(1-u,5-i-1) * power(u,i)  ))/(tf-to);
    elseif(i==2)
        Bd2= ((i*nchoosek(5,i)* power(1-u,5-i) * power(u,i-1) ) - ( (5-i)*nchoosek(5,i)* power(1-u,5-i-1) * power(u,i)  ))/(tf-to);
    elseif(i==3)
        Bd3= ((i*nchoosek(5,i)* power(1-u,5-i) * power(u,i-1) ) - ( (5-i)*nchoosek(5,i)* power(1-u,5-i-1) * power(u,i)  ))/(tf-to);
    elseif(i==4)
        Bd4= ((i*nchoosek(5,i)* power(1-u,5-i) * power(u,i-1) ) - ( (5-i)*nchoosek(5,i)* power(1-u,5-i-1) * power(u,i)  ))/(tf-to);
    elseif(i==5)
        Bd5= ((i*nchoosek(5,i)* power(1-u,5-i) * power(u,i-1) ))/(tf-to);
    end
    
end

    base1=[Bd0,Bd1,Bd2,Bd3,Bd4,Bd5];
end
