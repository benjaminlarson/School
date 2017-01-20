require(png)

## Reads a PNG image (as a simple matrix), which for some reason needs to be
## transposed and flipped to be displayed correctly
read.image = function(filename)
{
  # y = readPNG(system.file(filename,package="png"), TRUE)
  y = readPNG(filename)
  print(min(y))
  print(max(y)) 
  ## This is just how I encoded pixel intensities
  ## After this, the labels will be black = -1 and white = +1
  y = y * 20 - 10
  # y = y/max(y) 
  n = nrow(y)
  
  ## transpose and flip image
  t(y)[,n:1]
}

## Displays an image
display.image = function(x, col=gray(seq(0,1,1/256)))
{
  w = dim(x)[1]
  h = dim(x)[2]
  par(mai = c(0,0,0,0))
  image(x, asp=h/w, col=col)
}
##Function from http://stackoverflow.com/questions/36073795/get-neighbors-function-in-r
## returns up down, right, left 
get.nbhd <- function(m, i, j) {
  # get indices
  idx <- matrix(c(i-1, i+1, i, i, j, j, j+1, j-1), ncol = 2)
  # set out of bound indices to 0
  idx[idx[, 1] > nrow(m), 1] <- 0
  idx[idx[, 2] > ncol(m), 2] <- 0
  # return (m[idx])
  return (idx)
}

ising = function(x,alpha,beta) 
{
  # browser()
  col = dim(x)[1]
  row = dim(x)[2]
  x_ = matrix(rbinom(row*col,1,0.5),nrow = col, ncol = row) 
  x_[x_==0] = -1 
  for (i in 1:nrow(x)){
    for (j in 1:ncol(x)){
      n = get.nbhd(x,i,j)
      b = beta *sum(x[n])*x[i,j]
      a = alpha *x[i,j]
      x_[i,j] = -a - b 
    }
  }
  return (x_) 
 # apply(M, 1, fun)
 # apply(M, 2, fun)
}
ising_gibb = function(x,alpha,beta,sigma) 
{
  col = dim(x)[1]
  row = dim(x)[2]
  x_ = matrix(rbinom(row*col,1,0.5),nrow = col, ncol = row) 
  x_[x_==0] = -1 
  y = x
  # y = matrix(0, nrow=col, ncol=row) 
  vL = c(0) 
  listIm = list() 
  for (itr in 1:20) {
    # print(x == x_)
    x = x_
    display.image(as.matrix(x))
    print("done with 1 iteration") 
    for (i in 1:nrow(x)){
      for (j in 1:ncol(x)){
        n = get.nbhd(x,i,j)
        b = beta*sum(x[n])*x[i,j] 
        a = alpha*x[i,j] 
        l = 1/(2*sigma^2)*(x[i,j]-y[i,j])^2
       
        # P(xi|x = 1)
        a1 = alpha*1
        b1 = beta*sum(x[n])
        l1 = 1/(2*sigma^2)*(1-y[i,j])^2
        # P(xi|x = -1) 
        an = alpha*(-1)
        bn = beta*sum(x[n])*(-1)
        ln = 1/(2*sigma^2)*(-1-y[i,j])^2
        
        n1 = exp(-1*(-a1 - b1 + l1)) # x = +1
        n2 = exp(-1*(-an - bn + ln)) # x = -1
        xi = exp(-1*(-a- b+ l))
        
        p1 = xi/(n1+n2)
        p_1 = 1-p1
        
        if(x[i,j] == 1)
        {
          x_[i,j] = sample(c(1,-1), 1, prob = c(p1,p_1))
        }else{
          x_[i,j] = sample(c(-1,1), 1, prob = c(p1,p_1))
        }
      }
    }
    listIm[[itr]] = x_
    sigma = sqrt(var(as.vector(x_-y)))
    v = 1/length(x_)*sum((x_-y)^2) 
    print(v) 
    vL = c(vL, v)
  }
  # listIm = tail(listIm,-1) 
  vL = tail(vL,-1) 
  plot(vL) 
  listIm = tail(listIm, 6-length(listIm))
  print(sigma) 
  return (listIm)
}

#Create a binomial matrix matrix(rbinom(100,1,0.5),nrow = 100, ncol = 100) 
# require(knitr)
# # dev.off() 
# opts_knit$set(root.dir= '.')
# im = read.image('/Users/Benjamin/Documents/PROBMOD/Hwk4/noisy-message.png')

# (WD <- getwd())
# if(!is.null(WD))setwd(WD) 
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
# im = read.image('noisy-message.png')
im = read.image('/Users/Benjamin/Documents/PROBMOD/Hwk4/noisy-yinyang.png')
# 
# display.image(im) 
# i1 = ising(im,-1,1)
# display.image(as.matrix(i1))
# i2 = ising(im,-1,0.3) 
# display.image(as.matrix(i2))
# i3 = ising(im,-1,30) 
# display.image(as.matrix(i3))
# i4 = ising(im,-1,0.1) 
# display.image(as.matrix(i4))
# i5 = ising(im,-1,10000) 
# display.image(as.matrix(i5))
# browser() 
# ig1 = ising_gibb(im,-2,2,0.5)
# ig1 = ising_gibb(im,-2,10,0.5)# blocky, the values alternate in the markav direction, no image hist = [-1,0,1] 
# ig1 = ising_gibb(im,-1,1,0.4) # better, noise very present, hist [-1,1] 
# ig1 = ising_gibb(im,1,1,0.5) # first best, noisy, hist[-1,1] , more conitinuous
# ig1 = ising_gibb(im,2,-5,0.7) 
# ig1 = ising_gibb(im,-0.08,2, 0.3)GOOD
ig1 = ising_gibb(im,-0.06,1,0.2)
ig1 = apply(simplify2array(ig1), 1:2, mean)

display.image(as.matrix(ig1)) 
# TO INCLUDE THE R SCRIPT INTO RMD USE source(file) at top of file 

