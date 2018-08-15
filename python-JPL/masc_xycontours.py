

import numpy as np
import os
import matplotlib
from pylab import *
import matplotlib.pyplot as plt
from numpy import linalg as LA
import scipy
from scipy.io.idl import readsav
import pdb


def set_levels(data):
  """
  Originally designed for data presented as a histogram!
  I need to convert XY tuples into a 2D histogram FIRST
  
  Figure out how this function will handle the histogram of MASC positions
  """
  #min_val = find_min(data,5000)
  max_val = max([max(item) for item in data])
  min_val = max_val*.05
  #min_val = 1
  levels = np.linspace(min_val,max_val,1000)
  #levels = np.logspace(min_val,max_val,num =10)
  return levels
	
	
def composite_contour(outlier,axarr,counter,levels,AreR,AspR,data,alpha,beta,sig_adj,part_size):
#(outlier,axarr,counter,levels,AreR,AspR,data,alpha,beta,sig_adj,Lbound,Rbound,bins,Ntotal,part_size)
    sizer = np.shape(axarr)[1]
    if outlier == 1:
        axarr[counter/sizer,counter%sizer].contourf(AreR,AspR,data,levels=levels)
        axarr[counter/sizer,counter%sizer].plot(AreR,alpha*AreR+beta,'k')
        axarr[counter/sizer,counter%sizer].set_xlim((0.,1.0))
        axarr[counter/sizer,counter%sizer].set_ylim((0.,1.0))
        axarr[counter/sizer,counter%sizer].xaxis.set_ticks(np.array([0.2,0.4,0.6,0.8]))
        axarr[counter/sizer,counter%sizer].yaxis.set_ticks(np.array([0.2,0.4,0.6,0.8]))
        axarr[counter/sizer,counter%sizer].plot(AreR,alpha*AreR+beta+sig_adj,'r')
        axarr[counter/sizer,counter%sizer].plot(AreR,alpha*AreR+beta-sig_adj,'r')
        axarr[counter/sizer,counter%sizer].set_title(str(int(part_size))+'microns')
        """
		The code above was used to create a huge figure with several subplots
		axarr is a subplot figure created by:
		fig, axarr = plt.subplots(6,4,sharex='col')
		Not sure what fig, does
		"""
		
def zone_def_plot(ex_data,AreR,AspR,ex_levels,alpha,beta,sig_adj,Rbound,Lbound):
  """
	Important Notes about the function below
	f5 is necessary to initiate the figure space
	ax5 is the variable that holds all plotting information
	countourf needs x-space and y-space variables that set up the axes
	          data WAS a 2D histogram with numbers of points within bins
			  levels is a list of level curves to draw
    
	colorbar??
	con2   = ax2.contourf(blah...)
	cb=ax2.figure.colorbar(con2)
    cb.ax.tick_params(labelsize=16)
  """
	
  f5 = plt.figure()
  ax5 = f5.add_subplot(111)
  ax5.contourf(AreR,AspR,ex_data,levels=ex_levels)
  ax5.plot(AreR,alpha*AreR+beta,'k')
  ax5.set_xlim((0.,1.0))
  ax5.set_ylim((0.,1.0))
  #ax5.plot(AreR[0:4],alpha*AreR[0:4]+beta+sig_adj,'k',linewidth=2.5)
  ax5.plot(AreR[0:18],alpha*AreR[0:18]+beta+sig_adj,'k',linewidth=3)
  ax5.vlines(Lbound,0.,1.,linewidth=3)
  ax5.vlines(Rbound,0.,1.,linewidth=3)

def main():
  os.chdir('/Users/Marty/Desktop/Ralf/MWR_MASC_connection/')
  st = readsav('xypos_4python.sav')
  
  
  ### Access the Data ###
  x_all = st.xy_st.x_all[0]
  y_all = st.xy_st.y_all[0]

  x_large = st.xy_st.x_large[0]
  y_large = st.xy_st.y_large[0]
  
  xl      = x_large.flatten() #similar to reshape in idl
  yl      = y_large.flatten()
  
  ### Data Stuff ###
  #sub = x_all[0:10]
  #max = x_all.max()  #This is Numpy syntax
  #n_el  = x_all.size or x_all.shape
  #total = x_all.sum()
  
  xspace    = np.arange(-4,4.2,0.2)
  yspace    = np.arange(-5,9.2,0.2)
  #Currently having trouble with the bins keyword
  #If I just do a histogram of the variables,then no errors occur
  #Still having some trouble plotting
  #need to create a meshgrid for plottiness
  #all_hist = np.histogram2d(x_all,y_all,bins=[xspace,yspace])
  
  #Below works!!
  H,xedges,yedges=np.histogram2d(xlarge,ylarge,bins=[xspace,yspace])
  
  pdb.set_trace()  #BreakPoints
  
  
  
  
  #MUST use plt.show() to get a figure to come up!
  



main()
