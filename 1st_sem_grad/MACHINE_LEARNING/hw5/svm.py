import math
import numpy as np



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

# print len(badgesTrainF)
data = np.zeros((220,271)) 
# labels_array = []

# 220 rows, 271 columns
#convert data into dictionary format, drop labels 
i = 0 
for x in badgesTestF:
	j = 0
	for y in x: 
		L = y.split(":")
		if len(L) < 2:
			data[i,j] = float(L[0])
		else:
			data[i,j] = float(L[1])
		j += 1
	i += 1

# print "data before rid", data.shape
# ##GET RID OF FEATRURES THAT DONT APPEAR 
# toD= []
# for A in xrange( len( data[1,:] ) ):#each column A
# 	print A 
# 	if all_same( data[:,A] ):  #all rows, column A
# 		toD.append(A) 

# data = np.delete(data, toD, 1) #see ya	

#is there a problem with rid method? 
# for A in xrange( len( data[1,:] ) ):#each column A
# 	if all_same( data[:,A] ):  #all rows, column A
# 		print "some same left"	
# print "data after rid", data.shape
# print data


# print data_input_array 220 rows x 270 columns
# print len(data_input_array[1])
# print data_input_array[1]



cc = np.array([0.1,1,10,100,1000])
ro = np.array([0.001, 0.01,0.1,1])

epoch = 10
rows, cols = data.shape
s = rows/10

#LET IT BEGIN, CROSS VALIDATION
# print "cc.size", cc.size
# print 'ro.size', ro.size
cRows_rCol = np.zeros([5,4]) 
for c in xrange(cc.size):
	for r in xrange (ro.size):
		test = np.zeros(10) 
		for k in xrange(1,10):
			np.random.shuffle(data) 
			labels = data[:,0]
			# print labels.shape #220,
			data = data [:, 1:]
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

			dl1 = labels[0     :1*s]
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
			for i in xrange(1,dd.size):
				x = dt[i,:]
				y = dd[i]
				if y*np.dot(w.T,x) > 0:
					count +=1 
			test[k] = count
		cRows_rCol[c,r] = np.average(test) 

results = cRows_rCol
resultsS = results.shape
cc = np.array([0.1,1,10,100,1000])
ro = np.array([0.001, 0.01,0.1,1])
print "results", results
print "r s", results.shape
for i in xrange(0,resultsS[0]):
	for j in xrange(0,resultsS[1]):
		print "%f & %f & %f" %(float(cc[i]),float(ro[j]), float(results[i][j])) 


