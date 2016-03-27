% Case of adding new variable and then new measurements
num_neweq=2;
num_newvar=1;
%A=rand(6,3);
b=rand(5,1);
A=[0.8147 0.0975 0.1576;0.9058 0.2785 0.9706;0.1270 0.5469 0.9572 ;0.9134 0.9575 0.4845 ; 0.6324 0.9649 0.8003; ] ;
[Q,R,d,d_e] = qrgivens(A,b) %qr decomp using givens rotation. Returns Q,R, d and Q'*b=d_e. Check these symbols in the paper.
%new_col = zeros(size(A,1),num_newvar);
%new_col_R = zeros(size(R,1),num_newvar)
%new_row = rand(num_neweq, size(A,2)+ num_newvar);
% new_row_b = rand(num_neweq,1);
% A_up = [[A,new_col];new_row]; %updating original A matrix with new measurements and new zero column
% b_up = [b; new_row_b]; % updating b by adding new entries
% R_up = [[R,new_col_R];new_row] % updating R with the same measurements used to update A. We expand the R before adding the new measurements with a zero column
% d_up = [d; new_row_b]; % updating d with the entries used to update b
% [R_new,d_new,] = qrgivens_inc(R_up,d_up,num_neweq) %applying givens to updated R and d and extracting new R and d. Additionally giving number of new rows as input
% sol1 = backSubstitution(R,d) %solution by factorization 
% actual_sol1 = pinv(A)*b %directly solving the equation
% sol2 = backSubstitution(R_new,d_new)
% actual_sol2 = pinv(A_up)*b_up