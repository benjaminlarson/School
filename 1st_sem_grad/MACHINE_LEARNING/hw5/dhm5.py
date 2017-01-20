
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
nt.data = 1
nf = node('')
nf.data = -1 #0.0 

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

data = {}
for i in badgesTrainF:
	if i[0] == '+1' or i[0] == '-1':
		data[] = i[0]
		data['value'] = i[1:]
print data.keys()
print data

# def InfoGain(data, target):
# 	subset_entropy = 0.0
# 	plus= 0.0
# 	neg = 0.0 
# 	d = len(data[:,target]) 
# 	for r in xrange(len(data[:,target])): # each example in target column
# 		#for entropy of system -1 etc...
# 		y = np.where(data[:,target] == -1) 
# 		if(  len(y[0] ) > 0 ):
# 			if(data[r,target] == 1.):
# 				# print 'data compare E pos', data[r,0], data[r,target] 
# 				plus += 1. 
# 			elif (data[r,target] == 1.):
# 				# print 'data compare E neg', data[r,0], data[r,target] 
# 				neg += 1.    
# 			else:
# 				if data[r,target] != -1.:
# 					print "system entropy ERROR", data[r,target], data[r,0] 
# 					print "datatarget                ", data[r,target] 
# 		else:
# 			#normal Search
# 			if(data[r,0] == 1. and data[r,target] == 1.):
# 				# print 'data compare E pos', data[r,0], data[r,target] 
# 				plus += 1. 
# 			elif (data[r,0] == -1. and data[r,target] == 1.):
# 				# print 'data compare E neg', data[r,0], data[r,target] 
# 				neg += 1.    
# 			else:
# 				if data[r,target] != 0.:
# 					print "error in findEntropy ", data[r,target], data[r,0] 
# 					print "datatarget                ", data[r,target] 
# 	subset_entropy = (plus/d) * findEntropy(data,target) + (neg/d)*findEntropy(data,target)
# 	if subset_entropy == 0.0:
# 		return 0.0 
# 	return (findEntropy(data, 0) - subset_entropy)

# ## Only checks for 1 and 0 values. If there are more values this needs to change 
# def findEntropy(data, target):
# 	# print data
# 	entropy = 0.0
# 	plus= 0.0
# 	neg = 0.0 
# 	d = len(data[:,target] ) 
# 	for r in xrange(len(data[:,target])): # each example in target column
# 		#for entropy of system -1 etc...
# 		y = np.where(data[:,target] == -1) 
# 		if(  len(y[0] ) > 0 ):
# 			if(data[r,target] == 1.):
# 				# print 'data compare E pos', data[r,0], data[r,target] 
# 				plus += 1. 
# 			elif (data[r,target] == 1.):
# 				# print 'data compare E neg', data[r,0], data[r,target] 
# 				neg += 1.    
# 			else:
# 				if data[r,target] != -1.:
# 					print "system entropy ERROR", data[r,target], data[r,0] 
# 					print "datatarget                ", data[r,target] 
# 		else:
# 			#normal Search
# 			if(data[r,0] == 1. and data[r,target] == 1.):
# 				# print 'data compare E pos', data[r,0], data[r,target] 
# 				plus += 1. 
# 			elif (data[r,0] == -1. and data[r,target] == 1.):
# 				# print 'data compare E neg', data[r,0], data[r,target] 
# 				neg += 1.    
# 			else:
# 				if data[r,target] != 0.:
# 					print "error in findEntropy ", data[r,target], data[r,0] 
# 					print "datatarget                ", data[r,target] 
# 	if plus == 0.:
# 		pl = 0.
# 	else:
# 		f = plus/d
# 		# print "f", f 
# 		pl = -f* np.log2(f)
# 	if neg == 0.:
# 		nl = 0.
# 	else:
# 		f = neg/d 
# 		# print "f", f 
# 		nl = -f* np.log2(f)
# 	# print "pl, nl", pl, nl
# 	entropy = pl + nl
# 	# print"entropy", target, entropy 
# 	return  entropy

# def readFeatures(F):
# 	with open(F) as f:
# 		lines=f.read().splitlines()
# 	numbers=[]
# 	for e in lines:
# 		temp = e.strip().split()
# 		numbers.append(temp)
# 	return numbers

# def majority_label(data, target):
# 	#data is a list of dictionaries
# 	plus= 0.0
# 	neg = 0.0 
# 	for r in xrange(len(data[:,target])): # each example in target column
# 		# if(data[r,0] == 1. and data[r,target] == 1.):
# 		if (data[r,0]  > 0):
# 			plus += 1 
# 		# if data[r,0] == 0. and data[r,target] == 1.:
# 		if (data[r,0] < 0 ):
# 			neg += 1.  
# 	if (neg >= plus):
# 		return -1. 
# 	else: 
# 		return 1.

# def get_subset( data, A, val):
# 	""" Returns a list of all the records in data with the value of attribute
# 	matching the given value """
# 	datai = data [:]
# 	toDelete =[]
# 	noD = []
# 	if not datai.any():
# 		print "not dataany"
# 		return datai
# 	else:
# 		for r in xrange( len( datai[:,A] ) ): 
# 			# print "Into for loop. Now check A = v"
# 			# print include 1 row of data 
# 			#remove the example where attribute is false
# 			# print "compare:", datai[r,A], val, A, r
# 			if datai[r,A] != val: 
# 				# print "gonna delete", r,datai[r,A], val
# 				toDelete.append(r) 
# 			else:
# 				noD.append(r)  
# 		print "val to exclude and A     ", val, A 
# 		print "to Del, nD     ", len(toDelete), len(noD)
# 		datan = np.delete(datai, toDelete, 0)
# 		print "datan after row delete  ", data.shape, datan.shape
# 		dan = np.delete(datan, A, 1) 
# 		print "dan after A delete(col)", data.shape, dan.shape
# 		return dan 

# def chooseFeature(data_input):
# 	""" Cycles through all the attributes and returns the attribute with the
# 	highest information gain """

# 	data = data_input[:]
# 	best_gain = 0.0
# 	best_attr = None

# 	# search column by column and save best info gain 
# 	for r in xrange( len( data[0,:] ) ): 
# 		# r = one column 0:270
# 		gain = InfoGain(data, r)
# 		# print "gain", gain
# 		if gain > best_gain:
# 			best_gain = gain
# 			best_attr = r

# 		# print "gain", gain
# 	return best_attr

# def countChildren(nd) :
# 	if ( not nd.children ):  #dictionaries eval to false if empty
# 		return 0 
# 	one = nd.children[1.]
# 	zer = nd.children[0.] 
# 	return 1 + countChildren(one) + countChildren(zer)  

# def ID3(data, depth):
# 	# print "data", data[:,0]
# 	# print "data size into id3", data.shape
# 	if ( all_same( data[:,0] )): #empty case, should never be
# 		if (data[0,0] == -1.):
# 			# print "allsame 0.0", data[:,0]
# 			return nf
# 		else:
# 			# print "allsame 1.0", data[:,0] 
# 			return nt
# 	else:
# 		A = chooseFeature(data)
# 		n = node('')
# 		# print "chose feature", A
# 		n.data = A
# 		v = [0.,1.] #keys 
# 		# print "depth", depth
# 		if depth > 4:
# 			c = majority_label(data, 0) #c was being set before id3 
# 			if c > 0:    
# 				# print "v1", v[1] 
# 				n.add_child(v[1], nt)
# 				n.add_child(v[0], nf) 
# 			else:
# 				# print 'v2', v[0]
# 				n.add_child(v[1],nf)
# 				n.add_child(v[0], nt)
# 			return n 
# 		for e in v: 
# 			Sv = get_subset(data, A, e)
# 			if Sv.size == 0: 
# 				# print "sv size == 0"
# 				c = majority_label(data, 0) #c was being set before id3 
# 				if c > 0:    
# 					n.add_child(e,nt)
# 				else: 
# 					n.add_child(e,nf) 
# 			else:
# 				n.add_child (e, ID3(Sv, depth+1))
# 	return n 


# #----------------------------------------------------------------##
# ''' Here is the main method. 
#     1) create 100 trees using random samples of data 
#     2) report the accuracy mean and variance of these trees on the test data'''

# # create 100 trees w/ train data 
# hund = []
# for i in xrange(1, 4):
# 	# print "before", data
# 	np.random.shuffle(data)
# 	half = data.shape
# 	h = half[0]/2
# 	# print h
# 	dataShuffle = data[1:h, :]
# 	# print "dataShuffle", dataShuffle
# 	if np.array_equal(dataShuffle, data) :
# 		print "problems, data the same"
# 	tree = ID3(dataShuffle, 0)
# 	hund.append(tree) 
	
# for i in hund :
# 	space = " "
# 	print "NEW" 
# 	while (i != nt and i != nf):
# 		i = i.children[0]
# 		print 'root node', i.data 
# 		if (i != nt and i != nf):
# 			print '%schildren0'%(space), i.children[0.].data
# 			print '%schildren1'%(space), i.children[1.].data
# 	space = space + "   "

# if len(hund) != 3: 
# 	print "size error for hundred trees", len(hund)
 
# #hund = [tree1, tree2, tree3, tree4... treen] 
# # traverse tree and look in "inArray" for accuracy 
# totalAccuracy = []
# #for each tree dred 
# for dred in hund:
# 	fifty = len(hund) 
# 	acc = []
# 	n = dred #change the tree
	
# 	## look through dataset, compare the tree prediction to true label 
# 	row, col = testdata.shape
# 	for look in xrange(1, row):
# 		inArray = testdata[look,:]  #go through each array of features, compare
# 		# print 'truelabel', inArray[0]
# 		n = tree
# 		while True:
# 			#what value is attribute? 
# 			x = n.data
# 			if inArray[x] == 1.0:
# 				n = n.children[1.] #move node down the tree
# 				if n == nf or n == nt: #can predict? 
# 					# print "predicting: ", n.data
# 					if n.data == inArray[0]:
# 						acc.append(n.data)
# 					break #done traversing 
# 				else:
# 					continue 
# 			elif inArray[x] == 0.0:
# 				n = n.children[0.] #move node down the tree
# 				if n == nf or n == nt: #can we predict? 
# 					# print "predicting ",  n.data
# 					if n.data == inArray[0]:
# 						acc.append(n.data)
# 					break  
# 				else:
# 					continue 
# 			else:
# 				print "ERRORS!!! feature not in tree"
# 				break
# 			break
# 	ac = float(len(acc))/row #correct per total, each tree acc/ total examples tested
# 	totalAccuracy.append(ac)
# # measure mean accuracy of 100 trees 
# print "totalAccuracy", totalAccuracy
# AccuracyMean = sum(totalAccuracy)/len(totalAccuracy)
# print "AccuracyMean", AccuracyMean
# AccuracyVariance = np.var(totalAccuracy) 
# print "AccuracyVariance", AccuracyVariance
# # print  'how many features?', data.shape
# print 'tree depth', countChildren(tree) 

