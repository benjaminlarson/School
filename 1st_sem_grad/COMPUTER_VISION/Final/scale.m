
function im = scale(A)
  mn = min(A(:));
  A = A + abs(mn); 
  mx = max(A(:)); 
  mn = min(A(:)); 
  im = (A-mn)/(mx-mn); 
end 