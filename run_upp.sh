#!/bin/sh
#SBATCH -q urgent
#SBATCH -t 00:30:00
#SBATCH -A da-cpu
#SBATCH -N 1  
#SBATCH --ntasks-per-node=80
#SBATCH -p hercules
#SBATCH -J run_upp
#SBATCH -e run_upp.out
#SBATCH -o run_upp.out

export machine='hercules'

module use /work/noaa/gsienkf/whitaker/UPP/modulefiles
module load ${machine}
module load wgrib2
module list

export exptname=C192L127ufs_psonly2
export basedir=/work2/noaa/gsienkf/${USER}
export scriptsdir="${basedir}/scripts/${exptname}"
export execdir=${scriptsdir}/exec_${machine}

analdate='2021091900'
while [ $analdate -le '2021092712' ]; do
datapath=${basedir}/${exptname}
YYYYMMDD=`echo $analdate | cut -c1-8`
YYYY=`echo $analdate | cut -c1-4`
MM=`echo $analdate | cut -c5-6`
DD=`echo $analdate | cut -c7-8`
HH=`echo $analdate | cut -c9-10`
mkdir ${datapath}/postprd$$
pushd ${datapath}/postprd$$
filename_atm=${datapath}/${analdate}/sanl_${analdate}_fhr06_ensmean
filename_sfc=${datapath}/${analdate}/bfg_${analdate}_fhr06_ensmean
/bin/cp -f ${scriptsdir}/upp_parm/* .
sed -i -e "s/YYYY/${YYYY}/g" itag
sed -i -e "s/MM/${MM}/g" itag
sed -i -e "s/DD/${DD}/g" itag
sed -i -e "s/HH/${HH}/g" itag
sed -i -e "s!ATMFILENAME!${filename_atm}!g" itag
sed -i -e "s!SFCFILENAME!${filename_sfc}!g" itag
cat itag
echo "srun -n 4 ${execdir}/upp.x < itag"
export OMP_NUM_THREADS=10
srun -n 4 ${execdir}/upp.x < itag
wgrib2 GFSPRS.GrbF00 -new_grid ncep grid 3 GFSPRS_1deg.GrbF00
/bin/mv -f GFSPRS_1deg.GrbF00 ${datapath}/${analdate}
/bin/rm -rf ${datapath}/postprd$$
analdate=`${scriptsdir}/incdate.sh $analdate 6`
done
