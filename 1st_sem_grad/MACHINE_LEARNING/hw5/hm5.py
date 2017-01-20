
import numpy as np
import math

class node(object):
	data = ''
	def __init__(self, data):
		self.data = data
		self.children = {}

    	def __str__(self):
        		return str(self.__dict__)

    	def __eq__(self, other): 
        		return self.__dict__ == other.__dict__

	def add_child(self, key, value):
		self.children[key] = value

#TRUE FALSE LEAFS >>>> NO CHILDREN CASE
nt = node('')
nt.data = 1.0
nf = node('')
nf.data = -1.0 #0.0 

def all_same(items):
	return all(x == items[0] for x in items) 

def readFeatures(F):
	with open(F) as f:
		lines=f.read().splitlines()
	numbers=[]
	for e in lines:
		temp = e.strip().split()
		numbers.append(temp)
	return numbers

badgesTrainF = readFeatures('badges/badges-train-features.txt') 
badgesTestF = readFeatures('badges/badges-test-features.txt') 
# with open('badges/badges-test.txt') as f:
# 	badgesTest = f.readlines()  
# with open('badges/badges-train.txt') as f:
# 	badgesTrain = f.readlines() 
# print len(badgesTrainF)
data_input_array = [] 

r = len(badgesTrainF)
# print r
c = len(badgesTrainF[0])
# print r, c
data = np.zeros((r,c)) 
# print data
# 220 rows, 271 columns
#convert data from dictionary format
i = 0 
for x in badgesTrainF:
	j = 0
	for y in x: 
		L = y.split(":")
		if len(L) < 2:
			data[i,j] = float(L[0])
		else:
			data[i,j] = float(L[1])
		j += 1
	i += 1
#TEST DATA
i = 0 
r = len(badgesTestF)
c = len(badgesTestF[0])
# print r, c
testdata = np.zeros((r,c)) 
for x in badgesTestF:
	j = 0
	for y in x: 
		L = y.split(":")
		if len(L) < 2:
			testdata[i,j] = float(L[0])
		else:
			testdata[i,j] = float(L[1])
		j += 1
	i += 1
# # print "data before rid", data.shape
# ##GET RID OF FEATRURES THAT DONT APPEAR 
# toD= []
# for A in xrange( len( data[1,:] ) ):#each column A
# 	# print A 
# 	if all_same( data[:,A] ):  #all rows, column A
# 		toD.append(A) 

# data = np.delete(data, toD, 1) #see ya	

# #is there a problem with rid method? 
# for A in xrange( len( data[1,:] ) ):#each column A
# 	if all_same( data[:,A] ):  #all rows, column A
# 		print "some same left"	
# # print "data after rid", data.shape
# # print data

def InfoGain(data, target):
	subset_entropy = 0.0
	plus= 0.0
	neg = 0.0 
	d = len(data[:,target]) 
	for r in xrange(len(data[:,target])): # each example in target column
		#for entropy of system -1 etc...
		y = np.where(data[:,target] == -1) 
		if(  len(y[0] ) > 0 ):
			if(data[r,target] == 1.):
				# print 'data compare E pos', data[r,0], data[r,target] 
				plus += 1. 
			elif (data[r,target] == 1.):
				# print 'data compare E neg', data[r,0], data[r,target] 
				neg += 1.    
			else:
				if data[r,target] != -1.:
					print "system entropy ERROR", data[r,target], data[r,0] 
					print "datatarget                ", data[r,target] 
		else:
			#normal Search
			if(data[r,0] == 1. and data[r,target] == 1.):
				# print 'data compare E pos', data[r,0], data[r,target] 
				plus += 1. 
			elif (data[r,0] == -1. and data[r,target] == 1.):
				# print 'data compare E neg', data[r,0], data[r,target] 
				neg += 1.    
			else:
				if data[r,target] != 0.:
					print "error in findEntropy ", data[r,target], data[r,0] 
					print "datatarget                ", data[r,target] 
	subset_entropy = (plus/d) * findEntropy(data,target) + (neg/d)*findEntropy(data,target)
	if subset_entropy == 0.0:
		return 0.0 
	return (findEntropy(data, 0) - subset_entropy)

## Only checks for 1 and 0 values. If there are more values this needs to change 
def findEntropy(data, target):
	# print data
	entropy = 0.0
	plus= 0.0
	neg = 0.0 
	d = len(data[:,target] ) 
	for r in xrange(len(data[:,target])): # each example in target column
		#for entropy of system -1 etc...
		y = np.where(data[:,target] == -1) 
		if(  len(y[0] ) > 0 ):
			if(data[r,target] == 1.):
				# print 'data compare E pos', data[r,0], data[r,target] 
				plus += 1. 
			elif (data[r,target] == 1.):
				# print 'data compare E neg', data[r,0], data[r,target] 
				neg += 1.    
			else:
				if data[r,target] != -1.:
					print "system entropy ERROR", data[r,target], data[r,0] 
					print "datatarget                ", data[r,target] 
		else:
			#normal Search
			if(data[r,0] == 1. and data[r,target] == 1.):
				# print 'data compare E pos', data[r,0], data[r,target] 
				plus += 1. 
			elif (data[r,0] == -1. and data[r,target] == 1.):
				# print 'data compare E neg', data[r,0], data[r,target] 
				neg += 1.    
			else:
				if data[r,target] != 0.:
					print "error in findEntropy ", data[r,target], data[r,0] 
					print "datatarget                ", data[r,target] 
	if plus == 0.:
		pl = 0.
	else:
		f = plus/d
		# print "f", f 
		pl = -f* np.log2(f)
	if neg == 0.:
		nl = 0.
	else:
		f = neg/d 
		# print "f", f 
		nl = -f* np.log2(f)
	# print "pl, nl", pl, nl
	entropy = pl + nl
	# print"entropy", target, entropy 
	return  entropy

def readFeatures(F):
	with open(F) as f:
		lines=f.read().splitlines()
	numbers=[]
	for e in lines:
		temp = e.strip().split()
		numbers.append(temp)
	return numbers

def majority_label(data, target):
	#data is a list of dictionaries
	plus= 0.0
	neg = 0.0 
	for r in xrange(len(data[:,target])): # each example in target column
		# if(data[r,0] == 1. and data[r,target] == 1.):
		if (data[r,0]  > 0):
			plus += 1 
		# if data[r,0] == 0. and data[r,target] == 1.:
		if (data[r,0] < 0 ):
			neg += 1.  
	if (neg >= plus):
		return -1. 
	else: 
		return 1.

def get_subset( data, A, val):
	""" Returns a list of all the records in data with the value of attribute
	matching the given value """
	datai = data [:]
	toDelete =[]
	noD = []
	if not datai.any():
		print "not dataany"
		return datai
	else:
		for r in xrange( len( datai[:,A] ) ): 
			# print "Into for loop. Now check A = v"
			# print include 1 row of data 
			#remove the example where attribute is false
			# print "compare:", datai[r,A], val, A, r
			if datai[r,A] != val: 
				# print "gonna delete", r,datai[r,A], val
				toDelete.append(r) 
			else:
				noD.append(r)  
		# print "val to exclude and A     ", val, A 
		# print "to Del, nD     ", len(toDelete), len(noD)
		datan = np.delete(datai, toDelete, 0)
		# print "datan after row delete  ", data.shape, datan.shape
		# dan = np.delete(datan, A, 1) 
		# print "dan after A delete(col)", data.shape, dan.shape
		return datan

def chooseFeature(data_input, cant_use):
	""" Cycles through all the attributes and returns the attribute with the
	highest information gain """

	data = data_input[:]
	best_gain = 0.0
	best_attr = None

	# search column by column and save best info gain 
	for r in xrange( len( data[0,:] ) ): 
		# r = one column 0:270
		gain = InfoGain(data, r)
		# print "gain", gain
		if gain > best_gain:
			best_gain = gain
			if r not in cant_use:
				best_attr = r
	return best_attr

def countChildren(nd) :
	if ( not nd.children ):  #dictionaries eval to false if empty
		return 0 
	one = nd.children[1.]
	zer = nd.children[0.] 
	return 1 + countChildren(one) + countChildren(zer)  

def ID34(data, cant_use, depth):
	# print "data", data[:,0]
	# print "data size into id3", data.shape
	if ( all_same( data[:,0] )): #empty case, should never be
		if (data[0,0] == -1.):
			# print "allsame 0.0", data[:,0]
			return nf
		else:
			# print "allsame 1.0", data[:,0] 
			return nt
	else:
		A = chooseFeature(data, cant_use)
		n = node('')
		# print "chose feature", A
		n.data = A
		v = [0.,1.] #keys 
		# print "depth", depth
		if depth > 4:
			c = majority_label(data, 0) #c was being set before id3 
			if c > 0:    
				# print "v1", v[1] 
				n.add_child(v[1], nt)
				n.add_child(v[0], nf) 
			else:
				# print 'v2', v[0]
				n.add_child(v[1],nf)
				n.add_child(v[0], nt)
			return n 
		for e in v: 
			cant_use.append(A)
			Sv = get_subset(data, A, e)
			if Sv.size == 0: 
				# print "sv size == 0"
				c = majority_label(data, 0) #c was being set before id3 
				if c > 0:    
					n.add_child(e,nt)
				else: 
					n.add_child(e,nf) 
			else:
				n.add_child (e, ID34(Sv, cant_use, depth+1))
	return n 

def ID38(data, cant_use, depth):
	# print "data", data[:,0]
	# print "data size into id3", data.shape
	if ( all_same( data[:,0] )): #empty case, should never be
		if (data[0,0] == -1.):
			# print "allsame 0.0", data[:,0]
			return nf
		else:
			# print "allsame 1.0", data[:,0] 
			return nt
	else:
		A = chooseFeature(data, cant_use)
		n = node('')
		# print "chose feature", A
		n.data = A
		v = [0.,1.] #keys 
		# print "depth", depth
		if depth > 8:
			c = majority_label(data, 0) #c was being set before id3 
			if c > 0:    
				# print "v1", v[1] 
				n.add_child(v[1], nt)
				n.add_child(v[0], nf) 
			else:
				# print 'v2', v[0]
				n.add_child(v[1],nf)
				n.add_child(v[0], nt)
			return n 
		for e in v: 
			cant_use.append(A)
			Sv = get_subset(data, A, e)
			if Sv.size == 0: 
				# print "sv size == 0"
				c = majority_label(data, 0) #c was being set before id3 
				if c > 0:    
					n.add_child(e,nt)
				else: 
					n.add_child(e,nf) 
			else:
				n.add_child (e, ID38(Sv, cant_use, depth+1))
	return n 

def ID320(data, cant_use, depth):
	# print "data", data[:,0]
	# print "data size into id3", data.shape
	if ( all_same( data[:,0] )): #empty case, should never be
		if (data[0,0] == -1.):
			# print "allsame 0.0", data[:,0]
			return nf
		else:
			# print "allsame 1.0", data[:,0] 
			return nt
	else:
		A = chooseFeature(data, cant_use)
		n = node('')
		# print "chose feature", A
		n.data = A
		v = [0.,1.] #keys 
		# print "depth", depth
		if depth > 20:
			c = majority_label(data, 0) #c was being set before id3 
			if c > 0:    
				# print "v1", v[1] 
				n.add_child(v[1], nt)
				n.add_child(v[0], nf) 
			else:
				# print 'v2', v[0]
				n.add_child(v[1],nf)
				n.add_child(v[0], nt)
			return n 
		for e in v: 
			cant_use.append(A)
			Sv = get_subset(data, A, e)
			if Sv.size == 0: 
				# print "sv size == 0"
				c = majority_label(data, 0) #c was being set before id3 
				if c > 0:    
					n.add_child(e,nt)
				else: 
					n.add_child(e,nf) 
			else:
				n.add_child (e, ID320(Sv, cant_use, depth+1))
	return n 

def svm (data):
	# cc = np.array([10e6, 10e5, 10e4, 10e3, 10e2, 1])
	cc = np.array([0.1,1,10,100,1000])
	# ro= np.array([1,0.5,0.1,0.01]) 
	ro = np.array([0.001, 0.01,0.1,1])

	epoch = 10
	rows, cols = data.shape
	labels = testdata[ : , 0 ]
	# print "labels", labels.shape, testdata.shape
	# print labels
	s = rows/10
	# print "data", data.shape, data
	# print "labels", labels
	#LET IT BEGIN, CROSS VALIDATION
	# print "cc.size", cc.size
	# print 'ro.size', ro.size
	cRows_rCol = np.zeros([5,4]) 
	for c in xrange(cc.size):
		for r in xrange (ro.size):
			test = np.zeros(10) 
			for k in xrange(1,10):
				np.random.shuffle(data) 
				# print labels.shape #220,
				# print data.shape # 220,270
				d1 = data[0     :1*s]
				d2 = data[1*s:2*s]
				d3 = data[2*s:3*s]
				d4 = data[3*s:4*s]
				d5 = data[4*s:5*s] 
				d6 = data[5*s:6*s]
				d7 = data[6*s:7*s]
				d8 = data[7*s:8*s] 
				d9 = data[8*s:9*s]
				d10 = data[9*s:10*s] 

				dl1 = labels[0   :1*s]
				dl2 = labels[1*s:2*s]
				dl3 = labels[2*s:3*s]
				dl4 = labels[3*s:4*s]
				dl5 = labels[4*s:5*s] 
				dl6 = labels[5*s:6*s]
				dl7 = labels[6*s:7*s]
				dl8 = labels[7*s:8*s] 
				dl9 = labels[8*s:9*s]
				dl10 = labels[9*s:10*s] 
				if k == 1:
					d = np.vstack([d2,d3,d4,d5,d6,d7,d8,d9,d10])
					# print 'd',d.shape
					dt = d1
					# print 'dt', dt.shape
					# print 'dl', dl1.shape
					dy = np.concatenate([dl2,dl3,dl4,dl5,dl6,dl7,dl8,dl9,dl10])
					# print 'dy',dy.shape
					dd = dl1
					# print 'dd',dd.shape
				elif k == 2: 
					d = np.vstack([d1,d3,d4,d5,d6,d7,d8,d9,d10])
					dt = d2
					dy = np.concatenate([dl1,dl3,dl4,dl5,dl6,dl7,dl8,dl9,dl10])
					dd = dl2
				elif k == 3:
					d = np.vstack([d1,d2,d4,d5,d6,d7,d8,d9,d10])
					dt = d3
					dy = np.concatenate([dl1,dl2,dl4,dl5,dl6,dl7,dl8,dl9,dl10])
					dd = dl3
				elif k == 4:
					d = np.vstack([d1,d2,d3,d5,d6,d7,d8,d9,d10])
					dt = d4
					dy = np.concatenate([dl1,dl2,dl3,dl5,dl6,dl7,dl8,dl9,dl10])
					dd = dl4
				elif k == 5:
					d = np.vstack([d1,d2,d3,d4,d6,d7,d8,d9,d10])
					dt = d5
					dy = np.concatenate([dl1,dl2,dl3,dl4,dl6,dl7,dl8,dl9,dl10])
					dd = dl5
				elif k == 6:
					d = np.vstack([d1,d2,d3,d4,d5,d7,d8,d9,d10])
					dt = d6
					dy = np.concatenate([dl1,dl2,dl3,dl4,dl5,dl7,dl8,dl9,dl10])
					dd = dl6
				elif k ==7:
					d = np.vstack([d1,d2,d3,d4,d5,d6,d8,d9,d10])
					dt = d7
					dy = np.concatenate([dl1,dl2,dl3,dl4,dl5,dl6,dl8,dl9,dl10])
					dd = dl7
				elif k == 8:
					d = np.vstack([d1,d2,d3,d4,d5,d6,d7,d9,d10])
					dt = d8
					dy = np.concatenate([dl1,dl2,dl3,dl4,dl5,dl6,dl7,dl9,dl10])
					dd = dl8
				elif k == 9:
					d = np.vstack([d1,d2,d3,d4,d5,d6,d7,d8,d10])
					dt = d9
					dy = np.concatenate([dl1,dl2,dl3,dl4,dl5,dl6,dl7,dl8,dl10])
					dd = dl9
				elif k == 10: 
					d = np.vstack([d1,d2,d3,d4,d5,d6,d7,d8,d9]) 
					dt = d10
					dy = np.concatenate([dl1,dl2,dl3,dl4,dl5,dl6,dl7,dl8,dl9])
					dd = dl10
				else:
					print "error should have a K value" ,k 
				rowd,cold = d.shape
				w = np.zeros(cold) 
				for e in xrange(1,epoch):
					C = cc[c]
					for i in xrange(1,rowd):
						# print "rowd", rowd
						# print "d", d.shape
						# print "dt", dt.shape
						R = ro[r]/(1+ro[r]*i/C)
						x = d[i,:] 
						y = dy[i];
						# print 'xshape', x.shape
						# print 'wshape', w.shape
						# print "trans", np.dot(w.T,x)
						# print "dot", np.dot(w,x) 
						# print 'y is', y.shape
						# print "y is really", y
						if( (y*np.dot(w,x))  <= 1):
							w = w - R*w + R*C*y*x 
						else:
							w = w - R*w 
				count = 0
				# print "w", w 
				for i in xrange(1,dd.size):
					x = dt[i,:]
					# y = dd[i]
					# print"x,y", x, y
					# print w
					# print y*np.dot(w,x) 
					if y*np.dot(w.T,x) > 0:
						# print "count", count
						count +=1.
				test[k] = count/dd.size
			cRows_rCol[c,r] = np.average(test)
	return cRows_rCol
TreeSize = 100
#----------------------------------------------------------------##
''' Here is the main method. 
    1) create 100 trees using random samples of data 
    2) report the accuracy mean and variance of these trees on the test data'''

# create 100 trees w/ train data 
hund = []
for i in xrange(1, TreeSize):
	# print "before", data
	np.random.shuffle(data)
	half = data.shape
	h = half[0]/2
	# print h
	dataShuffle = data[1:h, :]
	# print "dataShuffle", dataShuffle
	if np.array_equal(dataShuffle, data) :
		print "problems, data the same"
	di = []
	tree = ID34(dataShuffle, di, 0)
	hund.append(tree) 
 
#hund = [tree1, tree2, tree3, tree4... treen] 
# traverse tree and look in "inArray" for accuracy 
totalAccuracy = []
NewFeatureSet = np.zeros((74,TreeSize))
#for each tree dred 
for dred in hund:
	fifty = len(hund) 
	acc = []
	# n = dred #change the tree
	space = "   "
	## look through dataset, compare the tree prediction to true label 
	row, col = testdata.shape
	i = 0
	for look in xrange(1, row):
		inArray = testdata[look,:]  #go through each array of features, compare
		# print 'truelabel', inArray
		n = dred
		while True:
			#what value is attribute? 
			x = n.data
			# print "node-Data", x
			if inArray[x] == 1.0:
				n = n.children[1.] #move node down the tree
				# print "%schildren.data"%(space),n.data
				if n == nf or n == nt: #can predict? 
					# print "predicting: ", n.data
					if n.data == inArray[0]:
						acc.append(n.data)
						# print"break1"
						break
					break #done traversing 
				else:
					continue 
			elif inArray[x] == 0.0:
				n = n.children[0.] #move node down the tree
				# print "%schildren.data"%(space), n.data
				if n == nf or n == nt: #can we predict? 
					# print "predicting ",  n.data
					if n.data == inArray[0]:
						acc.append(n.data)
						# print "break0"
						break
					break  
				else:
					continue 
			else:
				print "ERRORS!!! feature not in tree"
				break
			break
		ns = n.data
		if n.data == -1:
			ns = 0.0 
		NewFeatureSet[look,i] = ns
	i += 1 #after looking at each example with this tree move on to next tree 
	# print NewFeatureSet
	ac = float(len(acc))/row #correct per total, each tree acc/ total examples tested
	totalAccuracy.append(ac)
# measure mean accuracy of 100 trees 
print "===================="
AccuracyMean = sum(totalAccuracy)/len(totalAccuracy)
print "AccuracyMean", AccuracyMean
AccuracyVariance = np.var(totalAccuracy) 
print "AccuracyVariance", AccuracyVariance
# print  'how many features?', data.shape
print 'tree depth', countChildren(tree)
results = svm(NewFeatureSet) 
resultsS = results.shape

cc = np.array([0.1,1,10,100,1000])
ro = np.array([0.001, 0.01,0.1,1])
print "results", results
print "r s", results.shape
for i in xrange(0,resultsS[0]):
	for j in xrange(0,resultsS[1]):
		print "%f & %f & %f" %(float(cc[i]),float(ro[j]), float(results[i][j])) 
print "====================s"

#----------------------------------------------------------------##
''' Here is the main method. 
    1) create 100 trees using random samples of data 
    2) report the accuracy mean and variance of these trees on the test data'''

# create 100 trees w/ train data 
hund = []
for i in xrange(1, TreeSize):
	# print "before", data
	np.random.shuffle(data)
	half = data.shape
	h = half[0]/2
	# print h
	dataShuffle = data[1:h, :]
	# print "dataShuffle", dataShuffle
	if np.array_equal(dataShuffle, data) :
		print "problems, data the same"
	di = []
	tree = ID38(dataShuffle, di, 0)
	hund.append(tree) 
 
#hund = [tree1, tree2, tree3, tree4... treen] 
# traverse tree and look in "inArray" for accuracy 
totalAccuracy = []
NewFeatureSet = np.zeros((74,TreeSize))
#for each tree dred 
for dred in hund:
	fifty = len(hund) 
	acc = []
	# n = dred #change the tree
	space = "   "
	## look through dataset, compare the tree prediction to true label 
	row, col = testdata.shape
	i = 0
	for look in xrange(1, row):
		inArray = testdata[look,:]  #go through each array of features, compare
		# print 'truelabel', inArray
		n = dred
		while True:
			#what value is attribute? 
			x = n.data
			# print "node-Data", x
			if inArray[x] == 1.0:
				n = n.children[1.] #move node down the tree
				# print "%schildren.data"%(space),n.data
				if n == nf or n == nt: #can predict? 
					# print "predicting: ", n.data
					if n.data == inArray[0]:
						acc.append(n.data)
						# print"break1"
						break
					break #done traversing 
				else:
					continue 
			elif inArray[x] == 0.0:
				n = n.children[0.] #move node down the tree
				# print "%schildren.data"%(space), n.data
				if n == nf or n == nt: #can we predict? 
					# print "predicting ",  n.data
					if n.data == inArray[0]:
						acc.append(n.data)
						# print "break0"
						break
					break  
				else:
					continue 
			else:
				print "ERRORS!!! feature not in tree"
				break
			break
		ns = n.data
		if n.data == -1:
			ns = 0.0 
		NewFeatureSet[look,i] = ns
	i += 1 #after looking at each example with this tree move on to next tree 
	# print NewFeatureSet
	ac = float(len(acc))/row #correct per total, each tree acc/ total examples tested
	totalAccuracy.append(ac)
# measure mean accuracy of 100 trees 
print "===================="
AccuracyMean = sum(totalAccuracy)/len(totalAccuracy)
print "AccuracyMean", AccuracyMean
AccuracyVariance = np.var(totalAccuracy) 
print "AccuracyVariance", AccuracyVariance
# print  'how many features?', data.shape
print 'tree depth', countChildren(tree) 
results = svm(NewFeatureSet) 
resultsS = results.shape

cc = np.array([0.1,1,10,100,1000])
ro = np.array([0.001, 0.01,0.1,1])
print "results", results
print "r s", results.shape
for i in xrange(0,resultsS[0]):
	for j in xrange(0,resultsS[1]):
		print "%f & %f & %f" %(float(cc[i]),float(ro[j]), float(results[i][j])) 
print "====================s"
#----------------------------------------------------------------##
''' Here is the main method. 
    1) create 100 trees using random samples of data 
    2) report the accuracy mean and variance of these trees on the test data'''

# create 100 trees w/ train data 
hund = []
for i in xrange(1, TreeSize):
	# print "before", data
	np.random.shuffle(data)
	half = data.shape
	h = half[0]/2
	# print h
	dataShuffle = data[1:h, :]
	# print "dataShuffle", dataShuffle
	if np.array_equal(dataShuffle, data) :
		print "problems, data the same"
	di = []
	tree = ID320(dataShuffle, di, 0)
	hund.append(tree) 
 
#hund = [tree1, tree2, tree3, tree4... treen] 
# traverse tree and look in "inArray" for accuracy 
totalAccuracy = []
NewFeatureSet = np.zeros((74,TreeSize))
#for each tree dred 
for dred in hund:
	fifty = len(hund) 
	acc = []
	# n = dred #change the tree
	space = "   "
	## look through dataset, compare the tree prediction to true label 
	row, col = testdata.shape
	i = 0
	for look in xrange(1, row):
		inArray = testdata[look,:]  #go through each array of features, compare
		# print 'truelabel', inArray
		n = dred
		while True:
			#what value is attribute? 
			x = n.data
			# print "node-Data", x
			if inArray[x] == 1.0:
				n = n.children[1.] #move node down the tree
				# print "%schildren.data"%(space),n.data
				if n == nf or n == nt: #can predict? 
					# print "predicting: ", n.data
					if n.data == inArray[0]:
						acc.append(n.data)
						# print"break1"
						break
					break #done traversing 
				else:
					continue 
			elif inArray[x] == 0.0:
				n = n.children[0.] #move node down the tree
				# print "%schildren.data"%(space), n.data
				if n == nf or n == nt: #can we predict? 
					# print "predicting ",  n.data
					if n.data == inArray[0]:
						acc.append(n.data)
						# print "break0"
						break
					break  
				else:
					continue 
			else:
				print "ERRORS!!! feature not in tree"
				break
			break
		ns = n.data
		if n.data == -1:
			ns = 0.0 
		NewFeatureSet[look,i] = ns
	i += 1 #after looking at each example with this tree move on to next tree 
	# print NewFeatureSet
	ac = float(len(acc))/row #correct per total, each tree acc/ total examples tested
	totalAccuracy.append(ac)
# measure mean accuracy of 100 trees 
print "===================="
AccuracyMean = sum(totalAccuracy)/len(totalAccuracy)
print "AccuracyMean", AccuracyMean
AccuracyVariance = np.var(totalAccuracy) 
print "AccuracyVariance", AccuracyVariance
# print  'how many features?', data.shape
print 'tree depth', countChildren(tree) 
results = svm(NewFeatureSet) 
resultsS = results.shape

cc = np.array([0.1,1,10,100,1000])
ro = np.array([0.001, 0.01,0.1,1])
print "results", results
print "r s", results.shape
for i in xrange(0,resultsS[0]):
	for j in xrange(0,resultsS[1]):
		print "%f & %f & %f" %(float(cc[i]),float(ro[j]), float(results[i][j])) 
print "====================s"


	
