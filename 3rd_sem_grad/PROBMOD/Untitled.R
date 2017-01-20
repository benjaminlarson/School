# uncorrelated but independent ex
# univariate gaussian dist G1, G2

n = 100000
w = sample(c(-1,1), n, prob = c(.5,.5),replace = TRUE)
G1=rnorm(n)
G2=w*G1

mean(G1)
var(G1)
plot(density(G1))

mean(G2)
var(G2)
plot(density(G2))

cor(G1,G2)
plot(G1,G2) 
