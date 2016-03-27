function [ base ] = getbernstein(t,to,tf)

u=(t-to)/(tf-to);


B0=  nchoosek(5,0) * power((1-u),(5)) *power(u,0);
B1=  nchoosek(5,1) * power((1-u),(4)) *power(u,1);
B2=  nchoosek(5,2) * power((1-u),(3)) *power(u,2);
B3=  nchoosek(5,3) * power((1-u),(2)) *power(u,3);
B4=  nchoosek(5,4) * power((1-u),(1)) *power(u,4);
B5=  nchoosek(5,5) * power((1-u),(0)) *power(u,5);

base=[B0,B1,B2,B3,B4,B5];

end
