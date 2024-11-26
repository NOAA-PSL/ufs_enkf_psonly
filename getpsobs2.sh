module purge
module use /work/noaa/epic/role-epic/spack-stack/hercules/spack-stack-1.6.0/envs/gsi-addon-env/install/modulefiles/Core 
module load stack-intel/2021.9.0
module load stack-intel-oneapi-mpi/2021.9.0
module load intel-oneapi-mkl/2022.2.1
module load bufr/11.7.0 ## worked jan 5
module load python
module load py-netcdf4

YYYYMMDDHH=2021082918
while [ $YYYYMMDDHH -le 2021110100 ]; do
  hr=`echo $YYYYMMDDHH | cut -c9-10`
  obdate=`python findobdate.py $YYYYMMDDHH`
  YYYYMM=`echo $obdate | cut -c1-6`
  YYYYMMDD=`echo $obdate | cut -c1-8`
  HH=`echo $obdate | cut -c9-10`
  DD=`echo $obdate | cut -c7-8`
  MM=`echo $obdate | cut -c5-6`
  YYYY=`echo $obdate | cut -c1-4`
  python read_ps_prepbufr2.py /work/noaa/rstprod/dump/gdas.${YYYYMMDD}/${HH}/atmos/gdas.t${HH}z.prepbufr ${YYYYMMDDHH} > psobs2_${YYYYMMDDHH}.txt
  YYYYMMDDHH=`./incdate.sh $YYYYMMDDHH 2`
done
