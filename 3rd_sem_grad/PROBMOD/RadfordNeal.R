require(animation)
## This is the same unormalized pdf we sampled from in MetropolisHastings.r

# 
# clamp = function(x, a, b) { (x<a)*a + (x>b)*b + (x>=a)*(x<=b)*x }

## U(q) and its derivative
virgin <- subset(iris, Species == "virginica", select=c(Sepal.Length,Sepal.Width,Petal.Length,Petal.Width))
versi <- subset(iris, Species == "versicolor", select=c(Sepal.Length,Sepal.Width,Petal.Length,Petal.Width))

train_virgin <- as.matrix(virgin[1:30,])
train_virgin <- cbind(train_virgin, 1)
train_versi <- as.matrix(versi[1:30,])
train_versi <- cbind(train_versi, 1)
x = rbind(train_virgin,train_versi)
# y = rbind(subset(iris,Species=="virginica", select = c(Species)),subset(iris,Species=="versicolor",select=c(Species)))
y = cbind(matrix(1, ncol = 30, nrow = 1), matrix(0, ncol=30, nrow=1) ) 
y = t(y) 

test_virgin <- as.matrix(virgin[31:50,])
test_virgin <- cbind(test_virgin, 1)
test_versi <- as.matrix(versi[31:50,])
test_versi <- cbind(test_versi, 1)
xt= rbind(test_virgin,test_versi) 

yt = rbind(matrix(1,20,1), matrix(0,20,1) ) 


U = function(B,sigma){
  r = 0
  for (i in 1:length(y))
  {
    r1 =  t(x[i,])%*%B
    r2 = -y[i]*t(x[i,])%*%B
    r3 = log(1+exp(-t(x[i,])%*%B))
    r = r+r1+r2+r3
  }
  r = r + 1/(2*sigma^2)*(t(B)%*%B)
  print("IN U FUNCTION")
  print(r) 
  return(r) 
}
grad_U = function(B,sigma) {
  r = c(0,0,0,0,0) 
  for (i in 1:length(y))
  {
    r1 =  x[i,]
    r2 =  -t(y[i])*x[i,]
    r3 = -x[i,]*exp(-x[i,]%*%B)/(1+exp(-x[i,]%*%B))
    r = r+r1+r2+r3
  }
  r4 = B/sigma^2
  r = r+r4 
  print("IN GRADU Function")
  print(r) 
  return (r) 
}
## Code from Radford Neal's paper (slightly modified, adds animation)
HMC = function (U, grad_U, epsilon, L, current_q, anim = FALSE)
{
  sigma = 1
  q = current_q
  p = rnorm(length(q),0,1) # independent standard normal variates
  current_p = p
  
  qList = q
  pList = p
  
  ## Make a half step for momentum at the beginning
  p = p - epsilon * grad_U(q,sigma) / 2
  
  ## Alternate full steps for position and momentum
  for(i in 1:(L-1))
  {
    ## Make a full step for the position
    q = q + epsilon * p
    
    ## Make a full step for the momentum, except at end of trajectory
    p = p - epsilon * grad_U(q,sigma)
    
    if(anim)
    {
      H = function(x, y) { U(1,sigma) + 0.5 * y^2 }
      
      t = seq(-2, 2, 0.01)
      Hvals = outer(t, t, H)
      contour(t, t, Hvals, levels=seq(0, 3, 0.1), asp=1,
              drawlabel=FALSE, xlab="q", ylab="p")
      lines(qList, pList, lwd=2, col='red')
      pList = c(pList, p)
      qList = c(qList, q)
    }
  }
  
  q = q + epsilon * p
  
  ## Make a half step for momentum at the end.
  p = p - epsilon * grad_U(q,sigma) / 2
  
  ## Negate momentum at end of trajectory to make the proposal symmetric
  p = -p
  
  ## Evaluate potential and kinetic energies at start and end of trajectory
  current_U = U(current_q,sigma)
  current_K = sum(current_p^2) / 2
  proposed_U = U(q,sigma)
  proposed_K = sum(p^2) / 2
  
  ## Accept or reject the state at end of trajectory, returning either
  ## the position at the end of the trajectory or the initial position

  if(current_U + current_K > proposed_U + proposed_K)
    return(q) # reject
  else if (runif(1) < exp(current_U-proposed_U+current_K-proposed_K))
    return (q) # accept
  else
    return (current_q) # reject
}

trace.plot = function(q)
{
  plot(1:length(q), q, type='l')
}

hist.plot = function(q)
{
  t = seq(-2, 2, 0.01)
  
  ## Approximate the normalizing constant (for purposes of plotting the pdf)
  C = sum(f(t)) * 0.01
  
  hist(q, freq=FALSE, breaks=80)
  t = seq(-2, 2, 0.01)
  lines(t, f(t) / C, lwd = 3, col = 'red')
}

crazy.example = function(numBurn = 10, numSamples = 50, epsilon = 0.05, L =100)
{
  q = 0
  q = matrix(1, ncol = 1, nrow = 5) 
  ## Burn-in
  for(i in 1:numBurn)
    q = HMC(U, grad_U, epsilon, L, q)
  rejectCount = 0
  ## Sampling
  q = cbind(q,q) 
  for(i in 1:(numSamples-1))
  { 
    q = cbind(q ,HMC(U, grad_U, epsilon, L, q[,i]))
    if(q[i] == q[i+1])
      rejectCount = rejectCount + 1
  }
  
  cat(paste("Acceptance rate =", 1 - rejectCount / numSamples, "\n"))
  
  q
}

testsamples = function(){
  ql = crazy.example()
  x = 1:length(ql[1,])
  plot(x,ql[1,],type="l")
  hist(ql[1,])
  plot(x,ql[2,],type="l")
  hist(ql[2,])
  plot(x,ql[3,],type="l")
  hist(ql[3,])
  plot(x,ql[4,],type="l")
  hist(ql[4,]) 
  q = ql[,length(ql[1,])] 
  ytild = c(0)
  theta = matrix(0, ncol = 1, nrow = length(yt)) 

  correct = 0 
  # go through each beta, beta = q 
  for (j in 1:length(ql[1,])){
    q = ql[,j]
    thetav=c() 
    for (i in 1:length(yt)){
      # for the first beta how well did it classify?
      n1 = (1/( 1+ exp( -xt[i,]%*%q )) )
      if (n1>0.5){prob = 1}
      else{prob = 0} 
      ytild = c(ytild, prob)
      #find zero 1 loss 
      if (prob == y[i])
        correct = correct+1
      thetav = c(thetav, n1)
    } 
    correct = correct/length(yt) #divide by the total to get expected value  
    ytild = ytild[2:length(ytild)]  #just to know what ytild is 
    theta = cbind(theta,thetav) # for monte carlo estimator 
  }
  browser() 
  theta = rowMeans(theta) 
  print('Monte Carlo estimate of p(~y|y)')
  plot(1:length(theta),theta)
  lines(yt)
  print(mean(theta))
  print("Zero-one Loss") 
  print(correct) 
}
