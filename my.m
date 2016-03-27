
clear all;
clc;


T = 1;
phi = 0;

T_noise = 1;
phi_noise = 0;

control = [T; phi];
control_noise = [T_noise; phi_noise];

covar_pos = [1,0,0; 0,1,0; 0,0,1];
covar_cont = [0.01, 0; 0, 0.01];
Q = [0.5, 0; 0, 0.5];

%initially robot is moving in +x direction. 
mean_theta = 0;
mean_x = 0;
mean_y = 0;
mean_x_truth = 0;
mean_y_truth = 0;
mean_theta_truth = 0;

mean = [mean_x; mean_y; mean_theta];

lx = 5;
ly = 0;
lm2_x = 8;
lm2_y = 6;


%F = [1,0,0; 0,1,1; 0,0,1];  
%G = [1,0; 0,1; 0,1];
F(1,1) = 1;
F(1,2) = 0;
F(2,1) = 0;
F(2,2) = 1;
F(3,1) = 0;
F(3,2) = 0;
F(3,3) = 1;

G(3,1) = 0;
G(3,2) = 1;

%H(1,3) = 0;
%H(2,3) = 0;
%H(3,1) = 0;
%H(3,2) = 0;
%H(3,3) = 1;

I = eye(3,3);

for i = 1:10
    
    mean_x = mean(1,1);
    mean_y = mean(2,1);
    mean_theta = mean(3,1);
    
    mynoise = mvnrnd([0;0],covar_cont,1);
    control_noise = (mynoise') + control;
    
    T_noise = control_noise(1,1);
    phi_noise = control_noise(2,1);
    
    mean_x_truth = mean_x + T_noise*cos(phi_noise + mean_theta);
    mean_y_truth = mean_y + T_noise*sin(phi_noise + mean_theta);
    mean_theta_truth = phi_noise + mean_theta;
    
    zx_truth = (lx - mean_x_truth)*(lx - mean_x_truth);
    zy_truth = (ly - mean_y_truth)*(ly - mean_y_truth);
    zdist_truth = sqrt(zx_truth + zy_truth);
    ztheta_truth = atan((ly - mean_y_truth)/(lx - mean_x_truth)) - mean_theta_truth;
    ztruth = [zdist_truth; ztheta_truth];
    
    T = control(1,1);
    phi = control(1,1);
    
    F(1,3) = -T*sin(phi+mean_theta);
    F(2,3) = T*cos(phi+mean_theta);
    
    G(1,1) = cos(phi+mean_theta);
    G(1,2) = -T*sin(phi+mean_theta);
    G(2,1) = sin(phi+mean_theta);
    G(2,2) = T*cos(phi+mean_theta);
    
    mean_x = mean_x + T*cos(phi + mean_theta);
    mean_y = mean_y + T*sin(phi + mean_theta);
    mean_theta = phi + mean_theta;
    
    k1 = (lx - mean_x)*(lx - mean_x) + (ly - mean_y)*(ly - mean_y);
    k2 = (ly - mean_y)/(lx - mean_x);
    
    zx = (lx - mean_x)*(lx-mean_x);
    zy = (ly - mean_y)*(ly-mean_y);
    zdist = sqrt(lx+ly);
    ztheta = atan((ly - mean_y)/(lx - mean_x)) - mean_theta;
    z = [zdist; ztheta];
    
    H(1,1) = -sqrt(k1)*(lx - mean_x);
    H(1,2) = -sqrt(k1)*(ly - mean_y);
    H(1,3) = 0;
    H(2,1) = (1/(1+k2*k2))*(ly - mean_y)*(1/(lx - mean_x))*(1/(lx - mean_x));
    H(2,2) = (1/(1+k2*k2))*(-1)*(1/(lx - mean_x))*(ly - mean_y);
    H(2,3) = -1;
    %H(3,1) = 0;
    %H(3,2) = 0;
    %H(3,3) = 1;
    
    %mean_x = mean_x + 
    
    new_covar = F*covar_pos*(F') + G*covar_cont*(G')
    coavar_pos = new_covar;
    SSS=H*covar_pos*(H') + Q;
    
    k = covar_pos*(H')*inv(H*covar_pos*(H') + Q);
    
    mean = [mean_x; mean_y; mean_theta];
    mean = mean + k*(ztruth - z);
    covar_pos = (I - k*H)*covar_pos;
    

%ellipse
% Create some random data

s = mynoise;
%1x = randn(334,1);
%2y1 = normrnd(s(1).*x,1);
%3y2 = normrnd(s(2).*x,1);
%4data = [y1 y2];

% Calculate the eigenvectors and eigenvalues
%5covariance = cov(data);
%6[eigenvec, eigenval ] = eig(covariance);
[eigenvec, eigenval ] = eig(covar_pos);


% Get the index of the largest eigenvector
[largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);

% Get the largest eigenvalue
largest_eigenval = max(max(eigenval));

% Get the smallest eigenvector and eigenvalue
if(largest_eigenvec_ind_c == 1)
    smallest_eigenval = max(eigenval(:,2))
    smallest_eigenvec = eigenvec(:,2);
else
    smallest_eigenval = max(eigenval(:,1))
    smallest_eigenvec = eigenvec(1,:);
end

% Calculate the angle between the x-axis and the largest eigenvector
angle = atan2(largest_eigenvec(2), largest_eigenvec(1));

% This angle is between -pi and pi.
% Let's shift it such that the angle is between 0 and 2pi
if(angle < 0)
    angle = angle + 2*pi;
end

% Get the coordinates of the data mean
%avg = mean(data);

% Get the 95% confidence interval error ellipse
chisquare_val = 2.4477;
theta_grid = linspace(0,2*pi);
phi = angle;
%11X0=avg(1);
X0=mean_x;
%22Y0=avg(2);
Y0=mean_y;
a=chisquare_val*sqrt(largest_eigenval);
b=chisquare_val*sqrt(smallest_eigenval);

% the ellipse in x and y coordinates 
ellipse_x_r  = a*cos( theta_grid );
ellipse_y_r  = b*sin( theta_grid );

%Define a rotation matrix
R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];

%let's rotate the ellipse to some angle phi
r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;

% Draw the error ellipse
plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'-')

%plot(mean_x,mean_y,'*','r');
%hold on;
z= plot(mean_x,mean_y,'.');
set(z,'Color','red')
hold on;
hold on;

% Plot the original data
%plot(data(:,1), data(:,2), '.');
%mindata = min(min(data));
%maxdata = max(max(data));
%Xlim([mindata-3, maxdata+3]);
%Ylim([mindata-3, maxdata+3]);
%hold on;

% Plot the eigenvectors
%quiver(X0, Y0, largest_eigenvec(1)*sqrt(largest_eigenval), largest_eigenvec(2)*sqrt(largest_eigenval), '-m', 'LineWidth',2);
%quiver(X0, Y0, smallest_eigenvec(1)*sqrt(smallest_eigenval), smallest_eigenvec(2)*sqrt(smallest_eigenval), '-g', 'LineWidth',2);
%hold on;

% Set the axis labels
hXLabel = xlabel('x');
hYLabel = ylabel('y');
end




