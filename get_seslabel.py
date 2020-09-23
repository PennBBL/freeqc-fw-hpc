### This script uses the Flywheel SDK to get the session label associated with
### the fmriprep analysis ID.
### https://pennlinc.github.io/docs/flywheel/Gear_development/#run-script
###
### Ellyn Butler
### September 1, 2020 - September 2, 2020

import flywheel
import os
import json

# Parse config.json to get the API key
config_file = json.load(open('/flywheel/v0/config.json'))
api_key = config_file['inputs']['api_key']['key']

fw = flywheel.Client(api_key)
project = fw.projects.find_first('label=ExtraLong')

# Get the analysis ID for the fmriprep run
#fmriprep_input = os.listdir('/flywheel/v0/input/fmriprepdir/')
#fmriprep_input = os.listdir('/Users/butellyn/Documents/freeqc-fw-hpc/freeqc-fw-hpc-latest_5f4005f27f9b26471ab88637/input/fmriprepdir')
#analysis_id = fmriprep_input[1].split('_')[2].split('.')[0]
#analysis_id = fmriprep_input[0]
analysis_id = config_file['inputs']['fmriprepdir']['hierarchy']['id']

# Get the analysis object
analysis_obj = fw.get(analysis_id)

# Return the session label
print(fw.get(analysis_obj['parents']['session'])['label'])
