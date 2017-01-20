import numpy as np
import matplotlib.pyplot as plt
import PyCA.Core as ca 
import PyCACalebExtras.Display as cd
import PyCACalebExtras.Common as cc
import matplotlib.image as im 


#Difformation
# phi = cc.LoadMHA('/home/sci/benl/Data_DIR/one_five/Results/Phi/case01_T05.mha', mType=ca.MEM_HOST)
phi = cc.LoadMHA('/home/sci/crottman/dir/009step0.005_sigma0.5_niters5000/phi.mha',mType=ca.MEM_HOST) 
#Moving
M = cc.LoadMHA('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images/case01_T05.mha', mType=ca.MEM_HOST)
#Fixed 
F = cc.LoadMHA('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images/case01_T00.mha',mType=ca.MEM_HOST)
landmarks0 = np.load('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/ExtremePhases/case01_T00_corr.npy')
landmarks5 = np.load('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/ExtremePhases/case01_T05_corr.npy')


print "loading done"

fix = F.asnp()
mov = M.asnp() 

x = [i[2] for i in landmarks5]
y = [j[1] for j in landmarks5]
x0= [i[2] for i in landmarks0]
y0= [j[1] for j in landmarks0]

fig = plt.figure()
ax1 = fig.add_subplot(131)
# cd.DispImage(F,dim= 'x',sliceIdx= 126,newFig=False) 
ax1.imshow(fix[170,:,:],cmap = 'gray') 
ax1.hold(True)
ax1.scatter(x,y,c='b')
ax1.scatter(x0,y0,c='r')


x = [i[2] for i in landmarks5]
y = [j[0] for j in landmarks5] 
x0= [i[2] for i in landmarks0]
y0= [j[0] for j in landmarks0]

ax2 = fig.add_subplot(132)
# cd.DispImage(F,dim= 'y',sliceIdx= 126,newFig = False) 
ax2.imshow(fix[:,150,:],cmap='gray')
ax2.hold(True)
ax2.scatter(x,y,c='b')
ax2.scatter(x0,y0,c='r') 

x = [i[1] for i in landmarks5]
y = [j[0] for j in landmarks5] 
x0= [i[1] for i in landmarks0]
y0= [j[0] for j in landmarks0]

ax3 = fig.add_subplot(133)
#cd.DispImage(F,dim= 'z',sliceIdx= 126,newFig=False) 
ax3.imshow(fix[:,:,70]) 
ax3.hold(True)
ax3.scatter(x,y,c='b')
ax3.scatter(x0,y0,c='r') 


plt.figure() 
diff_l = []
for lm0, lm5 in zip(landmarks0, landmarks5):
	d = np.sqrt((lm5[0]*M.spacing().x - lm0[0]*F.spacing().x)**2 + \
				(lm5[1]*M.spacing().y - lm0[1]*F.spacing().y)**2 + \
				(lm5[2]*M.spacing().z - lm0[2]*F.spacing().z)**2)
	print d, lm0, lm5 
	diff_l.append(np.array(d,dtype=float)) 
print "phi and lm5 --------------------------"
diff_def = []

for lm, lm5 in zip(landmarks0, landmarks5):
	
	InPhi = phi.get(lm[0],lm[1],lm[2]) 
	d = np.sqrt((M.spacing().x*(round(InPhi.x) - lm5[0]))**2 + \
				(M.spacing().y*(round(InPhi.y) - lm5[1]))**2 + \
				(M.spacing().z*(round(InPhi.z) - lm5[2]))**2) 
	# print d 
	diff_def.append(np.array(d,dtype=float)) 


x = range(0,len(diff_l))

plt.scatter(x,diff_l,c='r',label='distances between sets of landmark5 and landmark0')
plt.hold(True) 
plt.scatter(x,diff_def,c='b', label='set of distances between landmark5 and phi(landmark0)') 
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
          fancybox=True, shadow=True, ncol=5) 


plt.figure() 

plt.scatter(x,diff_l,c='g')
plt.title('Landmark diff, in millimeters')
plt.axhline(np.mean(d),label='Mean = %s std = %s'%(np.mean(diff_l),np.std(diff_l)))
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
          fancybox=True, shadow=True, ncol=5) 

plt.figure() 

plt.scatter(x,diff_def,c='g')
plt.title('Phi(landmark0) vs landmark5, in millimeters')
plt.axhline(np.mean(d),label='Mean = %s std = %s'%(np.mean(diff_def),np.std(diff_def)))
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05),
          fancybox=True, shadow=True, ncol=5) 

print "Landmarks ", np.mean(diff_l), np.std(diff_l) 
print "Diff Landmarks", np.mean(diff_def, dtype=np.float64),np.std(diff_def,dtype=np.float64) 