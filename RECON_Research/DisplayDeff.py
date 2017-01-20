import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as im
plt.ion()
import PyCA.Core as ca 
import PyCACalebExtras.Display as cd
import PyCACalebExtras.Common as cc







'''Input to Display------------------------------------------------------------------------------------------'''

#Difformation
# phi = cc.LoadMHA('/home/sci/benl/Data_Empire_Amit/Empire_LA/Phi/13_Fixed.mhd', mType=ca.MEM_HOST)
# #Moving
# M = cc.LoadMHA('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/13_Moving.mhd', mType=ca.MEM_HOST)
# #Fixed 
# F = cc.LoadMHA('/home/sci/benl/Data_Empire_Amit/Empire_LA/ResampleWorld/Scans/13_Fixed.mhd',mType=ca.MEM_HOST)

phi = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/final1/step_5.000000e-03sig_5.000000e-01case01_T09Images/phicase01_T09', mType=ca.MEM_HOST)
#Moving
M = cc.LoadMHA('/home/sci/benl/Data_DIR/Circular/finalImage0', mType=ca.MEM_HOST)
#Fixed 
F = cc.LoadMHA('/usr/sci/projects/DIR-lab/4DCT/MHAImages/Case01/Images/case01_T00',mType=ca.MEM_HOST)

'''------------------------------------------------------------------------------------------'''











Mov = M
Fix = F 
# Mov = cc.Downsample(M,2) 
# Fix = cc.Downsample(F,2) 
print phi
print Mov
print Fix 
fix = Fix.asnp()
mov = Mov.asnp()

class IndexTracker(object):
    '''Keeps track of the current image being displayed'''
    def __init__(self,X,mov,phi,ax2,ax3,ax4,ax,ax1b,axc):
        self.ax = ax
        self.axa = ax1b
        self.axb = axc
        self.ax2 = ax2
        self.ax3 = ax3
        self.ax4 = ax4

        self.X = X
        self.slices = X.shape[1]
        self.ind = self.slices/2
        self.inda = X.shape[0]/2
        self.indb = X.shape[2]/2
        
        self.mov = mov
        self.slices2 = mov.shape[1]
        self.indy = self.slices2/2
        self.indx = mov.shape[0]/2
        self.indz = mov.shape[2]/2


        self.InPhi = [0,0,0]
        self.InPhiy = [0,0,0]
        self.InPhiz = [0,0,0] 

        self.goTo = [0,0,0] 
        self.phi = phi
        lw = 0.6      
        self.lx = self.ax2.axhline(color='r', linewidth = lw) 
        self.ly = self.ax2.axvline(color='r', linewidth = lw) 
        self.kx = self.ax3.axhline(color='r', linewidth = lw) 
        self.ky = self.ax3.axvline(color='r', linewidth = lw) 
        self.jx = self.ax4.axhline(color='r', linewidth = lw) 
        self.jy = self.ax4.axvline(color='r', linewidth = lw) 
        
        self.dx = self.ax.axvline(color='b', linewidth = lw) 
        self.dy = self.ax.axhline(color='b', linewidth = lw)
        self.hx = self.axa.axvline(color='b', linewidth = lw) 
        self.hy = self.axa.axhline(color='b', linewidth = lw) 
        self.gx = self.axb.axvline(color='b', linewidth = lw) 
        self.gy = self.axb.axhline(color='b', linewidth = lw) 

        # self.dx = self.ax.plot('b', linewidth = lw) 
        # self.dy = self.ax.plot('b', linewidth = lw)
        # self.hx = self.axa.plot('b', linewidth = lw) 
        # self.hy = self.axa.plot('b', linewidth = lw) 
        # self.gx = self.axb.plot('b', linewidth = lw) 
        # self.gy = self.axb.plot('b', linewidth = lw) 

        self.im =  self.ax.imshow(self.X[:,self.ind,:],cmap='gray')
        self.ima = self.axa.imshow(self.X[self.inda,:,:],cmap='gray')
        self.imb = self.axb.imshow(self.X[:,:,self.indb],cmap='gray')
        self.im2 = self.ax2.imshow(self.mov[:,self.indy,:],cmap='gray')
        self.im3 = self.ax3.imshow(self.mov[self.indx,:,:],cmap='gray')
        self.im4 = self.ax4.imshow(self.mov[:,:,self.indz],cmap='gray')  

        self.ax.invert_yaxis(),self.axa.invert_yaxis(),self.axb.invert_yaxis() 
        self.ax2.invert_yaxis(),self.ax3.invert_yaxis(),self.ax4.invert_yaxis()
        self.update()

    def onKeyPress(self,event):
        '''Defines what happens upon pressing up or down arrow'''
        print "onkeypress"
        if event.key == 'w':
            self.ind = np.clip(self.ind+1, 0, self.slices-1)
        elif event.key == 'e':
            self.ind = np.clip(self.ind-1, 0, self.slices-1)
        self.update()

    def onclick(self,event):
        x = int(np.round(event.xdata)) 
        y = int(np.round(event.ydata))
        print x,y  
        print 'button=%d, x=%d, y=%d, xdata=%f, ydata=%f'%(
            event.button, event.x, event.y, event.xdata, event.ydata)
        self.goTo = [x,y]
        fx,fy = fig.transFigure.inverted().transform((event.x,event.y))
        b1 = self.ax.get_position()
        b2 = self.axa.get_position()
        b3 = self.axb.get_position() 
        if b1.contains(fx,fy):
            print "b1"
            self.inda = y
            self.indb = x
            self.gety() 
        elif b2.contains(fx,fy):
            print "b2"
            self.ind = y
            self.indb = x
            self.getx()
        elif b3.contains(fx,fy):
            print "b3"
            self.ind = x
            self.inda = y
            self.getz()
        else:
            print "not in figure"
        self.update()

    def update(self):
        '''Update the current slice'''
        # self.ax2.set_title('Moving %s'%(self.InPhi) )

        self.lx.set_ydata(self.InPhi[0])
        self.ly.set_xdata(self.InPhi[2])
        self.kx.set_ydata(self.InPhi[1])
        self.ky.set_xdata(self.InPhi[2])      
        self.jx.set_ydata(self.InPhi[0])
        self.jy.set_xdata(self.InPhi[1])


        
        print self.goTo, self.ind
        self.dy.set_ydata(self.inda)
        self.dx.set_xdata(self.indb)

        self.hy.set_ydata(self.ind)
        self.hx.set_xdata(self.indb)

        self.gy.set_ydata(self.inda)
        self.gx.set_xdata(self.ind)

     



        self.im.set_data(self.X[:,self.ind,:])
        self.ax.set_title(self.ind)
        self.ima.set_data(self.X[self.inda,:,:])
        self.axa.set_title(self.inda)
        self.imb.set_data(self.X[:,:,self.indb])
        self.axb.set_title(self.indb)

        self.im2.set_data(self.mov[:,self.InPhi[1],:])
        self.ax2.set_title(self.InPhi[1])
        self.im3.set_data(self.mov[self.InPhi[0],:,:])
        self.ax3.set_title(self.InPhi[0])
        self.im4.set_data(self.mov[:,:,self.InPhi[2]])
        self.ax4.set_title(self.InPhi[2])

        self.im.axes.figure.canvas.draw()
        self.im2.axes.figure.canvas.draw() 
        self.im3.axes.figure.canvas.draw()
        self.im4.axes.figure.canvas.draw()
        self.ima.axes.figure.canvas.draw()
        self.imb.axes.figure.canvas.draw() 

    def getx(self):
        pnt = phi.get(self.inda, self.goTo[1], self.goTo[0])
        self.InPhi = [int(round(pnt.x)),int(round(pnt.y)),int(round(pnt.z))]
    def gety(self):
        pnt = phi.get(self.goTo[1], self.ind, self.goTo[0])
        self.InPhi = [int(round(pnt.x)),int(round(pnt.y)),int(round(pnt.z))]
    def getz(self):
        pnt = phi.get(self.goTo[1], self.goTo[0], self.indb)
        self.InPhi = [int(round(pnt.x)),int(round(pnt.y)),int(round(pnt.z))]


fig = plt.figure()
axa = fig.add_subplot(231)
ax2 = fig.add_subplot(234)

axb = fig.add_subplot(232)
ax3 = fig.add_subplot(235)

axc = fig.add_subplot(233)
ax4 = fig.add_subplot(236) 

tracker = IndexTracker(mov,fix,phi,ax2,ax3,ax4,axa,axb,axc)
fig.canvas.mpl_connect('key_press_event',tracker.onKeyPress)
fig.canvas.mpl_connect('button_press_event',tracker.onclick)

plt.show()
