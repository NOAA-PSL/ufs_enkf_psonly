import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
from netCDF4 import Dataset
import numpy as np
import os, sys, dateutils, pygrib, cftime
from datetime import datetime

def getmean(diff,coslats):
    meancoslats = coslats.mean()
    return (coslats*diff).mean()/meancoslats

exptname = sys.argv[1]
date1 = sys.argv[2]
date2 = sys.argv[3]
datapath = '../../../'+exptname

era5_ds = Dataset('era5_1deg.nc')
tvar = era5_ds['time']
tvarl = tvar[:].tolist()
lats = era5_ds['latitude'][:]
lons = era5_ds['longitude'][:]
lons, lats = np.meshgrid(lons, lats)
coslats = np.cos(np.radians(lats))

grav = 9.8066

z500rms_ts = []
dates_ts = []  
for date in dateutils.daterange(date1,date2,6):

    cfdate = cftime.datetime(*dateutils.splitdate(date))
    tval = cftime.date2num(cfdate, units=tvar.units, calendar=tvar.calendar)
    nt = tvarl.index(tval)
    dval = cftime.num2date(tvar[nt], units=tvar.units, calendar=tvar.calendar)
    z500_era5 = era5_ds['geopotential'][nt]/grav

    grbs = pygrib.open(os.path.join(os.path.join(datapath,date),'GFSPRS_1deg.GrbF00'))
    grb = grbs.select(shortName='gh',level=500)[0]
    z500 = grb.values[::-1]

    z500err = z500_era5-z500
    z500rms = np.sqrt(getmean(z500err**2,coslats))
    z500rms_ts.append(z500rms)
    dates_ts.append(dval)
    #print(dval,z500_era5.min(),z500_era5.max(),z500.min(),z500.max(),z500err.min(),z500err.max(),z500rms)
    print(dval,z500rms)


    

