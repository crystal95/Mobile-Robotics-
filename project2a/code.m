clear all;
close all;
T = 1;
phi = 0;
control = [T; phi];
covar_pos = [1,0,0; 0,1,0; 0,0,1];
covar_cont = [0.01, 0; 0, 0.01];
mean_theta = 0;
mean_x = 0;
mean_y = 0;
F(1,1) = 1;
F(1,2) = 0;
F(2,1) = 0;
F(2,2) = 1;
F(3,1) = 0;
F(3,2) = 0;
F(3,3) = 1;

G(3,1) = 0;
G(3,2) = 1;
for i = 1:10
    mynoise = mvnrnd([0;0],covar_cont,1);
    control = (mynoise') + control;
    
    T = control(1,1);
    phi = control(2,1);
    
    F(1,3) = -T*sin(phi+mean_theta);
    F(2,3) = T*cos(phi+mean_theta);
    
    G(1,1) = cos(phi+mean_theta);
    G(1,2) = -T*sin(phi+mean_theta);
    G(2,1) = sin(phi+mean_theta);
    G(2,2) = T*cos(phi+mean_theta);
    
    mean_x = mean_x + T*cos(phi + mean_theta)
    mean_y = mean_y + T*sin(phi + mean_theta)
    mean_theta = phi + mean_theta
    
    new_covar = F*covar_pos*(F') + G*covar_cont*(G')
    coavar_pos = new_covar;
s = mynoise;
[eigenvec, eigenval ] = eig(new_covar);
[largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);
largest_eigenval = max(max(eigenval));
if(largest_eigenvec_ind_c == 1)
    smallest_eigenval = max(eigenval(:,2))
    smallest_eigenvec = eigenvec(:,2);
else
    smallest_eigenval = max(eigenval(:,1))
    smallest_eigenvec = eigenvec(1,:);
end
angle = atan2(largest_eigenvec(2), largest_eigenvec(1));
if(angle < 0)
    angle = angle + 2*pi;
end
chisquare_val = 2.4477;
theta_grid = linspace(0,2*pi);
phi = angle;
%11X0=avg(1);
X0=mean_x;
%22Y0=avg(2);
Y0=mean_y;
a=chisquare_val*sqrt(largest_eigenval);
b=chisquare_val*sqrt(smallest_eigenval);
ellipse_x_r  = a*cos( theta_grid );
ellipse_y_r  = b*sin( theta_grid );
R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];
r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;
plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'-')
z= plot(mean_x,mean_y,'.');
set(z,'Color','red')
hold on;
hXLabel = xlabel('x');
hYLabel = ylabel('y');
end





