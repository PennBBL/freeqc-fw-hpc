#! /bin/bash 

docker run --rm -ti --entrypoint=/bin/bash -v /Users/butellyn/Documents/freeqc-fw-hpc/freeqc-fw-hpc-latest_5f4005f27f9b26471ab88637/input:/flywheel/v0/input -v /Users/butellyn/Documents/freeqc-fw-hpc/freeqc-fw-hpc-latest_5f4005f27f9b26471ab88637/output:/flywheel/v0/output -v /Users/butellyn/Documents/freeqc-fw-hpc/freeqc-fw-hpc-latest_5f4005f27f9b26471ab88637/config.json:/flywheel/v0/config.json pennbbl/freeqc-fw-hpc
