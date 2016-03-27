function [R_new,d_new] = qrgivens_inc(R_up,d_up,num_neweq)
  [m,n] = size(R_up);
  Q = eye(m);
  R_new = R_up;
  d_new = d_up;
  for j = 1:n
    for i = m:-1:m-num_neweq+1 %only performing givens for new rows added (in case of example 2 only for the last 2 rows)
      if i<j+1
          break;
      end
      G = eye(m);
      [c,s] = givensrotation( R_new(j,j),R_new(i,j) ); %Performing givens rotation as in iSAM paper
      G([j, i],[j, i]) = [c -s; s c];
      R_new = G'*R_new;
      d_new = G'*d_new;
    end
  end
  R_new=R_new(1:n,:);
  d_new=d_new(1:n,:);
 end

