clear all;
clc;

load /input_samples
load /test_samples
mydata = input_samples;
newdata = test_samples;

[m,n] = size(mydata);

sum_x = 0;
sum_y = 0;

my_x = mydata(:,1);
my_y = mydata(:,2);

plot(my_x,my_y,'*');

for i=1:m
    sum_x = sum_x + mydata(i,1);
    sum_y = sum_y + mydata(i,2);
end

mean_x = sum_x/m;
mean_y = sum_y/m;

mean(1,1) = mean_x;
mean(2,1) = mean_y;

mean

covar = zeros(2,2);

for i = 1:m
    samp(1,1) = mydata(i,1);
    samp(2,1) = mydata(i,2);
    e1 = samp - mean;
    e2 = e1*(e1');
    covar = covar + e2;
end

covar = covar/m

newcovar = zeros(2,2);

for i = 1:100
    samp(1,1) = newdata(i,1);
    samp(2,1) = newdata(i,2);
    e1 = samp - mean;
    e2 = e1*(e1');
    newcovar = newcovar + e2;
end

new_x = newdata(:,1);
new_y = newdata(:,2);
    
factor = (1/(2*pi*(det(newcovar))))
factor = 1.26

for i=1:100
    samp(1,1) = newdata(i,1);
    samp(2,1) = newdata(i,2);
    e1 = samp - mean;
    e2 = (e1');
    mult = e2*(inv(newcovar))*e1;
    expo = exp(-mult);
    myans(i) = factor*expo;
end

scatter3(new_x,new_y,myans);