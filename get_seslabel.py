### This script uses the Flywheel SDK to get the session label associated with
### the fmriprep analysis ID.
###
### Ellyn Butler
### September 1, 2020

import flywheel
import os

fw = flywheel.Client()
project = fw.projects.find_first("label=ExtraLong")

# Get the analysis ID for the fmriprep run
fmriprep_input = os.listdir('/flywheel/v0/input/fmriprepdir/')
#fmriprep_input = os.listdir('/Users/butellyn/Documents/freeqc-fw-hpc/freeqc-fw-hpc-latest_5f4005f27f9b26471ab88637/input/fmriprepdir')
analysis_id = fmriprep_input[0].split('_')[2].split('.')[0]

# Get the analysis object
analysis_obj = fw.get(analysis_id)

# Return the session label
print(fw.get(analysis_obj['parents']['session'])['label'])
