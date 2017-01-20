
k_Lcov = function(x,lam)
{
  cc = matrix(1,nrow=length(x[,1]),ncol=length(x[,1]) )
  x1 = cc%*%x
  x1 = x1/length(x[,1]) 
  a = x - x1
  a = t(a)%*%a
  a = a/(length(x[,1])-1) 
  # cc = exp(-1/(2*lam)*a)
return(a)
}

k_cov = function(x,lam)
{
  # exp(-1/(2*lam)* (x - mean(x) )^2)
  xbar = colMeans(x)
  # xbar = diag(xbar)
  # print(xbar)
  c= matrix(0,nrow=length(x[1,]),ncol=length(x[1,]) )
  for (i in 1:length(x[,1]))
  {
    temp = x[i,]-xbar
    c = c + outer(temp,temp)
  }
  c = c/(length(x[,1])-1)
  return(c)
}
k = function(x,x_,lam)
{
  #t(x) repiclate then x replicate then subtract then square 
  n = length(x)
  n_ = length(x_) 
  x = replicate(n_,x) #rep not dot product 
  x_ = t(replicate(n,x_))
  r=exp(-1/(2*lam)*( x- x_ )^2)
  return(r) 
}
# m = t(matrix(c(4,2,0.6,4.2,2.1,0.59,3.9,2,0.58,4.3,2.1,0.62,4.1,2.2,0.63),3,5))
# ans = k_cov(m,1)
# ansk = k_Lcov(m,1) 
# browser() 
# om=t(matrix(c(90,60,90,90,90,30,60,60,60,60,60,90,30,30,30),3,5))
# oms = k_Lcov(om,1) 
# browser() 
# ans = k(m,10)

dra = function(n, p , nr )
{
  x = matrix(0,n,p)
  for (i in 1:nr) {
    u = replicate(p, runif(n)) #make x a matrix 
    s = cov(u)
    L = chol(s)
    x[i] = norm(L%*%t(L) - s) 
    # x[i] = u%*%L  
  }
  x
}
dra_prior = function(x, x_,point, lam)
{
  n = point 
  p = matrix(0,nrow=point,ncol=n) 
  ss = k(x,x_,lam)#this is LAMBDA Maybe change back to k_cov 
  diag(ss) = diag(ss) +0.0001
  L = t(chol(ss)) #chol2inv
  d = length(L[1,]) 
  #n sample size
  #d dimension
  Z = matrix(rnorm(n*d),nrow=d,ncol=n)
  mu = 0# 1:d 
  r = mu + L%*%Z
}
dra_samp = function(ss, point)
{
  n = point
  p = matrix(0,nrow=point,ncol=n)
  L = t(chol(ss))
  d = length(L[1,])
  #n sample size
  #d dimension
  Z = matrix(rnorm(n*d),nrow=d,ncol=n)
  mu = 0# 1:d
  r = mu + L%*%Z
}
# n = 5 #row
# p = 4 #col
# x = seq(-1,1, by= 0.1)
# x_=seq(-1,1, by =0.1)  
# priorSample = dra_prior(x,x_,p, 0.2) #row,col,nr, lam 
# matplot(priorSample, type='l')
# # browser()
sigma_noise = 0.5
x = seq(0,2*pi,2*pi/50)
e = rnorm(x,0,sigma_noise^2)
y = sin(x)+e
plot(x,y)
lines(x,sin(x),col='red')
# 
# ## KERNEL PART for Sin model 
xx = seq(0,2*pi,2*pi/10)
lambda=0.1
ker = k(x,x,lambda)
diag(ker) = diag(ker)+sigma_noise  #   sigma_noise
# k_1 = solve(ker)
k_1 = chol2inv(chol(ker))
kxx_x = k(xx,x,lambda)
## lambda big... singular problem want it to not be all 1s, all 0s. L controls this.

ystar = kxx_x%*%(k_1%*%y)
kxx_xx = k(xx,xx,lambda)
kx_xx = k(x,xx,lambda)
vstar = kxx_xx - kxx_x %*% (k_1 %*% kx_xx)
lines(xx,ystar,col='blue')
lines(xx,ystar+1.96*sqrt(diag(vstar)),col='green')
lines(xx,ystar-1.96*sqrt(diag(vstar)),col='green')
legend("topright", inset=c(-0.1,0), c("True value","Posterior Mean", "95% Confidence Interval"),
       col = c("red", "blue","green"), lwd=3)
# 
# 
# browser() 
# # step2 = t(t(kx_xx)*k_1)
# # step3 = t(t(step2)*kxx_x)
# # kernalmatrix = rbind(cbind(ker,kxx_x),cbind(kx_xx,kxx_xx))
# # yval = dra_samp(kernalmatrix,1:length(xx))
# # plot(x,y)
# 
# 
# # browser()
# ## Plot 95% posterior predictive interval
# ## Plot everything
# ## Plotting variable (x-axis)
# # a = -2
# # b = 2
# # x = runif(n, a, b)
# # X = cbind(rep(1, n), x, x^2, x^3, x^4, x^5, x^6, x^7, x^8, x^9, x^10)
# # 
# # t = seq(a, b, 0.01)
# # sigma = 0.1
# # m = length(t)
# # T = cbind(rep(1, m), t, t^2, t^3, t^4, t^5, t^6, t^7, t^8, t^9, t^10)
# # SigmaPost = sigma^2 * solve(t(X) %*% X + sigma^2 * Lambda)
# # betaPost = sigma^(-2) * as.vector(SigmaPost %*% (t(X) %*% y))
# # sigmaPred = 
# #   sqrt(sigma^2 + apply((T %*% SigmaPost) * T, MARGIN = 1, FUN = sum))
# # ## Upper bound
# # top = ystar + 1.96 * vstar[,1]
# # # # ## Lower bound (in reverse direction - for plotting bottom of a filled
# # # # ## polygon)
# # t.back = seq(b, a, -0.01)
# # bot = ystar - 1.96 * vstar[,1]
# # bot = bot[length(bot):1]
# # # # 
# # plot(x, y, xlim = c(a,b), ylim = range(y, bot, top),
# #      main = "95% Posterior Predictive Interval")
# # polygon(c(t, t.back), c(top, bot), col = rgb(0.5, 0.5, 0.5, 0.5),
# #         border = NA)
# # lines(t, T %*% betaPost, col = 'magenta', lwd=3)
# # lines(t, T %*% trueBeta, col='red', lwd=3)
# # ### COV check 
# # (dir = getwd())
# # setwd(dir)
# slc = read.csv('/Users/Benjamin/Documents/PROBMOD/Hmk5/SaltLakeTemperatures.csv')
# slc <- slc[ slc$AVEMAX != -9999 , ]
# slc$Year <- sapply(slc$DATE, function(x) substring(x, first=1,last=4))
# slc$Month <-sapply(slc$DATE, function(x) substring(x, first=5,last=6 ))
# 
# x = as.numeric(slc$Month)
# xx = seq(1,13,0.01)
# y = as.numeric(slc$AVEMAX)
# sigma_noise = 500
# lambda=1.0
# ker = k(x,x,lambda)
# diag(ker) = diag(ker)+sigma_noise
# k_1 = chol2inv(chol(ker)) 
# 
# kxx_x = k(xx,x,lambda)
# # lambda big... singular problem want it to not be all 1s, all 0s. L controls this.
# 
# ystar = kxx_x%*%(k_1%*%y)
# 
# kxx_xx = k(xx,xx,lambda)
# kx_xx = k(x,xx,lambda)
# 
# # browser() 
# vstar = kxx_xx - kxx_x %*% (k_1 %*% kx_xx)
# d = data.frame(xx,ystar,diag(vstar)) 
# 
# plot(x,y)
# points(xx,ystar,col='red')
# lines(xx,ystar+1.96*sqrt(diag(vstar)),col='green')
# lines(xx,ystar-1.96*sqrt(diag(vstar)),col='green')
# yo = slc[slc[,"Year"]==1906,"AVEMAX"]
# y1 = slc[slc[,"Year"],"AVEMAX"]
# y1 = slc$AVEMAX 
# y1[is.na(y1)]<-0
# xo = slc[slc[,"Year"]==1906,"Month"]
# yo = slc[slc[,"Year"]==1906,"AVEMAX"]
# x = as.numeric(slc$Month) 
# z =as.numeric(slc$Year)-1906
# # browser()
# f1s = seq(1,12,1)
# fos = seq(1,12,1)
# 
# sigma_noise = 1
# lambda=0.01
# # kone = k(xo,fos,lambda)
# 
# k2 = k(f1s,x,lambda)
# 
# z0 = matrix(z, nrow=length(f1s), ncol=length(z), byrow = TRUE) 
# k1 = z0*k2 
# 
# ker = k(x,x,lambda)
# zout = outer(z,z) 
# ker1 = ker+ zout*ker 
# 
# diag(ker1) = diag(ker1)+sigma_noise
# k_1 = chol2inv(chol(ker1)) 
# # post_mean = ktwo%*%(k_1%*%y1)
# # k2z = ktwo%*%z
# # pmz2 = k2z%*%(k_1%*%y1)
# 
# 
# k2k1= rbind(k2,k1) 
# pmc = k2k1%*%k_1%*%y1
# fo = k2%*%k_1%*%y1
# f1 = k1%*%k_1%*%y1
# 
# ks_s = k(f1s,f1s,lambda)
# m0 = matrix(0,nrow=length(f1s),ncol=length(f1s))
# mc = cbind(ks_s,m0) 
# mr = cbind(m0,ks_s)
# post_cov = rbind(mc,mr) - k2k1%*%k_1%*%t(k2k1)
# 
# plot(fo,col='red')
# lines(fo+1.96*sqrt(diag(post_cov))[0:length(fo)],col='green')
# lines(fo-1.96*sqrt(diag(post_cov))[0:length(fo)],col='green')
# plot(f1,col='blue')
# lines(f1+1.96*sqrt(diag(post_cov))[length(fo):length(fo)*2],col='green')
# lines(f1-1.96*sqrt(diag(post_cov))[length(fo):length(fo)*2],col='green')
