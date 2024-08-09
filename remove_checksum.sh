nanal=1
while [ $nanal -le 80 ]; do
charnanal="mem"`printf %03i $nanal`
/work/noaa/gsienkf/whitaker/miniconda3/bin/python remove_checksum.py   /work2/noaa/gsienkf/jwhitake/C96ufs_psonly1/2020010100/${charnanal}/INPUT
nanal=$((nanal+1))
done
