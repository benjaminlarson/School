
## Function to create a conditional probability table
## Conditional probability is of the form p(x1 | x2, ..., xk)
## varnames: vector of variable names (strings)
## -- NOTE: first variable listed will be x1, remainder will be parents, x2, ..., xk
## probs: vector of probabilities for the flattened probability table
## levelsList: a list containing a vector of levels (outcomes) for each variable
## See the BayesNetExamples.r file for examples of how this function works

createCPT = function(varnames, probs, levelsList)
{
  ## Check dimensions agree
  if(length(probs) != prod(sapply(levelsList, FUN=length)))
    return(NULL)
  
  ## Set up table with appropriate dimensions
  m = length(probs)
  n = length(varnames)
  g = matrix(0, m, n)
  
  ## Convert table to data frame (with column labels)
  g = as.data.frame(g)
  names(g) = varnames
  
  ## This for loop fills in the entries of the variable values
  k = 1
  for(i in n:1)
  {
    levs = levelsList[[i]]
    g[,i] = rep(levs, each = k, times = m / (k * length(levs)))
    k = k * length(levs)
  }
  
  return(data.frame(probs = probs, g))
}

## Build a CPT from a data frame
## Constructs a conditional probability table as above, but uses frequencies
## from a data frame of data to generate the probabilities.
createCPT.fromData = function(x, varnames)
{
  levelsList = list()
  
  for(i in 1:length(varnames))
  {
    name = varnames[i]
    levelsList[[i]] = sort(unique(x[,name]))
  }
  
  m = prod(sapply(levelsList, FUN=length))
  n = length(varnames)
  g = matrix(0, m, n)
  
  ## Convert table to data frame (with column labels)
  g = as.data.frame(g)
  names(g) = varnames
  
  ## This for loop fills in the entries of the variable values
  k = 1
  for(i in n:1)
  {
    levs = levelsList[[i]]
    g[,i] = rep(levs, each = k, times = m / (k * length(levs)))
    k = k * length(levs)
  }
  
  ## This is the conditional probability column
  probs = numeric(m)
  numLevels = length(levelsList[[1]])
  skip = m / numLevels
  
  ## This chunk of code creates the vector "fact" to index into probs using
  ## matrix multiplication with the data frame x
  fact = numeric(ncol(x))
  lastfact = 1
  for(i in length(varnames):1)
  {
    j = which(names(x) == varnames[i])
    fact[j] = lastfact
    lastfact = lastfact * length(levelsList[[i]])
  }
  ## Compute unnormalized counts of subjects that satisfy all conditions
  a = as.matrix(x - 1) %*% fact + 1
  for(i in 1:m)
    probs[i] = sum(a == i)
  
  ## Now normalize the conditional probabilities
  for(i in 1:skip)
  {
    denom = 0 ## This is the normalization
    for(j in seq(i, m, skip))
      denom = denom + probs[j]
    for(j in seq(i, m, skip))
    {
      if(denom != 0)
        probs[j] = probs[j] / denom
    }
  }
  
  return(data.frame(probs = probs, g))
}

## Product of two factors
## A, B: two factor tables
##
## Should return a factor table that is the product of A and B.
## You can assume that the product of A and B is a valid operation.
productFactor = function(A, B)
{
#   a = length(colnames(A))
#   b = length(colnames(B)) 
#   if(a < b)
#   {
#   #browser() allows you to debug variable names 
#     ca <- colnames(A)[2:length(colnames(A))]
#     cb <- colnames(B)[2:length(colnames(B))]  
#     aINb <- ca %in% cb
#     samecol <- ca[aINb] 
# 
#     for (i in samecol)
#     {
#       # print(paste("smaerowis:",i)) 
#       # cb <- rownames(A)[A[[i]] == B[[i]]]
#       # print(cb) 
#       for (j in A[,i])
#       {
#         # print(paste("j is", j))
#         B[which(B[[i]]== j) ,'probs']<-B[which(B[[i]] == j),'probs']*A[which(A[[i]] == j),'probs']
#       }
#     }
#   return(B) 
#   }
#   else
#   {
#     ca <- colnames(B)[2:length(colnames(B))]
#     cb <- colnames(A)[2:length(colnames(A))]  
#     aINb <- ca %in% cb
#     samecol <- ca[aINb] 
#     
#     for (i in samecol)
#     {
#       for (j in B[,i])
#       {
#         A[which(A[[i]]== j) ,'probs']<-A[which(A[[i]] == j),'probs']*B[which(B[[i]] == j),'probs']
#       }
#     }
#   return(A) 
#   }
  # print(B) 
  # else make a cross product 
  ca <- colnames(A)[2:length(colnames(A))]
  cb <- colnames(B)[2:length(colnames(B))]
  aINb <- ca %in% cb
  samecol <- ca[aINb]
  C = merge(A,B, by=samecol, all=TRUE)
  C$probs <- C$probs.x * C$probs.y
  n <- C[colnames(C)!='probs.x']
  n <- n[colnames(n)!='probs.y']
  n <- n[colnames(n)!='probs']
  C = C[,c('probs',colnames(n))]
  return(C) 
  # print(C)
  
#   a = length(colnames(A))
#   b = length(colnames(B)) 
# 
#   #browser() allows you to debug variable names 

#   
#   X = merge(A,B, by=samecol, all=TRUE)  # merge all, use common variable as pivot
#   
#   for (i in samecol) # find common variables in both tables. Maybe not necessary?
#   {
#     # print(paste("smaerowis:",i)) 
#     # cb <- rownames(A)[A[[i]] == B[[i]]]
#     # print(cb) 
#     for (j in X[,i])# go through merged table rows and multiply probs
#     {
#       # print(paste("j is", j))
#       B[which(B[[i]]== j) ,'probs']<-B[which(B[[i]] == j),'probs']*A[which(A[[i]] == j),'probs']
#     }
#   }
#   return(X) 
}

## Marginalize a variable from a factor
## A: a factor table
## margVar: a string of the variable name to marginalize
##
## Should return a factor table that marginalizes margVar out of A.
## You can assume that margVar is on the left side of the conditional.
marginalizeFactor = function(X, margVar)
{
    # a.tmp = y.x me=margvar  e
    # for z in unique(a.tmp[[me]])
    # idx = which(a.tmp[me] ==z )
    # sum(a.tmp[idx,1])
    
    # i = margVar
    # print(X)
    # for (val in unique(X[[margVar]]))
    # for (val in colnames(X)) 
    
    # X[which(X[[i]]==val),'probs'] <- sum(X[which(X[[i]]==val),'probs'])
#   print("MarginlizeFactor table before:")
#   print(X) 
#   # indx<-grepl(margVar,colnames(X)) 
#   # if (indx %in% colnames(X)) 
#     # {
#   print(margVar)
#   for (i in margVar)
#   {
#     if(i %in% colnames(X))
#     {
#       X<-aggregate(X[,'probs'],by=list(X[[i]]),"sum")
#       # X<-aggregate(probs~margVar, data=X, FUN=sum)
#       print('----------')
#       print(i)
#       print(X) 
#       
#       names(X)[names(X)=='Group.1']<-i
#     }
#   }
  # l<-names(X)[sapply(X,margVar)]
#   print(margVar)
#   print(X) 
  browser()
  X<-subset(X,select=c(colnames(X)[names(X)!=margVar]))
  X<-aggregate(X$probs, by = X[colnames(X)!='probs'], sum)
 
  names(X)[names(X)=='x']<-'probs'
  X<-subset(X,select=c('probs',colnames(X)[names(X)!='probs']))

  return(X) 
}

## Marginalize a list of variables
## bayesnet: a list of factor tables
## margVars: a vector of variable names (as strings) to be marginalized
##
## Should return a Bayesian network (list of factor tables) that results
## when the list of variables in margVars is marginalized out of bayesnet.
marginalize = function(bayesnet, margVars)
{
  # lapply(bayesnet,function(x){marginalizeFactor(x,margVars)})
#   LL <-list()
#   for (tabl in bayesnet)
#   {
#     print(tabl)
#     for (var in margVars)
#     {
#       print(var) 
#       print(tabl)
#       tabl<-marginalizeFactor(tabl,var)
#     }
#     LL<-c(tabl,LL)
#   }
  # return( lapply(bayesnet, FUN=function(x) marginalizeFactor(x,margVars ))) 
  # print(bayesnet) 
  for (i in margVars) 
  {
    bayesnet = lapply(bayesnet,marginalizeFactor, i) 
  }
  # return( lapply(bayesnet, marginalizeFactor, margVars ))
  return(bayesnet)
}

## Observe values for a set of variables
## bayesnet: a list of factor tables
## obsVars: a vector of variable names (as strings) to be observed
## obsVals: a vector of values for corresponding variables (in the same order)
##
## Set the values of the observed variables. Other values for the variables
## should be removed from the tables. You do not need to normalize the factors
## to be probability mass functions.
observe = function(bayesnet, obsVars, obsVals)
{
  # result <- list( obsVars, obsVals)
  # m = matrix(c(seq_along(obsVars),obsVals),ncol=2)
  # print(m[,1])
  # print(m[,2]) 
#   for (table in bayesnet)
#   {
#     # a.tmp = y.x me=margvar  
#     # for z in unique(a.tmp[[me]])
#     # idx = which(a.tmp[me] ==z )
#     # sum(a.tmp[idx,1])
# #     for (i in length(result) )# for each row
#     for (i in length(obsVars))
#     {
#       if (obsVars[i] %in% colnames(table)) 
#       {
#         # table[,which(table[[var]] != var)] <- NULL 
#         # table[!table[obsVars[[i]]]]
#         # table <- subset(table, obsVars[i] != obsVals[i])
#         # table<- subset( table, table[[obsVars[i]]] == obsVals[i]) 
#         #table[ ! table[,obsVars[i]] %in% c(obsVals[i]) ]
#       }
#     }
    # table[which(table[[obsVars]] != table[[obsVars]])] <- NULL
    # table = unique(table)
  # }
  # print(bayesnet[sapply(bayesnet, function(x) any(colnames(x)==obsVars))])
#   for (i in obsVars){
#     bayesn =  bayesnet[sapply(bayesnet, function(x) any(colnames(x) == i))]
#   }
# #   bayesn = bayesnet[sapply(bayesnet, function(x) any(colnames(x)==obsVars))]
# 
#   for (i in obsVars){
#     bayesnot= bayesnet[sapply(bayesnet, function(x) all(colnames(x) != obsVars))]
#   }
# #   bayesnot= bayesnet[sapply(bayesnet, function(x) all(colnames(x) != obsVars))]
#   # return( lapply(bayesnet, function(x){ subset(x, x[[obsVars]]==x[,obsVals]) } )  )
#   bayesn = lapply(bayesn,function(x){x[which(x[[obsVars]]==obsVals) ,] } )
#   for ( i in seq_len(length(obsVars))  )
#   {
# #     bayesn = lapply(bayesn,function(x){
# #       x[which(x[[obsVars[i]]]==obsVals[i]) ,] 
# #       } )
#     
#     bayesn = mapply(function(x){
#       x[which(x[[obsVars[i]]]==obsVals[i]) ,] 
#     }, bayesn)
#   }
#   bayesnet <- mapply(function(w,y,x){
#     browser()
#     # subset(w, w[[x]] == y)
#     print(w) 
#     w[w[[y]]==x ,]
#   },bayesnet, obsVars,obsVals)
  
  for (i in seq_len(length(obsVars))){
    bayesnet <- mapply(function(w,y,x){
      if (any(colnames(w)==x))
        {
          w = w[w[[x]]==y ,]
      }
      w=w 
    },bayesnet,obsVals[i],obsVars[i])
  }
  return (bayesnet)
#   bayesnet <- mapply(function(x,y){
#     # browser()
#     lapply(bayesnet, function(w) subset(w, x == y))
#   },obsVars,obsVals)
#   return (bayesnet)
#   ll<-c() 
#   for ( i in bayesnet){
# #     w = get(i)
# #     print(w) 
#     for (j in seq_len(length(obsVars))) 
#     {
#       if (any(colnames(i) == obsVars[j]))
#           {
#         # bayesnet[i] = bayesnet[i][which(bayesnet[i][[ obsVars[j] ]] == obsVals[j]) ,]
# #         print(obsVars[j])
# #         print(obsVals[j])  
# #         
#         # bayesnet[i] = subset(bayesnet[i], obsVars[j] == obsVals[j])
#           or = obsVars[j]
#           ol = obsVals[j] 
#           i<-i [  i[[or]] == ol , ,drop = FALSE ]
#           ll<-c(ll,data.frame(i))
#           print(i)
#           print(data.frame(i)) 
#           # i = n 
#           # n <- data.frame(n) 
#           # print(i) 
#           # browser()
#           # assign(n,i)
#         }
#     }
#   }
  # bayesn = lapply(names(bayesn),function(x){x[which(x[[obsVars]]==obsVals) ,] } )
#   bayesnet = mapply(function(x) {
# #     print(x) 
# #     print(str(obsVars))
# #     print(obsVars)
# #     print(obsVals)
#     subset(x,obsVars %in% x) }, bayesnet) 
    # x[which(x[[obsVars]]==obsVals),]},bayesnet)
    # subset(x,obsVars==obsVals)}, bayesnet)
#   both <-list(bayesnet,bayesn)
#   n<-unique(unlist(lapply(both,names)))
#   names(n) <- n
#   return( lapply(n, function(ni) unlist(lapply(both,'[[',ni)))  )
  # return (mapply(c, bayesn, bayesnet, SIMPLIFY=FALSE))
  # return(apply(cbind(bayesn,bayesnet),1, function(x) uname(unlist(x))))
}

## Run inference on a Bayesian network
## bayesnet: a list of factor tables
## margVars: a vector of variable names to marginalize
## obsVars: a vector of variable names to observe
## obsVals: a vector of values for corresponding variables (in the same order)
##
## This function should run marginalization and observation of the sets of
## variables. In the end, it should return a single joint probability table. The
## variables that are marginalized should not appear in the table. The variables
## that are observed should appear in the table, but only with the single
## observed value. The variables that are not marginalized or observed should
## appear in the table with all of their possible values. The probabilities
## should be normalized to sum to one.
infer = function(bayesnet, margVars, obsVars, obsVals)
{
  # browser() 
  if ( !(is.null(obsVars)) | !(is.null(obsVals))  )
  {
    bayesnet = observe(bayesnet,obsVars,obsVals)
  }
  tmp = bayesnet[[1]] 
  for (i in seq(2,length(bayesnet),1))
  {
    tmp = productFactor(bayesnet[[i]],tmp)
  }
  bayesnet = list(tmp) 
  # bayesnet = rapply(bayesnet,f = productFactor(x))
#   bayesnet = mapply(FUN = productFactor(x),bayenset)
#   return(bayesnet)
#   c = data.frame()
  
  if ( !(is.null(margVars)) )
  {
    bayesnet = marginalize(bayesnet,margVars) 
    # bayesnet = marginalize(bayesnet[[length(bayesnet)]],margVars) 
    # bayesnet = marginalizeFactor(bayesnet, margVars) 
  }
  #Normailization
  s = colSums(bayesnet[[length(bayesnet)]])
  s = s[['probs']] 
  b = bayesnet[[length(bayesnet)]]
  b[['probs']] = b[['probs']]/s
  
  return(b) 
}
