# b = createCPT(list("battery"), probs = c(0.9, 0.1), levelsList = list(c(1, 0)))
# f = createCPT(list("fuel"), probs = c(0.9, 0.1), levelsList = list(c(1, 0)))
# g.bf = createCPT(list("gauge", "battery", "fuel"),
#                  probs = c(0.8, 0.2, 0.2, 0.1, 0.2, 0.8, 0.8, 0.9),
#                  levelsList = list(c(1, 0), c(1, 0), c(1, 0)))
# 
# carNet = list("battery" = b, "fuel" = f, "gauge" = g.bf)

script.dir <- dirname(sys.frame(1)$ofile)
setwd(script.dir) 
data = read.csv('RiskFactors.csv')
source('H2a.R')
income = createCPT.fromData(data,'income')
exercise = createCPT.fromData(data,c('exercise','income')) 
smoke = createCPT.fromData(data,c('smoke','income'))
bmi = createCPT.fromData(data,c('bmi','income','exercise'))
bp = createCPT.fromData(data,c('bp','exercise','income','smoke'))
cholesterol=createCPT.fromData(data,c('cholesterol','exercise','income','smoke'))
angina = createCPT.fromData(data,c('angina','cholesterol','bp','bmi'))
stroke = createCPT.fromData(data,c('stroke','bmi','bp','cholesterol'))
attack = createCPT.fromData(data,c('attack','bmi','bp','cholesterol'))
diabetes = createCPT.fromData(data,c('diabetes','bmi'))

riskfactor = list('income'=income,'exercise'=exercise,'smoke'=smoke,
                  'bmi'=bmi,'bp'=bp,'cholesterol'=cholesterol,'angina'=angina,
                  'stroke'=stroke,'attack'=attack,'diabetes'=diabetes)

# Part 1 ------------------------------- -------------------------------
# find the number of probabilities for network
networkprobs = 0
for (i in riskfactor)
{
  networkprobs = networkprobs + length(i[['probs']])
}
print (networkprobs)

# find the joint prb tables
tmp = riskfactor[[1]] 
for (i in seq(2,length(riskfactor),1))
{
  tmp = productFactor(riskfactor[[i]],tmp)
}
print(length(tmp[['probs']]))
# 
#Part 2 ------------------------------- -------------------------------
#### infer = function(bayesnet, margVars, obsVars, obsVals)
#bad habits 
diabetesnet = list('income'=income,'bmi'=bmi,'diabetes'=diabetes,'exercise'=exercise)
strokenet   = list('income'=income,'exercise'=exercise,'smoke'=smoke, 'bmi'=bmi,'bp'=bp,'cholesterol'=cholesterol,'stroke'=stroke)
heartnet    = list('income'=income,'exercise'=exercise,'smoke'=smoke, 'bmi'=bmi,'bp'=bp,'cholesterol'=cholesterol,'attack'=attack)
anginanet   = list('income'=income,'exercise'=exercise,'smoke'=smoke, 'bmi'=bmi,'bp'=bp,'cholesterol'=cholesterol,'angina'=angina)

infer(diabetesnet,c('bmi','income'), c('smoke','exercise'), c(1,2))
infer(strokenet, c('bmi','income','cholesterol','bp'),c('smoke','exercise'), c(1,2))
infer(heartnet , c('bmi','income','cholesterol','bp'),c('smoke','exercise'), c(1,2))
infer(anginanet, c('bmi','income','cholesterol','bp'),c('smoke','exercise'), c(1,2))
#b poor health  
infer(diabetesnet,c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(3,1,1))
infer(strokenet, c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(3,1,1))
infer(heartnet,  c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(3,1,1))
infer(anginanet, c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(3,1,1))

#b good health, low blood, low cholest, normal weight 
infer(diabetesnet,c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(2,3,2))
infer(strokenet,  c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(2,3,2))
infer(heartnet,  c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(2,3,2))
infer(anginanet, c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(2,3,2))

# 
# #Part 3 ------------------------------- -------------------------------
# diabetesnet = list('bmi'=bmi,'exercise'=exercise,'diabetes'=diabetes)
# tmp = diabetesnet[[1]] 
# for (i in seq(2,length(diabetesnet),1))
# {tmp = productFactor(diabetesnet[[i]],tmp)}
# tmp = marginalize(list(tmp), c('bmi','exercise'))
# tmp = tmp[[1]]
# # plot(c(1,2,3,4,5,6,7,8),tmp[ which(tmp[['diabetes']]==1),'probs']) 
# 
# strokenet   = list('exercise'=exercise,'smoke'=smoke,'bmi'=bmi,'bp'=bp,'cholesterol'=cholesterol,'stroke'=stroke)
# tmp = strokenet[[1]] 
# for (i in seq(2,length(strokenet),1))
# {tmp = productFactor(strokenet[[i]],tmp)}
# tmp = marginalize(list(tmp), c('bmi','exercise','cholesterol','bp','smoke'))
# tmp = tmp[[1]]
# # plot(c(1,2,3,4,5,6,7,8),tmp[ which(tmp[['stroke']]==1),'probs']) 
# 
# heartnet    = list('exercise'=exercise,'smoke'=smoke, 'bmi'=bmi,'bp'=bp,'cholesterol'=cholesterol,'attack'=attack)
# tmp = heartnet[[1]] 
# for (i in seq(2,length(heartnet),1))
# {tmp = productFactor(heartnet[[i]],tmp)}
# tmp = marginalize(list(tmp), c('bmi','exercise','cholesterol','bp','smoke'))
# tmp = tmp[[1]]
# # plot(c(1,2,3,4,5,6,7,8),tmp[ which(tmp[['attack']]==1),'probs']) 
# 
# anginanet   = list('exercise'=exercise,'smoke'=smoke, 'bmi'=bmi,'bp'=bp,'cholesterol'=cholesterol,'angina'=angina)
# tmp = anginanet[[1]] 
# for (i in seq(2,length(anginanet),1))
# {tmp = productFactor(anginanet[[i]],tmp)}
# tmp = marginalize(list(tmp), c('bmi','exercise','cholesterol','bp','smoke'))
# tmp = tmp[[1]]
# # plot(c(1,2,3,4,5,6,7,8),tmp[ which(tmp[['angina']]==1),'probs']) 
# 
# 
# #Part 4 ------------------------------- -------------------------------
# #add smoke and exercise to all nets 
# 
# angina = createCPT.fromData(data,c('angina','cholesterol','bp','bmi','smoke','exercise'))#added edge
# stroke = createCPT.fromData(data,c('stroke','bmi','bp','cholesterol','smoke','exercise'))#added edge
# attack = createCPT.fromData(data,c('attack','bmi','bp','cholesterol','smoke','exercise'))#added edge
# diabetes = createCPT.fromData(data,c('diabetes','bmi','smoke','exercise'))#added edge
# 
# diabetesnet = list('income'=income,'bmi'=bmi,'diabetes'=diabetes,'exercise'=exercise,'smoke'=smoke)
# strokenet   = list('income'=income,'exercise'=exercise,'smoke'=smoke, 'bmi'=bmi,'bp'=bp,'cholesterol'=cholesterol,'stroke'=stroke)
# heartnet    = list('income'=income,'exercise'=exercise,'smoke'=smoke, 'bmi'=bmi,'bp'=bp,'cholesterol'=cholesterol,'attack'=attack)
# anginanet   = list('income'=income,'exercise'=exercise,'smoke'=smoke, 'bmi'=bmi,'bp'=bp,'cholesterol'=cholesterol,'angina'=angina)
# 
# infer(diabetesnet,c('bmi','income'), c('smoke','exercise'), c(1,2))
# infer(strokenet, c('bmi','income','cholesterol','bp'),c('smoke','exercise'), c(1,2))
# infer(heartnet , c('bmi','income','cholesterol','bp'),c('smoke','exercise'), c(1,2))
# infer(anginanet, c('bmi','income','cholesterol','bp'),c('smoke','exercise'), c(1,2))
# #b poor health  
# infer(diabetesnet,c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(3,1,1))
# infer(strokenet, c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(3,1,1))
# infer(heartnet,  c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(3,1,1))
# infer(anginanet, c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(3,1,1))
# 
# #b good health, low blood, low cholest, normal weight 
# infer(diabetesnet,c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(2,3,2))
# infer(strokenet,  c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(2,3,2))
# infer(heartnet,  c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(2,3,2))
# infer(anginanet, c('smoke','income','exercise'), c('bmi','bp','cholesterol'), c(2,3,2))
# 
# 
# #Part 5 ------------------------------- -------------------------------
# #added edge to stroke 
# stroke2 = createCPT.fromData(data,c('stroke','bmi','bp','cholesterol','smoke','exercise','diabetes'))
# strokenet2   = list('income'=income,'exercise'=exercise,'smoke'=smoke, 'bmi'=bmi,
#                    'bp'=bp,'cholesterol'=cholesterol,'stroke'=stroke,'diabetes'=diabetes)
# 
# tmp = strokenet[[1]] 
# for (i in seq(2,length(strokenet),1))
# {tmp = productFactor(strokenet[[i]],tmp)}
# tmp = marginalize(list(tmp), c('bmi','exercise','cholesterol','bp','smoke','income'))
# tmp = tmp[[1]]
# tmp[ which(tmp[['stroke']]==1),'probs']
# 
# tmp = strokenet2[[1]] 
# for (i in seq(2,length(strokenet2),1))
# {tmp = productFactor(strokenet2[[i]],tmp)}
# tmp = marginalize(list(tmp), c('bmi','exercise','cholesterol','bp','smoke','income'))
# tmp = tmp[[1]]
# tmp[ which(tmp[['stroke']]==1),'probs']
# 
# tmp = strokenet[[1]] 
# for (i in seq(2,length(strokenet),1))
# {tmp = productFactor(strokenet[[i]],tmp)}
# tmp = marginalize(list(tmp), c('bmi','exercise','cholesterol','bp','smoke','income'))
# tmp = tmp[[1]]
# tmp[ which(tmp[['stroke']]==1),'probs']
# 
# tmp = strokenet2[[1]] 
# for (i in seq(2,length(strokenet2),1))
# {tmp = productFactor(strokenet2[[i]],tmp)}
# tmp = marginalize(list(tmp), c('bmi','exercise','cholesterol','bp','smoke','income'))
# tmp = tmp[[1]]
# tmp[ which(tmp[['stroke']]==1),'probs']


