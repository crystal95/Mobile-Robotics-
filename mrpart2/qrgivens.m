function [Q,R,d,d_e] = qrgivens(A,b)
  [m,n] = size(A);
  Q = eye(m);
  R = A;

  for j = 1:n
    for i = m:-1:(j+1)
      G = eye(m);
      [c,s] = givensrotation( R(i-1,j),R(i,j) );
      G([i-1, i],[i-1, i]) = [c -s; s c];
      R = G'*R;
      Q = Q*G;
    end
  end
  R=R(1:n,:);
  d_e=Q'*b;
  d=d_e(1:n,:);
end