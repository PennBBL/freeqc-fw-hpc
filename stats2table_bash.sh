#!/bin/bash
#path=`dirname $0`
#sleep 1
#cd $path
#echo "This bash script will create table from ?.stats files"
#echo "Written by Jamaan Alghamdi & Dr. Vanessa Sluming"
#echo "University of Liverpool"
#echo "jamaan.alghamdi@gmail.com"
#echo "http://www.easyneuroimaging.com"
#echo "20/12/2010

#"

#export FREESURFER_HOME=/opt/freesurfer
#sleep 1

INPUT_DIR=$FLYWHEEL_BASE/input
InDir=${INPUT_DIR}/fmriprepdir/*/freesurfer/sub-*/stats/

cd ${INPUT_DIR}/fmriprepdir/*/freesurfer/
#export SUBJECTS_DIR=$PWD
subj=`ls -d ./sub* | cut -d '/' -f 2`
#asegstats2table -i ${InDir}/wmparc.stats --delimiter comma --meas volume --skip --all-segs --tablefile wmparc_stats.csv
python2 /opt/freesurfer/bin/asegstats2table -i ${subj}/states/wmparc.stats --delimiter comma --meas volume --skip --all-segs --tablefile wmparc_stats.csv
python2 /opt/freesurfer/bin/asegstats2table --subjects $list --meas volume --delimiter comma --skip --statsfile wmparc.stats --all-segs --tablefile wmparc_stats.csv

asegstats2table --subjects $list --meas volume --skip --statsfile wmparc.stats --all-segs --tablefile wmparc_stats.txt
asegstats2table --subjects $list --meas volume --skip --tablefile aseg_stats.txt
aparcstats2table --subjects $list --hemi lh --meas volume --skip --tablefile aparc_volume_lh.txt
aparcstats2table --subjects $list --hemi lh --meas thickness --skip --tablefile aparc_thickness_lh.txt
aparcstats2table --subjects $list --hemi lh --meas area --skip --tablefile aparc_area_lh.txt
aparcstats2table --subjects $list --hemi lh --meas meancurv --skip --tablefile aparc_meancurv_lh.txt
aparcstats2table --subjects $list --hemi rh --meas volume --skip --tablefile aparc_volume_rh.txt
aparcstats2table --subjects $list --hemi rh --meas thickness --skip --tablefile aparc_thickness_rh.txt
aparcstats2table --subjects $list --hemi rh --meas area --skip --tablefile aparc_area_rh.txt
aparcstats2table --subjects $list --hemi rh --meas meancurv --skip --tablefile aparc_meancurv_rh.txt
aparcstats2table --hemi lh --subjects $list --parc aparc.a2009s --meas volume --skip -t lh.a2009s.volume.txt
aparcstats2table --hemi lh --subjects $list --parc aparc.a2009s --meas thickness --skip -t lh.a2009s.thickness.txt
aparcstats2table --hemi lh --subjects $list --parc aparc.a2009s --meas area --skip -t lh.a2009s.area.txt
aparcstats2table --hemi lh --subjects $list --parc aparc.a2009s --meas meancurv --skip -t lh.a2009s.meancurv.txt
aparcstats2table --hemi rh --subjects $list --parc aparc.a2009s --meas volume --skip -t rh.a2009s.volume.txt
aparcstats2table --hemi rh --subjects $list --parc aparc.a2009s --meas thickness --skip -t rh.a2009s.thickness.txt
aparcstats2table --hemi rh --subjects $list --parc aparc.a2009s --meas area --skip -t rh.a2009s.area.txt
aparcstats2table --hemi rh --subjects $list --parc aparc.a2009s --meas meancurv --skip -t rh.a2009s.meancurv.txt
aparcstats2table --hemi lh --subjects $list --parc BA --meas volume --skip -t lh.BA.volume.txt
aparcstats2table --hemi lh --subjects $list --parc BA --meas thickness --skip -t lh.BA.thickness.txt
aparcstats2table --hemi lh --subjects $list --parc BA --meas area --skip -t lh.BA.area.txt
aparcstats2table --hemi lh --subjects $list --parc BA --meas meancurv --skip -t lh.BA.meancurv.txt
aparcstats2table --hemi rh --subjects $list --parc BA --meas volume --skip -t rh.BA.volume.txt
aparcstats2table --hemi rh --subjects $list --parc BA --meas thickness --skip -t rh.BA.thickness.txt
aparcstats2table --hemi rh --subjects $list --parc BA --meas area --skip -t rh.BA.area.txt
aparcstats2table --hemi rh --subjects $list --parc BA --meas meancurv --skip -t rh.BA.meancurv.txt
