# hybrid gain GSI(3DVar)/EnKF workflow
export cores=`expr $NODES \* $corespernode`
echo "running on $machine using $NODES nodes and $cores CORES"

export ndates_job=1 # number of DA cycles to run in one job submission
# resolution of control and ensmemble.
export RES=96   
export LEVS=127  
export OCNRES="mx100"
export ORES3=`echo $OCNRES | cut -c3-5`

export exptname="ufs_enkf_psonly"

export fg_gfs="run_ens_fv3.sh"
export rungfs="run_fv3.sh"
export ensda="enkf_run.sh"

export do_cleanup='true' # if true, create tar files, delete *mem* files.
export cleanup_ensmean='true'
export cleanup_fg='true'
export cleanup_anal='true'
export cleanup_observer='true' 
export resubmit='true'
export save_hpss_subset="false" # save a subset of data each analysis time to HPSS
export save_hpss="false"
# override values from above for debugging.
#export cleanup_ensmean='false'
#export cleanup_observer='false'
#export cleanup_anal='false'
#export cleanup_fg='false'
#export resubmit='false'
#export do_cleanup='false'
#export save_hpss_subset="false" # save data each analysis time to HPSS
#export save_hpss="false" # save data each analysis time to HPSS

source $MODULESHOME/init/sh
if [ "$machine" == 'hera' ]; then
   export basedir=/scratch2/BMC/gsienkf/${USER}
   export datadir=$basedir
   export datapath="${datadir}/${exptname}"
   export logdir="${datadir}/logs/${exptname}"
   export hsidir="/ESRL/BMC/gsienkf/2year/whitaker/${exptname}"
   export obs_datapath=/scratch2/BMC/gsienkf/whitaker/psobs
   export sstice_datapath=/scratch2/NCEPDEV/stmp1/Jeffrey.S.Whitaker/era5sstice
   module use /scratch1/NCEPDEV/nems/role.epic/spack-stack/spack-stack-1.6.0/envs/gsi-addon-dev-rocky8/install/modulefiles/Core
   module load stack-intel/2021.5.0
   module load crtm-fix/2.4.0.1_emc
   module load stack-intel-oneapi-mpi/2021.5.1
   module load grib-util
   module load parallelio
   module load netcdf-c/4.9.2
   module load netcdf-fortran/4.6.1
   module load bufr/11.7.0 ## worked jan 5
   module load crtm/2.4.0
   module load gsi-ncdiag
   module load python
   module load py-netcdf4
   module list
   export HDF5_DISABLE_VERSION_CHECK=1
   export WGRIB=`which wgrib`
elif [ "$machine" == 'orion' ]; then
   source $MODULESHOME/init/sh
   export basedir=/work2/noaa/gsienkf/${USER}
   export datadir=$basedir
   export datapath="${datadir}/${exptname}"
   export logdir="${datadir}/logs/${exptname}"
   export hsidir="/ESRL/BMC/gsienkf/2year/whitaker/${exptname}"
   export obs_datapath=/work2/noaa/gsienkf/whitaker/psobs
   export sstice_datapath=/work2/noaa/gsienkf/whitaker/era5sstice
   #export sstice_datapath=/work/noaa/rstprod/dump
   ulimit -s unlimited
   module use /work/noaa/epic/role-epic/spack-stack/orion/spack-stack-1.6.0/envs/gsi-addon-env-rocky9/install/modulefiles/Core 
   module load stack-intel/2021.9.0
   module load crtm-fix/2.4.0.1_emc
   module load stack-intel-oneapi-mpi/2021.9.0
   module load intel-oneapi-mkl/2022.2.1
   module load grib-util
   module load parallelio
   module load netcdf/4.9.2
   module load netcdf-fortran/4.6.1
   module load bufr/11.7.0 ## worked jan 5
   module load crtm/2.4.0
   module load gsi-ncdiag
   module load python
   module load py-netcdf4
   module list
   export HDF5_DISABLE_VERSION_CHECK=1
   export WGRIB=`which wgrib`
elif [ $machine == "hercules" ]; then
   source $MODULESHOME/init/sh
   export basedir=/work2/noaa/gsienkf/${USER}
   export datadir=$basedir
   export datapath="${datadir}/${exptname}"
   export logdir="${datadir}/logs/${exptname}"
   export hsidir="/ESRL/BMC/gsienkf/2year/whitaker/${exptname}"
   export obs_datapath=/work2/noaa/gsienkf/whitaker/psobs
   export sstice_datapath=/work2/noaa/gsienkf/whitaker/era5sstice
   ulimit -s unlimited
   module use /work/noaa/epic/role-epic/spack-stack/hercules/spack-stack-1.6.0/envs/gsi-addon-env/install/modulefiles/Core 
   module load stack-intel/2021.9.0
   module load crtm-fix/2.4.0.1_emc
   module load stack-intel-oneapi-mpi/2021.9.0
   module load intel-oneapi-mkl/2022.2.1
   module load grib-util
   module load parallelio
   module load netcdf/4.9.2
   module load netcdf-fortran/4.6.1
   module load bufr/11.7.0 ## worked jan 5
   module load crtm/2.4.0
   module load gsi-ncdiag
   module load python
   module load py-netcdf4
   module list
   export HDF5_DISABLE_VERSION_CHECK=1
   export WGRIB=`which wgrib`
elif [ "$machine" == 'gaea' ]; then
   export basedir=/gpfs/f5/nggps_psd/scratch/${USER}
   export datadir=${basedir}
   export datapath="${datadir}/${exptname}"
   export logdir="${datadir}/logs/${exptname}"
   export hsidir="/ESRL/BMC/gsienkf/2year/whitaker/${exptname}"
   if [ $use_s3obs == "true" ]; then
      export obs_datapath=${datapath}/dumps
   else
      export obs_datapath=${datadir}/dumps
   fi
   export sstice_datapath=/gpfs/f5/nggps_psd/proj-shared/${USER}/era5sstice
   ulimit -s unlimited
   #source /lustre/f2/dev/role.epic/contrib/Lmod_init.sh
   #module unload cray-libsci
   #module load PrgEnv-intel/8.3.3
   #module load intel-classic/2023.1.0
   #module load cray-mpich/8.1.25
   module use /ncrc/proj/epic/spack-stack/spack-stack-1.5.1/envs/unified-env/install/modulefiles/Core
   module use /ncrc/proj/epic/spack-stack/spack-stack-1.5.1/envs/gsi-addon/install/modulefiles/Core
   module load stack-intel/2023.1.0
   module load stack-cray-mpich/8.1.25
   module load parallelio
   module load crtm/2.4.0
   module load gsi-ncdiag
   module load grib-util
   module load awscli
   module load bufr/11.7.0
   module load python
   module load py-netcdf4
   module list
   #export PATH="/gpfs/f5/nggps_psd/proj-shared/Jeffrey.S.Whitaker/conda/bin:${PATH}"
   #export MKLROOT=/opt/intel/oneapi/mkl/2022.0.2
   #export LD_LIBRARY_PATH="${MKLROOT}/lib/intel64:${LD_LIBRARY_PATH}"
   export HDF5_DISABLE_VERSION_CHECK=1
   export WGRIB=`which wgrib`
else
   echo "machine must be 'hera', 'orion', 'hercules' or 'gaea' got $machine"
   exit 1
fi

# model NSST parameters contained within nstf_name in FV3 namelist
# (comment out to get default - no NSST)
# nstf_name(1) : NST_MODEL (NSST Model) : 0 = OFF, 1 = ON but uncoupled, 2 = ON and coupled
export DONST="YES"
export NST_MODEL=2
# nstf_name(2) : NST_SPINUP : 0 = OFF, 1 = ON,
export NST_SPINUP=0 # (will be set to 1 if cold_start=='true')
# nstf_name(3) : NST_RESV (Reserved, NSST Analysis) : 0 = OFF, 1 = ON
export NST_RESV=0
# nstf_name(4,5) : ZSEA1, ZSEA2 the two depths to apply vertical average (bias correction)
export ZSEA1=0
export ZSEA2=0
export NSTINFO=0          # number of elements added in obs. data array (default = 0)
export NST_GSI=0          # default 0: No NST info at all;
                          #         1: Input NST info but not used in GSI;
                          #         2: Input NST info, used in CRTM simulation, no Tr analysis
                          #         3: Input NST info, used in both CRTM simulation and Tr analysis

# turn off NST
#export DONST="NO"
#export NST_MODEL=0
#export NST_GSI=0

if [ $NST_GSI -gt 0 ]; then export NSTINFO=4; fi

export SUITE="FV3_GFS_v16"

# stochastic physics parameters.
export DO_SPPT=T
export SPPT=0.5
export DO_SHUM=F
export SHUM=0.0
export DO_SKEB=T
export SKEB=0.3
export PERT_MP=.false.
export PERT_CLDS=.true.

if [ $RES -eq 768 ]; then
   export cdmbgwd="4.0,0.15,1.0,1.0"
   export JCAP=1534
   export LONB=3072
   export LATB=1536
   export dt_atmos=150    
elif [ $RES -eq 384 ]; then
   export dt_atmos=225
   export cdmbgwd="1.1,0.72,1.0,1.0"
   export JCAP=766
   export LONB=1536
   export LATB=768
elif [ $RES -eq 192 ]; then
   export dt_atmos=450
   export cdmbgwd="0.23,1.5,1.0,1.0"
   export JCAP=382
   export LONB=768  
   export LATB=384
elif [ $RES -eq 96 ]; then
   export dt_atmos=300
   export cdmbgwd="0.14,1.8,1.0,1.0"  # mountain blocking, ogwd, cgwd, cgwd src scaling
   export JCAP=190
   export LONB=384  
   export LATB=192
else
   echo "model parameters for control resolution C$RES not set"
   exit 1
fi

export nanals=80
export ANALINC=6
export RUN='gdas'
export FHMIN=3
export FHMAX=9
export FHOUT=3
export FHCYC=6
export FRAC_GRID=.true.
export RESTART_FREQ=3
FHMAXP1=`expr $FHMAX + 1`
export FHMAX_LONGER=`expr $FHMAX + $ANALINC`
export enkfstatefhrs=`python -c "from __future__ import print_function; print(list(range(${FHMIN},${FHMAXP1},${FHOUT})))" | cut -f2 -d"[" | cut -f1 -d"]"`
export iaufhrs=3,6,9
export iau_delthrs="6" # iau_delthrs < 0 turns IAU off
# IAU off
#export iaufhrs="6"
#export iau_delthrs=-1

export nitermax=1 # number of retries
export scriptsdir="${basedir}/scripts/${exptname}"
export homedir=$scriptsdir
export incdate="${scriptsdir}/incdate.sh"

# enkf parameters
export write_ensmean=.true.
export write_fv3_increment=.false.
export SMOOTHINF=35 # inflation smoothing (spectral truncation)
export covinflatemax=1.e2
export reducedgrid=.false. # if T, used reduced gaussian analysis grid in EnKF
export covinflatemin=1.0                                            
export analpertwtnh=0.9
export analpertwtsh=0.9
export analpertwttr=0.9
export analpertwtnh_rtpp=0.0
export analpertwtsh_rtpp=0.0
export analpertwttr_rtpp=0.0
export pseudo_rh=.false.
if [[ $write_ensmean == ".true." ]]; then
   export ENKFVARS="write_ensmean=${write_ensmean},"
fi
export letkf_flag=.true.
export regularized_obloc=.false.
export letkf_bruteforce_search=.false. 
export denkf=.false..
export getkf=.true.
export getkf_inflation=.false.
export modelspace_vloc=.true.
export letkf_novlocal=.true.
#export modelspace_vloc=.false.
#export letkf_novlocal=.false.
export ANAVINFO_ENKF=${scriptsdir}/global_anavinfo.l${LEVS}.txt.dpres

#export letkf_flag=.false.

export vlocal_levs=30 # for model space localization, number of vertical levels
export neigv=`head -1 ${scriptsdir}/vlocal_eig_${vlocal_levs}_L${LEVS}.dat | cut -f1 -d" "`
export nobsl_max=`expr $nanals \* $neigv`
#export nobsl_max=1000
#export nobsl_max=-1
export nobsl_max=-1
export corrlengthnh=4000
export corrlengthtr=4000
export corrlengthsh=4000
# The lnsigcutoff* parameters are ignored if modelspace_vloc=T
export lnsigcutoffnh=1.5
export lnsigcutofftr=1.5
export lnsigcutoffsh=1.5
export lnsigcutoffpsnh=1.5
export lnsigcutoffpstr=1.5
export lnsigcutoffpssh=1.5
export lnsigcutoffsatnh=1.5 
export lnsigcutoffsattr=1.5  
export lnsigcutoffsatsh=1.5  
export iassim_order=2
export paoverpb_thresh=0.96  # ignored for LETKF, set to 1 to use all obs in serial EnKF
export saterrfact=1.0
export deterministic=.true.
export sortinc=.false.

export taperanalperts=".true."

# serial filter parameters
# (from https://rmets.onlinelibrary.wiley.com/doi/full/10.1002/qj.3598)
#export letkf_flag=.false.
#export modelspace_vloc=.false.
## min localization reduction factor for adaptive localization
## based on HPaHt/HPbHT. Default (1.0) means no adaptive localization.
## 0.25 means minimum localization is 0.25*corrlength(nh,tr,sh).
export covl_minfact=0.2
#export covl_minfact=1.0
## efolding distance for adapative localization.
## Localization reduction factor is 1. - exp( -((1.-paoverpb)/covl_efold) )
## When 1-pavoerpb=1-HPaHt/HPbHt=cov_efold localization scales reduced by
## factor of 1-1/e ~ 0.632. When paoverpb==>1, localization scales go to zero.
## When paoverpb==>1, localization scales not reduced.
export covl_efold=0.15
#export corrlengthnh=4000
#export corrlengthtr=4000
#export corrlengthsh=4000
#export lnsigcutoffpsnh=4
#export lnsigcutoffpstr=4
#export lnsigcutoffpssh=4
#export ANAVINFO_ENKF=${scriptsdir}/global_anavinfo.l${LEVS}.txt.ps

export sprd_tol=4.0

# level for downwards extrap to surface for ps operator (should be just above PBL to avoid diurnal effects)
export nlevt=29 # for 127 level model

if [ "$machine" == 'hera' ]; then
   export python=`which python`
   export fv3gfspath=/scratch1/NCEPDEV/global/glopara/fix_nco_gfsv16.3.0
   export FIXDIR=/scratch2/NAGAPE/epic/UFS-WM_RT/NEMSfv3gfs/input-data-20221101
   export FIXDIR_gcyc=${fv3gfspath}
   export FIXFV3=${fv3gfspath}/fix_fv3_gmted2010
   export FIXGLOBAL=${fv3gfspath}/fix_am
   export gsipath=${basedir}/gsi/GSI
   export fixgsi=${gsipath}/fix
   export fixcrtm=$CRTM_FIX
   export execdir=${scriptsdir}/exec_${machine}
   export gsiexec=${execdir}/gsi.x
elif [ "$machine" == 'orion' ] || [ $machine == "hercules" ]; then
   export python=`which python`
   export fv3gfspath=/work/noaa/global/glopara/fix_NEW
   export FIXDIR=/work/noaa/nems/emc.nemspara/RT/NEMSfv3gfs/input-data-20220414
   export FIXDIR_gcyc=${fv3gfspath}
   export FIXFV3=${fv3gfspath}/fix_fv3_gmted2010
   export FIXGLOBAL=${fv3gfspath}/fix_am
   export gsipath=/work/noaa/gsienkf/whitaker/GSI
   export fixgsi=${gsipath}/fix
   export fixcrtm=/work/noaa/global/glopara/crtm/crtm_v2.3.0
   export fixcrtm=$CRTM_FIX
   export execdir=${scriptsdir}/exec_${machine}
   export gsiexec=${execdir}/gsi.x
elif [ "$machine" == 'gaea' ]; then
   export fv3gfspath=/gpfs/f5/nggps_psd/proj-shared/Jeffrey.S.Whitaker/fix_NEW
   export FIXDIR=/gpfs/f5/epic/world-shared/UFS-WM_RT/NEMSfv3gfs/input-data-20221101
   export FIXFV3=${fv3gfspath}/fix_fv3_gmted2010
   export FIXGLOBAL=${fv3gfspath}/fix_am
   # optional - specify location of co2 files for model
   export CO2DIR=/gpfs/f5/nggps_psd/proj-shared/Jeffrey.S.Whitaker/fix_NEW/fix_am/co2dat_4a
   export gsipath=/gpfs/f5/nggps_psd/proj-shared/Jeffrey.S.Whitaker/GSI
   export fixgsi=${gsipath}/fix
   export fixcrtm=$CRTM_FIX
   export execdir=${scriptsdir}/exec_${machine}
   export enkfbin=${execdir}/enkf.x
   export gsiexec=${execdir}/gsi.x
else
   echo "${machine} unsupported machine"
   exit 1
fi

export FCSTEXEC=${execdir}/fv3_intel.exe
export enkfbin=${execdir}/enkf.x


# ps only convinfo file
export CONVINFO=${scriptsdir}/global_convinfo.txt.psonly

cd $scriptsdir
echo "run main driver script"
sh ./main.sh
