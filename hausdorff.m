function dH = hausdorff( A, B) 
A=A(A>=0);
B=B(B>=0);
dH = max(compute_dist(A, B), compute_dist(B, A));
end
% Compute distance
function dist = compute_dist(A, B) 
m = size(A);
n = size(B);
d_vec = [];
D = [];
% dim= size(A, 2); 
for j = 1:m(2)
    
    for k= 1: n(2)
        
    D(k) = abs((A(j)-B(k)));
      
    end ;
    
    d_vec(j) = min(D); 
      
end;
% keyboard
 dist = max(d_vec);
end