nanal=1
while [ $nanal -le $2 ]; do
charnanal="mem"`printf %03i $nanal`
python remove_checksum.py   ${1}/${charnanal}/INPUT
nanal=$((nanal+1))
done
