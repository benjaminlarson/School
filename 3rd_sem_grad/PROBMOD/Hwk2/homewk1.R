
dinvgamma = function(x, alpha, beta){
  # beta^alpha / gamma(alpha) * x^(-alpha - 1) * exp(-beta / x)
  alpha*log(beta)-log(gamma(alpha))+(-alpha - 1)*log(x) + -beta / x
}
dninvg = function(m, s, mu0 = 0, lambda = 10e-6, alpha = 10e-6, beta = 10e-6){
  dnorm(m, mean = mu0, sd = sqrt(s / lambda)) * dinvgamma(s, alpha, beta)
}
gausslik = function(x, sigmaSqr){
  gn = length(x)
  # gn*log(sum(1 / sqrt(2 * pi * sigmaSqr)^(gn/2))) * -sum(x^2) / (2 * sigmaSqr)
  # 1 / (2 * pi * sigmaSqr)^(gn/2) * exp(-sum(xr^2) / (2 * sigmaSqr))
  
  -1*(gn/2)*log(1 / (2 * pi * sigmaSqr))+ (-sum(x^2)/(2*sigmaSqr))

  }
postInv = function(n){
  nn = length(n) 
  m = seq(-1,1,1/1000)
  s = seq(-3*10e-6+10e-6,3*10e-6+10e-6,1/10e7)
  f.iso = outer(m,s,FUN = dninvg)
  print(summary(f.iso))
  gausslik(n,sigmaS = var(n))*f.iso
}
samplePostMargVar = function(amount,data){
  postInv(data)
  # x.iso = postInv(data)
  # sample(x = x.iso, amount, replace=TRUE)
}
samplePostMargMean = function(amount,data){
  postInv(data)
  x.iso = postInv(data)
  sample(x = x.iso, amount, replace=TRUE)
}

## Read in the cross-sectional OASIS data, including hippocampal volumes
x = read.csv("/Users/Benjamin/Documents/PROBMOD/Hwk2/oasis_cross-sectional.csv")
y = read.csv("/Users/Benjamin/Documents/PROBMOD/Hwk2/oasis_hippocampus.csv")
hippo = merge(x, y, by = "ID")

## Let's look at only elderly subjects
hippo = hippo[hippo$Age >= 60,]
rownames(hippo) = NULL

## Create three categories of subjects according to dementia level (from CDR)
## Controls: CDR = 0, Mild Dementia: CDR = 0.5, Dementia: CDR >= 1.0
hippo$Group[hippo$CDR == 0.0] = "Control"
hippo$Group[hippo$CDR == 0.5] = "Mild"
hippo$Group[hippo$CDR >= 1.0] = "Dementia"
hippo$Group = factor(hippo$Group, levels=c("Control", "Mild", "Dementia"))

## Here are some example plots of the data
# ggplot(hippo, aes(x = RightHippoVol, fill = Group)) + geom_density(alpha=0.5)
# boxplot(RightHippoVol ~ Group, data = hippo)

u1 = mean(hippo[which(hippo$Group=="Control"),"RightHippoVol"])
u2 = mean(hippo[which(hippo$Group=="Mild"),"RightHippoVol"])
u3 = mean(hippo[which(hippo$Group=="Dementia"),"RightHippoVol"])
s1 = var(hippo[which(hippo$Group=="Control"),"RightHippoVol"])
s2 = var(hippo[which(hippo$Group=="Mild"),"RightHippoVol"])
s3 = var(hippo[which(hippo$Group=="Dementia"),"RightHippoVol"])
n1 = hippo[which(hippo$Group=="Control"),"RightHippoVol"]
n2 = hippo[which(hippo$Group=="Mild"),"RightHippoVol"]
n3 = hippo[which(hippo$Group=="Dementia"),"RightHippoVol"]

posterior = function(n,u,s) {
  nn = length(n) 
  mu0 = (nn*mean(n) + 10e-6*0)/(10e-6+nn)
  lambda = 10e-6+nn
  alpha = 10e-6+nn/2
  beta = 10e-6+1/2*sum(n^2)+1/2*(10-6*0^2)-1/2*((nn*mean(n)+0)/(nn+10e-6))^2

  # s^(-1/2) * s^(-alpha-1) * exp( -1/(2*s) * ( nn*u^2-2*nn*mu0*u+nn*mu0^2+2*beta))
  
  gausslik(n,s)*(-1/2)*log(s)+(-alpha-1)*log(s)+  -1/(2*s)*(nn*u^2-2*nn*mu0*u+nn*mu0^2+2*beta)
}
n = n1
m = seq(-1,1,1/100) 
# s = seq(-3*10e-6+10e-6,3*10e-6+10e-6,1/10e7)
# s = seq(10e-7,3*10e-6+10e-6,1/10e7) # variance has to be postive
s =  var(n) 
z = gausslik(n,s)
pSy= posterior(n,m,s) 
# x.iso = outer(n1,m,s,FUN=posterior)
# contour(m, x.iso, asp = 1)
# psf_s1 = samplePostMargVar(10e6,n1)
# plot.new()
# frame()
h<-hist(posterior(n,m,s))
# # hist(psf_s1, col = 'blue', freq=FALSE)
# lines(densityx.iso),col = 'red', lwd=2)
abline(v = s, col = 'black', lwd = 5)


# x.iso = postInv(n1,s1)
# x.iso = rowSums(x.iso)
# plot(x.iso) 
# 
# x2.iso = postInv(n2,s2)
# x2.iso = rowSums(x2.iso)
# lines(x2.iso, col = 'red', lwd=2)
# x3.iso = postInv(n3,s3)
# x3.iso = rowSums(x3.iso)
# lines(x3.iso, col = 'red', lwd=2)
# abline(h = u1, col = 'black', lwd = 5)
# abline(h = u1, col = 'black', lwd = 5)
# abline(h = u1, col = 'black', lwd = 5)


