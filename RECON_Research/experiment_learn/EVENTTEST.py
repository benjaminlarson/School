# from matplotlib import pyplot as plt

# class LineBuilder:
#     def __init__(self, line):
#         self.line = line
#         self.xs = list(line.get_xdata())
#         self.ys = list(line.get_ydata())
#         self.cid = line.figure.canvas.mpl_connect('button_press_event', self)

#     def __call__(self, event):
#         print 'click', event
#         if event.inaxes!=self.line.axes: return
#         self.xs.append(event.xdata)
#         self.ys.append(event.ydata)
#         self.line.set_data(self.xs, self.ys)
#         self.line.figure.canvas.draw()

# fig = plt.figure()
# ax = fig.add_subplot(111)
# ax.set_title('click to build line segments')
# line, = ax.plot([0], [0])  # empty line
# linebuilder = LineBuilder(line)

# plt.show()
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as im

import PyCA.Core as ca 
import PyCACalebExtras.Display as cd
import PyCACalebExtras.Common as cc



phi = cc.LoadMHA('/home/sci/benl/Data_Empire_Amit/Empire_LA/Phi/1.mha', mType=ca.MEM_HOST)
M = cc.LoadMHA('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/01_Moving.mhd', mType=ca.MEM_HOST)
F = cc.LoadMHA('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/01_Fixed.mhd',mType=ca.MEM_HOST)
Mov = cc.Downsample(M,2) 
Fix = cc.Downsample(F,2) 
print phi
print Mov
print Fix 
plt.figure() 
fixed = Fix.asnp()
moving = Mov.asnp()




fig = plt.figure()
ax = fig.add_subplot(111)
# ax.set_title('click on points')
print np.squeeze(fixed[:,100,:]).shape
print fixed[:,100,:].shape 
fix = ax.imshow(np.squeeze(fixed[:,100,:]), interpolation='nearest')  # 5 points tolerance
# ax2 = fig.add_subplot(122)
# mov = ax2.imshow(np.squeeze(moving[:,100,:])) 

# ax = fig.add_subplot(111)
# ax.set_title('click on points')
# line, = ax.plot(np.random.rand(100), 'o', picker=5)  # 5 points tolerance

def onpick(event):
    thisline = event.artist
    xdata = thisline.get_xdata()
    ydata = thisline.get_ydata()
    ind = event.ind
    print 'onpick points:', zip(xdata[ind], ydata[ind])

fig.canvas.mpl_connect('pick_event', onpick)

plt.show()