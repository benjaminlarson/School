#Toy example

k = function(x,lam)
{
  # exp(-1/(2*lam)* (x - mean(x) )^2)
  # xbar = colMeans(x)
  # xbar = diag(xbar)
  # print(xbar)
  o = matrix(1,nrow=length(x[,1]),ncol=length(x[1,]) )
  a = x-x%*%t(o) 
  a= x-a
  a = t(a)*a
  a = a/length(a[,1]-1) 
  l = 1 
  s = 0.1
  s1 = 0.3
  c = (s^2*exp(-1*t(a)*a )/(2*l^2)*s1^2*diag(a))
  return(c)
}
x =c(-1.5,-1,-.75,-.4,-.25,0)
x = x%o%x 
k(x) 
