############################
# Get ANTs from DockerHub
# Get the fmriprep algorithm from DockerHub
FROM poldracklab/fmriprep:20.0.5

MAINTAINER Ellyn Butler <ellyn.butler@pennmedicine.upenn.edu>
ENV FMRIPREP_VERSION 20.0.5

############################
# Install basic dependencies
RUN apt-get update && apt-get -y install \
    jq \
    tar \
    zip \
    build-essential

############################
# Install the Flywheel SDK
RUN pip install 'flywheel-sdk==11.*'
RUN pip install heudiconv validators

############################
# Make directory for flywheel spec (v0)
ENV FLYWHEEL /flywheel/v0
RUN mkdir -p ${FLYWHEEL}
COPY run ${FLYWHEEL}/run
COPY manifest.json ${FLYWHEEL}/manifest.json
COPY fs_license.py /flywheel/v0/fs_license.py

# Set the entrypoint
ENTRYPOINT ["/flywheel/v0/run"]

# Add the fmriprep dockerfile to the container
ADD https://raw.githubusercontent.com/poldracklab/fmriprep/${FMRIPREP_VERSION}/Dockerfile ${FLYWHEEL}/fmriprep_${FMRIPREP_VERSION}_Dockerfile


############################
# Copy over python scripts that generate the BIDS hierarchy
COPY prepare_run.py /flywheel/v0/prepare_run.py
COPY create_archive_fw_heudiconv.py /flywheel/v0/create_archive_fw_heudiconv.py
COPY move_to_project.py /flywheel/v0/move_to_project.py
RUN chmod +x ${FLYWHEEL}/*

RUN pip install fw-heudiconv -U


############################
# ENV preservation for Flywheel Engine
RUN env -u HOSTNAME -u PWD | \
  awk -F = '{ print "export " $1 "=\"" $2 "\"" }' > ${FLYWHEEL}/docker-env.sh

WORKDIR /flywheel/v0
