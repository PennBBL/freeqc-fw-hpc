############################
# Get Freesurfer version in fMRIPrep 20.0.5
FROM ubuntu:xenial-20200114

MAINTAINER Ellyn Butler <ellyn.butler@pennmedicine.upenn.edu>
ENV FREESURFER_VERSION 6.0.1
ENV FREESURFER_HOME /opt/freesurfer


############################
# Install basic dependencies
RUN apt-get update && apt-get -y install \
    jq \
    tar \
    zip \
    build-essential

#COPY docker/files/neurodebian.gpg /usr/local/etc/neurodebian.gpg

# Prepare environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                    curl \
                    bzip2 \
                    ca-certificates \
                    xvfb \
                    build-essential \
                    autoconf \
                    libtool \
                    pkg-config \
                    git && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y --no-install-recommends \
                    nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -sSLO https://repo.continuum.io/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh && \
    bash Miniconda3-4.5.11-Linux-x86_64.sh -b -p /usr/local/miniconda && \
    rm Miniconda3-4.5.11-Linux-x86_64.sh

ENV PATH=/usr/local/miniconda/bin:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONNOUSERSITE=1

# Installing freesurfer
RUN curl -sSL https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.1/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.1.tar.gz | tar zxv --no-same-owner -C /opt \
    --exclude='freesurfer/diffusion' \
    --exclude='freesurfer/docs' \
    --exclude='freesurfer/fsfast' \
    --exclude='freesurfer/lib/cuda' \
    --exclude='freesurfer/lib/qt' \
    --exclude='freesurfer/matlab' \
    --exclude='freesurfer/mni/share/man' \
    --exclude='freesurfer/subjects/fsaverage_sym' \
    --exclude='freesurfer/subjects/fsaverage3' \
    --exclude='freesurfer/subjects/fsaverage4' \
    --exclude='freesurfer/subjects/cvs_avg35' \
    --exclude='freesurfer/subjects/cvs_avg35_inMNI152' \
    --exclude='freesurfer/subjects/bert' \
    --exclude='freesurfer/subjects/lh.EC_average' \
    --exclude='freesurfer/subjects/rh.EC_average' \
    --exclude='freesurfer/subjects/sample-*.mgz' \
    --exclude='freesurfer/subjects/V1_average' \
    --exclude='freesurfer/trctrain'

# Installing precomputed python packages # September 3, 2020: Ending up with pip v 10.1.1
RUN conda install -y python=3.7.1 \
                      pip=19.1 \
    chmod -R a+rX /usr/local/miniconda; sync && \
    chmod +x /usr/local/miniconda/bin/*; sync && \
    conda build purge-all; sync && \
    conda clean -tipsy && sync


############################
# Install the Flywheel SDK
#RUN pip install 'flywheel-sdk==11.*'
#RUN pip install heudiconv validators
#RUN pip-2.7 install csv
# September 4, 2020: csv is a module that should be automatically included with the python installation


############################
# Make directory for flywheel spec (v0)
ENV FLYWHEEL /flywheel/v0
RUN mkdir -p ${FLYWHEEL}
COPY run ${FLYWHEEL}/run
COPY manifest.json ${FLYWHEEL}/manifest.json
#COPY fs_license.py /flywheel/v0/fs_license.py

# Set the entrypoint
ENTRYPOINT ["/flywheel/v0/run"]

# Add the fmriprep dockerfile to the container
#ADD https://raw.githubusercontent.com/poldracklab/fmriprep/${FMRIPREP_VERSION}/Dockerfile ${FLYWHEEL}/fmriprep_${FMRIPREP_VERSION}_Dockerfile


############################
# Copy over python scripts that generate the BIDS hierarchy
#COPY prepare_run.py /flywheel/v0/prepare_run.py # August 19, 2020: This is probably obsolete, since the entire pipeline is in the run script
#COPY create_archive_fw_heudiconv.py /flywheel/v0/create_archive_fw_heudiconv.py
COPY move_to_project.py /flywheel/v0/move_to_project.py
COPY get_seslabel.py /flywheel/v0/get_seslabel.py
#COPY download_freesurfer_output.py /flywheel/v0/download_freesurfer_output.py
COPY stats2table_bash.sh /flywheel/v0/stats2table_bash.sh
RUN chmod +x ${FLYWHEEL}/*

RUN pip install fw-heudiconv -U


############################
# ENV preservation for Flywheel Engine
RUN env -u HOSTNAME -u PWD | \
  awk -F = '{ print "export " $1 "=\"" $2 "\"" }' > ${FLYWHEEL}/docker-env.sh

WORKDIR /flywheel/v0
