import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import numpy as np
import sys, os
from dateutils import daterange
from netCDF4 import Dataset
expt = sys.argv[1]
date1 = sys.argv[2]
date2 = sys.argv[3]
dates = daterange(date1,date2,6)
datapath = '/work2/noaa/gsienkf/whitaker/%s' % expt
lats = None
var = 'vgrd'
for date in dates:
    print(date)
    filenamec = os.path.join(os.path.join(datapath,date),'sfg_%s_fhr06_enssprd' % date)
    nc = Dataset(filenamec)
    if lats is None:
       lats = nc['lat'][::-1,0]
       levs = nc['pfull'][::-1]
       nlats = len(lats); nlevs = len(levs)
       spread = np.zeros((nlevs,nlats),np.float32)
    spread1 = nc[var][0,::-1,::-1,...]
    #for k in range(nlevs):
    #    print k,spread1[k].min(), spread1[k].max()
    spread = spread  + spread1.mean(axis=-1)/len(dates)
    nc.close()
print(spread.min(), spread.max())
if var in ['ugrd','vgrd']:
   clevs = np.arange(0,9.05,0.45)
elif var == 'tmp':
   clevs = np.arange(0.,4.55,0.225)
levs = np.arange(1,spread.shape[0]+1)
lats, levs = np.meshgrid(lats, levs)
plt.contourf(lats, levs, spread, clevs, cmap=plt.cm.hot_r, extend='both')
plt.colorbar()
plt.xlabel('latitude (degrees)')
plt.ylabel('model level')
plt.title('%s 6-h forecast spread %s-%s (max value %4.2f)' % (var,date1,date2,spread.max()))
#plt.ylim(1000,0)
plt.savefig('spread_%s_%s.png' % (expt,var))
#plt.show()
