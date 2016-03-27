clear all;
clc;
close all;

%time
to=0;
tf=10;

%initial and final points
Xto=0;
Xtf=8;
Yto=0;
Ytf=8;

%velocities
Vxto=1;
Vyto=1;

Vxtf=1;
Vytf=1;

%set positions and time for midpoint
Ytc=5;
Xtc=6;
tc=(tf+to)/2;
Vxtc=1;
Vytc=1;

%initializing kto,ktf and their differentiations

kto=1;
ktf=1;
kdto=0;
kdtf=0;

%--------------------------------------------------------initialiing done

%find berstein coefficients for given t
base1=get_bernstein(to,to,tf);
base2=get_bernstein(tf,to,tf);
base3=get_bernstein(tc,to,tf);

%find berstein coefficientes differentiation for given t
base4=get_bernsteindiff(to,to,tf);
base5=get_bernsteindiff(tf,to,tf);
base6=get_bernsteindiff(tc,to,tf);


%bernstein matrix for X
base=cat(1,base1,base2,base3,base4,base5,base6);
baseinv=inv(base);
coeff=[Xto;Xtf;Xtc;Vxto;Vxtf;Vxtc];
X= baseinv * coeff;%finding inverse and multiplying with coeff to find X0,X1..(weights)


%---------------------------------------------coeffs of X found

%finding coeffs K by using get_coeef.m and inverse multiplication

coeff1= [kto;kdto;kdtf;ktf;Ytc;Ytf];
coef1=get_coeff(X(1),X(2),X(3),X(4),X(5),X(6),to,tc,tf);
coef2=get_coeff(X(1),X(2),X(3),X(4),X(5),X(6),to,tf,tf);

base11=cat(1,base1,base4,base5,base2,coef1,coef2)

base11inv=inv(base11)

K = base11inv * coeff1


%-------------------------------------------coeffs of K found


%temp is to be used in the matrix as a iterator
temp=1;

%Getting the data for X, Y at different values of time set as i
for i=to:0.01:tf
  B1=get_bernstein(i,to,tf);
  Ft1= get_coeff(X(1),X(2),X(3),X(4),X(5),X(6),to,i,tf);
  B=transpose(B1);
  F=transpose(Ft1);
  
  xt = X .* B;
  yt=  K .* F;
  
  Xn(temp)=sum(sum(xt));
  Yn(temp) = sum(sum(yt));
  Time(temp)=i;
  
  temp=temp+1;
  
end

%--------------------------------------data for different values of t found

%plotting
figure

subplot(2,1,1);
plot(Yn,Xn);
title('Graph of Y vs x for different values of t');

subplot(2,2,3);
plot(Xn,Time);
title('Graph of X vs time');

subplot(2,2,4);
plot(Yn,Time);
title('Graph of Y vs time');
%-------------------------------------------------------end
