import ncepbufr, sys
import numpy as np
from datetime import datetime, timedelta

# read ps obs from prepbufr file, write to text file.

hdstr='SID XOB YOB DHR TYP ELV'
obstr='POB PQM POE'
pstypes = [120,180,181,182,187]

def splitdate(yyyymmddhh):
    """
 yyyy,mm,dd,hh = splitdate(yyyymmddhh)

 give an date string (yyyymmddhh) return integers yyyy,mm,dd,hh.
    """
    yyyymmddhh = str(yyyymmddhh)
    yyyy = int(yyyymmddhh[0:4])
    mm = int(yyyymmddhh[4:6])
    dd = int(yyyymmddhh[6:8])
    hh = int(yyyymmddhh[8:10])
    return yyyy,mm,dd,hh

# read prepbufr file, extract ps obs

bias = 0.
bufr = ncepbufr.open(sys.argv[1])
datein = sys.argv[2]
delta = timedelta(seconds=1)
halfwindow = 3600
yyyy,mm,dd,hh = splitdate(datein)
datemid = datetime(yyyy,mm,dd,hh)
date1 = datemid - halfwindow*delta
date2 = datemid + halfwindow*delta
#print('station_id, nceptyp, lon, lat, date, hroffset, elevation, psob, psqm, pserr')
while bufr.advance() == 0: # loop over messages.
    #print(bufr.msg_counter, bufr.msg_type, bufr.msg_date, bufr.receipt_time)
    yyyy,mm,dd,hh = splitdate(bufr.msg_date)
    refdate = datetime(yyyy,mm,dd,hh)
    while bufr.load_subset() == 0: # loop over subsets in message.
        hdr = bufr.read_subset(hdstr).squeeze()
        nceptyp = int(hdr[4])
        if nceptyp in pstypes:
            station_id = hdr[0].tobytes().decode("utf-8") 
            lat = hdr[2]; lon = hdr[1]; elev = hdr[5]
            obs = bufr.read_subset(obstr)
            if obs.shape[1] == 1: # surface ob
                psob = obs[0,0]; psqm = obs[1,0]; pserr = obs[2,0]
                secs = int(hdr[3]*3600.)
                obdate = refdate + secs*delta
                diff = obdate-datemid
#      read(149,9801) statid(nob),stattype(nob),oblocx(nob),oblocy(nob),&
#           izob,obtime(nob),ob(nob),bias,stdevorig(nob)
# 9801 format(a8,1x,i3,1x,f7.2,1x,f6.2,1x,i5,1x,f6.2,&
#             f7.1,1x,f8.4,1x,f4.2)
                if int(psqm) <= 4 and not np.isnan(pserr) and pserr < 9.99 and\
                   (obdate >= date1 and obdate < date2):
#                   print('%s %3i %7.2f %6.2f %5i %s %7.1f %8.4f %4.2f' % 
#                   (station_id,nceptyp,lon,lat,int(elev),obdate.strftime('%Y%m%d%H%M%S'),psob,bias,pserr))
                    print('%s %3i %7.2f %6.2f %5i %6.2f %7.1f %8.4f %4.2f' % 
                    (station_id,nceptyp,lon,lat,int(elev),diff.total_seconds()/3600.,psob,bias,pserr))
bufr.close()
