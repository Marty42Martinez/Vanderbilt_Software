# -*- coding: utf-8 -*-
"""
Created on Wed Jul  2 16:15:59 2014
Monday Jul 7
    used PCA to find the slope and intercept of each countour plot
    having some trouble with subplot
Tuesday Jul 8
    addressed all issues with subplot
    added the option to look at the data cloud of one particle size
    ##Just change the indiv_plot_flag to 1
    Store alpha and beta for plotting purposes
    blot alpha and beta on same subplot with different y axes

Week of July 17
    Slight modifications to accept the 'fine' data where bins are .02 X .02 instead of .1 X .1
    Lots of toggling comments is required to get the necessary plots and data
    other than that it is simple
@author: Marty
"""
import numpy as np
import os
import matplotlib
from pylab import *
import matplotlib.pyplot as plt
from numpy import linalg as LA
import scipy

#rcParams['figure.figsize'] = 20,15
rcParams['figure.figsize'] = 12,12


def find_min(data,limit):
    testmin = []
    for item in data:
        if sum(item) != 0 and max(item) >limit:
            testmin.append(min([num for num in item if (num != 0 and num > limit)]))
    try:
        val = min(testmin)
    except ValueError:
        val = find_min(data,limit/2.)
    else:
        val = min(testmin)
    return val
    
def set_levels(data):
#    min_val = find_min(data,5000)
    max_val = max([max(item) for item in data])
    min_val = max_val*.05
    #min_val = 1
    levels = np.linspace(min_val,max_val,1000)
    #levels = np.logspace(min_val,max_val,num =10)
    return levels
    
def XY_forPCA(data,AreR,AspR):
    x=[]
    y=[]
    for i in range(np.shape(data)[0]):
        for j in range(np.shape(data)[1]):
            count = data[i,j]/100.
            if count <1 and data[i,j]!=0:
                x += [AreR[j]]
                y += [AspR[i]]
            elif count>1:
                count = int(count)
                x += [AreR[j]]*count
                y += [AspR[i]]*count
    return (np.array(x),np.array(y))
    
def PCA_calc(X,Y):
    N = np.size(X)
    xData = np.reshape(X, (N, 1))
    yData = np.reshape(Y, (N, 1))
    PCA_data = np.hstack((xData, yData))
    mu = PCA_data.mean(axis=0)
    PCA_data = PCA_data-mu
    evec, evals, V = LA.svd(PCA_data.T, full_matrices=False)
    projected_data = np.dot(PCA_data,evec)      
    #Express data in relation to eigen vectors
    sigma = projected_data.std(axis=0).mean()
#Returns the standard deviation of projected data relative to principal evec
    return (evec,mu,sigma)
                
    
def eigenlines(evec,mu):
    alpha = evec[0,1]/evec[0,0]
    beta = -alpha*mu[0]+mu[1]
    return (alpha, beta)
    
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
    else:
        axarr[counter/sizer,counter%sizer].contourf(AreR,AspR,data,levels=levels)
        axarr[counter/sizer,counter%sizer].plot(AreR,alpha*AreR+beta,'k')
        axarr[counter/sizer,counter%sizer].set_xlim((0.,1.0))
        axarr[counter/sizer,counter%sizer].set_ylim((0.,1.0))
        axarr[counter/sizer,counter%sizer].xaxis.set_ticks(np.array([0.2,0.4,0.6,0.8]))
        axarr[counter/sizer,counter%sizer].yaxis.set_ticks(np.array([0.2,0.4,0.6,0.8]))
        axarr[counter/sizer,counter%sizer].plot(AreR,alpha*AreR+beta+sig_adj,'r')
        axarr[counter/sizer,counter%sizer].plot(AreR,alpha*AreR+beta-sig_adj,'r')
        #axarr[counter/sizer,counter%sizer].plot(AreR[0:4],alpha*AreR[0:4]+beta+sig_adj,'k',linewidth=2)
        #axarr[counter/sizer,counter%sizer].vlines(Lbound,0.,1.,linewidth=2)
        #axarr[counter/sizer,counter%sizer].vlines(Rbound,0.,1.,linewidth=2)
        #axarr[counter/sizer,counter%sizer].text(0.05,0.85,'N_OBL',fontsize=10,color='red')
        #axarr[counter/sizer,counter%sizer].text(0.05,0.7,str(int(bins[0])),fontsize=12,color='red')
        #axarr[counter/sizer,counter%sizer].text(0.05,0.2,'N_PROMAX',fontsize=10,color='red')
        #axarr[counter/sizer,counter%sizer].text(0.05,0.05,str(int(bins[1])),fontsize=12,color='red')
        #axarr[counter/sizer,counter%sizer].text(0.35,0.2,'N_PROMEAN',fontsize=10,color='red')
        #axarr[counter/sizer,counter%sizer].text(0.35,0.05,str(int(bins[2])),fontsize=12,color='red')
        #axarr[counter/sizer,counter%sizer].text(0.75,0.2,'N_SPH',fontsize=10,color='red')
        #axarr[counter/sizer,counter%sizer].text(0.75,0.05,str(int(bins[3])),fontsize=12,color='red')
        #axarr[counter/sizer,counter%sizer].text(0.75,0.7,'N_TOTAL',fontsize=12,color='k')
        #axarr[counter/sizer,counter%sizer].text(0.75,0.5,str(int(Ntotal)),fontsize=14,color='k')
        axarr[counter/sizer,counter%sizer].set_title(str(int(part_size))+'microns')
        
"""
Following function calculates the  distance that the line must be moved
up or down to include 1 std dev of the data
"""    
def siglines(alpha,sigma):
#    phi = np.pi/2 - np.arctan(1/alpha)
    phi = np.arctan(alpha)
    #Angle between a vertical line and a line perpendicular to the eigenline
    x = sigma/np.cos(phi)
    x /= 2.
    return (x)
    
def pts_between_stdevs(AreR,AspR,alpha,beta,sig_adj):
    top_bound = alpha*AreR+beta+sig_adj
    bot_bound = alpha*AreR+beta-sig_adj
    accepted = []
    for i in range(np.size(AreR)):
#          These are arrays that contain the position of points within AspR that fit
#          within the top and bot bound line
        top_accept=[scipy.argwhere(AspR==j)[0][0] for j in AspR if j <= top_bound[i]]
        bot_accept=[scipy.argwhere(AspR==k)[0][0] for k in AspR if k >= bot_bound[i]]
        accepted.append([val for val in top_accept if val in bot_accept])
    return accepted
    

def part_shape_bins(data,AreR,AspR,alpha,beta,sig_adj,Lbound,Rbound):
    top_bound = alpha*AreR+beta+sig_adj
    LRbound_pos01 = [scipy.argwhere(AreR==j)[0][0] for j in AreR if j < Lbound]
    LRbound_pos2 = [scipy.argwhere(AreR==j)[0][0] for j in AreR if j >= Lbound and j <= Rbound]
    LRbound_pos3 = [scipy.argwhere(AreR==j)[0][0] for j in AreR if j > Rbound]
    bins = [[],[],[],[],[]]
    bins2 = np.array([0,0,0,0])
    for i in range(np.size(AspR)):
        cols0 = [k for k in LRbound_pos01 if AspR[i] > top_bound[k]]
        bins[0].append(np.sum(data[i,cols0]))
       
        cols1 = [k for k in LRbound_pos01 if AspR[i] < top_bound[k]]
        bins[1].append(np.sum(data[i,cols1]))
        
        bins[2].append(np.sum(data[i,LRbound_pos2]))
        bins[3].append(np.sum(data[i,LRbound_pos3]))
    
    bins2[0] = np.array(bins[0]).sum()
    bins2[1] = np.array(bins[1]).sum()
    bins2[2] = np.array(bins[2]).sum()
    bins2[3] = np.array(bins[3]).sum()
    if bins2[1] < bins2[0]:
        bins2[0] += bins2[1]
        bins2[1] = 0
    else:
        bins2[1] -= bins2[0]
        bins2[0] *= 2
    return (bins2)
    

        
def outlier_exclusion(accepted,data,AreR,AspR,alpha,beta,sigma):
#    (accepted,data,AreR,AspR,alpha,beta,sigma) >> old required parameters
#    (accepted,data) >> other parameters
    new_data = np.zeros((50,50))
    for i in range(50):
        if np.sum(accepted[i]) != 0:
            rows = [item for item in accepted[i]]
            new_data[rows,i] = data[rows,i]
    #return (new_data)
#    ####BELOW is the code used when iteratively changing alpha, beta, sigma
#    to find best fits for each particle size bin
    X,Y = XY_forPCA(new_data,AreR,AspR)
    evec,mu,new_sigma = PCA_calc(X,Y)
    new_alpha,new_beta = eigenlines(evec,mu)
    sig_adj = siglines(new_alpha,2*new_sigma)
    al_diff = abs(alpha-new_alpha)
    b_diff = abs(beta-new_beta)
    s_diff = abs(sigma-new_sigma)
    if al_diff >= 0.05 or b_diff >= 0.01 or s_diff >= 0.001:
        accepted = pts_between_stdevs(AreR,AspR,new_alpha,new_beta,sig_adj)
        return outlier_exclusion(accepted,new_data,AreR,AspR,new_alpha,new_beta,new_sigma)    
    return (new_data,new_alpha,new_beta,new_sigma,sig_adj)
    
def alpha_beta_plot(part_size_arr,alpha_arr,beta_arr):
    f3 = plt.figure()
    ax3 = f3.add_subplot(111)
    ax3.plot(part_size_arr,alpha_arr,'g')
    ax3.set_title('AspR = alpha*AreR + beta')
    ax3.set_xlabel('Particle size (um)')
    ax3.set_ylabel('alpha',color='g')
    for t3 in ax3.get_yticklabels():
        t3.set_color('g')
    for item in ([ax3.title, ax3.xaxis.label, ax3.yaxis.label] +
    ax3.get_xticklabels() + ax3.get_yticklabels()):
        item.set_fontsize(16)
      
    ax4 = ax3.twinx()
    ax4.plot(part_size_arr,beta_arr,'b')
    ax4.set_ylabel('beta',color='b')
    for t4 in ax4.get_yticklabels():
        t4.set_color('b')
    for item in ([ax4.yaxis.label] +
    ax4.get_yticklabels()):
        item.set_fontsize(16)
        
        
def zone_def_plot(ex_data,AreR,AspR,ex_levels,alpha,beta,sig_adj,Rbound,Lbound):
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
    
    #ax5.fill([0,0.35,0.35,0],[0.3,0.81,1,1],'r',alpha=0.3) #OBLATE
    #ax5.fill([0,0.35,0.35,0],[0,0,0.81,0.3],'r',alpha=0.3) #PROMAX
    #ax5.fill([0.35,0.55,0.55,0.35],[0,0,1,1],'r',alpha=0.3) #PROMEAN
    ax5.fill([0.55,1,1,0.55],[0,0,1,1],'r',alpha=0.3) #SPH
  
    #ax5.text(0.65,0.9,'Average primary Eigen vector',fontsize=16,color='red')
    #ax5.text(0.75,0.85,'AspR=%.2f*AreR+%.2f' %(alpha,beta),fontsize=16,color='red')
    #ax5.arrow(0.75,0.84,-0.12,0.06,linewidth=.75,color='k')
  
    #ax5.text(0.01,0.75,'2 std from primary',fontsize=16,color='red')
    #ax5.text(0.01,0.7,'AspR=%.2f*AreR+%.2f' %(alpha,beta+sig_adj),fontsize=16,color='red')
    #ax5.arrow(0.1,0.7,0.05,-0.14,linewidth=.75,color='k')
  
    #ax5.text(0.56,0.2,'AreR=%.2f' %(Rbound),fontsize=16,color='k')
    #ax5.arrow(0.7,0.25,-0.12,0,linewidth=.75,color='k')
    #ax5.text(0.2,0.2,'AreR=%.2f' %(Lbound),fontsize=16,color='k')
    #ax5.arrow(0.2,0.25,0.12,0,linewidth=.75,color='k')
    #ax5.set_title('ZONE DEFINITIONS',fontsize=24)
    ax5.set_title('SPHERICAL PARTICLES',fontsize=24)
    ax5.set_xlabel('Area Ratio')
    ax5.set_ylabel('Aspect Ratio')
    for item in ([ax5.xaxis.label, ax5.yaxis.label] +
    ax5.get_xticklabels() + ax5.get_yticklabels()):
        item.set_fontsize(24)

"""
##########################################
################START MAIN################
##########################################
"""
    
def main():
  font = {'family' : 'monospace',
          'weight' : 'normal',
          'size'   : 7}

  matplotlib.rc('font', **font)

  os.chdir('/Users/Marty/Desktop/JPL/RatioData')
  #fn = 'asr_ar_pdf.txt'
  #fn = 'arearatio_vs_aspectratio_joint_pdf_gcpex_finebins.txt'
  #fn = 'arearatio_vs_aspectratio_joint_pdf_gcpex_finebins_v2.txt'
  fn = 'arearatio_vs_aspectratio_joint_pdf_gcpex_finebins_largemask.txt'
  f = open(fn,'r')
  header1 = f.readline()
  dates = header1.split(':')[-1]
  dates_list = dates.split(',')
  
  ignore1 = f.readline()
  ignore2 = f.readline()
  
  """
  Getting rid of the first 3 plots because their data points do not correllate well
  """
  #for i in range(33):
  #    f.readline()
      

  part_size = float(f.readline().split()[0])
  #AspR = np.linspace(0.05,0.95,10)
  #AreR = np.linspace(0.05,0.95,10)
  AreR = np.linspace(0.01,0.99,50)
  AspR = np.linspace(0.01,0.99,50)
#  AreRi,AspRi = np.meshgrid(AreR,AspR)
  """
##########################
PLOTTING FLAGS
##########################
  """
  indiv_plot_flag = 0 # 1 #
  all_plot_flag =0 # 1 # 
  all_plot_excl_flag = 0 # 1 #
  AB_plot_flag = 0 # 1 #
  use_meanvals_flag = 0 # 1 #
  zone_def_flag = 1 # 0 #
  
 
  
  
  part_size_plot = 0
  if indiv_plot_flag == 1:
      part_size_plot = float(\
      raw_input('Enter an integer value for particle size in microns:'))
  if all_plot_flag ==1 or all_plot_excl_flag==1:
      fig, axarr = plt.subplots(6,4,sharex='col')#,sharey='row')
      fig.text(0.5, 0.04, 'Area Ratio (AreR)', ha='center', va='center',fontsize=14)
      fig.text(0.06, 0.5, 'Aspect Ratio (AspR)', ha='center', va='center', rotation='vertical',fontsize=14)
      #fig.set_size_inches(8,8)
      #fig.figsize(10,10)
  alpha_arr=[]
  beta_arr=[]
  Npts_arr=[]
  Ntot = []
  sig_arr = []
  part_size_arr=[]
  part_size_arr.append(part_size)

  #mu_arr = [[.53,.68],[.50,.67],[.47,.66],[.47,.67],[.45,.66],[.44,.66],
  #          [.42,.66],[.42,.66],[.40,.66],[.40,.66],[.40,.66],[.39,.66],
  #          [.38,.65],[.37,.65],[.36,.64],[.35,.63],[.34,.62],[.33,.61],
  #          [.33,.60],[.33,.60],[.33,.59]]
  counter = 0
  bintots = np.array([0,0,0,0])
  while part_size != 0:
      data = []
      for i in range(50):
          row = f.readline().split()
          flt_row = [float(item) for item in row]
          data.append(flt_row)
        
      data=np.array(data)
      levels = set_levels(data)
      Ntot.append(np.sum(data))
      #data[:,0:11] = 0
      
      if counter == 11:
          ex_data = data
          ex_levels = levels

      if use_meanvals_flag == 1:
          alpha = 1.47010
          beta = 0.03142
          sigma = 0.15004
          #BELOW >> bins of 0.02 v2
          #alpha = 1.47664
          #beta = 0.02912
          #sigma = .14992
          #BELOW >> bins of 0.02 OLD
          #alpha = 1.38432
          #beta = 0.06108
          #sigma = .14336
          #BELOW >>bins of 0.1
          #alpha = 1.20834
          #beta = 0.14823
          #sigma = 0.11598
          sig_adj = abs(siglines(alpha,2*sigma))
      else:
          X,Y = XY_forPCA(data,AreR,AspR)
          evec,mu,sigma = PCA_calc(X,Y)
          #mu_arr.append(mu)
          alpha,beta = eigenlines(evec,mu)
          sig_adj = abs(siglines(alpha,2*sigma))
          
#      Lbound = mu_arr[counter-3][0] -0.05
#      Rbound = mu_arr[counter-3][0] + 0.05
      Lbound = 0.35
      Rbound = 0.55
      Ntotal = Ntot[counter]
      part_size = part_size_arr[counter]
      
      bin_counts=part_shape_bins(data,AreR,AspR,alpha,beta,sig_adj,Lbound,Rbound)
      bintots += bin_counts
      
      
      #alpha_arr.append(alpha)
      #beta_arr.append(beta)
      
  
      if counter <= 2:
          outlier =1
      else:
          outlier = 0
          
      if all_plot_flag == 1:
          composite_contour(outlier,axarr,counter,levels,AreR,AspR,data,alpha,beta,sig_adj,part_size)
          #composite_contour(outlier,axarr,counter,levels,AreR,AspR,data,alpha,beta,sig_adj,\
          #                  Lbound,Rbound,bin_counts,Ntotal,part_size)
          

      accepted = pts_between_stdevs(AreR,AspR,alpha,beta,sig_adj) 
      fixed_data,new_alpha,new_beta,new_sigma,sig_adj = \
          outlier_exclusion(accepted,data,AreR,AspR,alpha,beta,sigma)
      #fixed_data = outlier_exclusion(accepted, data,AreR,AspR,alpha,beta,sigma)
      Npts_arr.append(np.sum(fixed_data))
      if all_plot_excl_flag == 1:
          levels = set_levels(fixed_data)
          composite_contour(outlier,axarr,counter,levels,AreR,AspR,fixed_data,new_alpha,new_beta,sig_adj,part_size)
          #composite_contour(axarr,counter,levels,AreR,AspR,fixed_data,alpha,beta,sig_adj)
          #composite_contour(axarr,counter,levels,AreR,AspR,fixed_data,new_alpha,new_beta,sig_adj)
          
      #alpha_arr.append(new_alpha)
      #beta_arr.append(new_beta)
      #sig_arr.append(new_sigma)
#      if counter ==4:
#          print accepted
      

      """
Don't need this code anymore but it is nice for looking at the eigenvectors
      """
#        for axis in evec:
#            annotate(ax1, '', mu, mu + sigma * axis)
#def annotate(ax, name, start,end):
#    arrow = ax.annotate(name,
#                        xy=end, xycoords='data',
#                        xytext=start, textcoords='data',
#                        arrowprops=dict(facecolor='red', width=2.0))
#    return arrow 
      
            
      """
Section where individual plots are created

      """      
      if part_size_plot == part_size:
          f2 = plt.figure()
          ax2 = f2.add_subplot(111)
          con2 = ax2.contourf(AreR,AspR,data,levels=levels)
          #ax2.plot(AreR,alpha*AreR+beta,'k')
          #ax2.plot(AreR,alpha*AreR+beta+sig_adj,'r',linewidth=3)
          #ax2.plot(AreR,alpha*AreR+beta-sig_adj,'r',linewidth=3)
          #ax2.scatter(AreR_pts,AspR_pts,marker='o',c='k',linewidth=2.5)
          #ax2.vlines(Lbound,0.35,1.,linewidth=3)
          #ax2.vlines(Rbound,0.615,0.985,linewidth=3)
          cb=ax2.figure.colorbar(con2)
          cb.ax.tick_params(labelsize=16)
          ax2.set_xlim((0.0,1.0))
          ax2.set_ylim((0.0,1.0))
          ax2.set_xlabel('Area Ratio')
          ax2.set_ylabel('Aspect Ratio')
          ax2.set_title(str(int(part_size))+'microns')
          for item in ([ax2.title, ax2.xaxis.label, ax2.yaxis.label] +
             ax2.get_xticklabels() + ax2.get_yticklabels()):
            item.set_fontsize(16)

      
      part_size = f.readline().split()
      
      if np.size(part_size) ==0 or counter == 22:
          part_size = 0
      else:
          part_size = float(part_size[0])
          part_size_arr.append(part_size)
      counter +=1
      
      
  f.close()
  """
  #####################
  Outside of while loop
  #####################
  """
  Npts_arr = np.array(Npts_arr[3:])
  Ntot = np.array(Ntot[3:])
  print Npts_arr/Ntot
  #alpha_arr=np.array(alpha_arr[2:])
  #beta_arr=np.array(beta_arr[2:])
  part_size_arr=np.array(part_size_arr[2:])
  #print np.shape(alpha_arr), np.shape(part_size_arr)
  #sig_arr =np.array(sig_arr[2:])
  #print alpha_arr.mean(), beta_arr.mean(), sig_arr.mean()
  #print bintots

  if AB_plot_flag == 1:
      alpha_beta_plot(part_size_arr,alpha_arr,beta_arr)
  if zone_def_flag == 1:
      zone_def_plot(ex_data,AreR,AspR,ex_levels,alpha,beta,sig_adj,Rbound,Lbound)
  
  plt.savefig('test.png',dpi=100)
  
  plt.show()
main()
