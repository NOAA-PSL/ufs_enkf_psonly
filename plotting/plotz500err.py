import matplotlib
matplotlib.use('Agg')
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime
z500err1 = np.loadtxt('C96L127ufs_psonlynoiau_z500err.txtb',usecols=2)
z500err2 = np.loadtxt('C96L127ufs_psonlynoiau6_z500err.txt',usecols=2)
data1 = np.genfromtxt('C96L127ufs_psonlynoiau_z500err.txtb',usecols=(0,1),dtype=str)
datestrings = [d1+' '+d2 for d1,d2 in zip(data1[:,0],data1[:,1])]
dates = [datetime.fromisoformat(d) for d in datestrings]
plt.plot(dates,z500err1,label='C96 UFS (no IAU) 3-h')
plt.plot(dates[:len(z500err2)],z500err2,label='C96 UFS (no IAU) 6-h')
plt.xlabel('analysis time')
plt.ylabel('NH Z500 rms error')
locator = mdates.AutoDateLocator(minticks=7, maxticks=14)
formatter = mdates.ConciseDateFormatter(locator)
ax = plt.gca()
ax.xaxis.set_major_locator(locator)
ax.xaxis.set_major_formatter(formatter)
#plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%Y%m%d'))
#plt.xticks(fontsize=7)
plt.legend()
plt.savefig('z500err.png')
