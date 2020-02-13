FROM brainlife/connectome_workbench:1.3.0

MAINTAINER David Hunt <davhunt@iu.edu>

#download and untar freesurfer installation on /usr/local/freesurfer
RUN apt-get update && apt-get install -y curl tcsh libglu1-mesa libgomp1 libjpeg62
RUN curl ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz | tar xvz -C /usr/local

#recon-all dependencies
RUN apt-get update && apt-get install -y jq bc libsys-hostname-long-perl libglib2.0 libatlas-base-dev

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && apt-get -qq install -y unzip xorg wget curl libstdc++6 && \
    mkdir /mcr-install && \
    mkdir /opt/mcr && \
    cd /mcr-install && \
    wget http://www.mathworks.com/supportfiles/downloads/R2017a/deployment_files/R2017a/installers/glnxa64/MCR_R2017a_glnxa64_installer.zip && \
    cd /mcr-install && \
    unzip -q MCR_R2017a_glnxa64_installer.zip && \
    ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    cd / && \
    rm -rf mcr-install

RUN apt-get install libstdc++6
RUN apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade
RUN apt-get install -y libxt6 libxmu6


# Configure environment variables for MCR
ENV LD_LIBRARY_PATH /opt/mcr/v92/runtime/glnxa64:/opt/mcr/v92/bin/glnxa64:/opt/mcr/v92/sys/os/glnxa64:$LD_LIBRARY_PATH
ENV XAPPLRESDIR /opt/mcr/v92/X11/app-defaults


ENV FREESURFER_HOME /usr/local/freesurfer
ENV FMRI_ANALYSIS_DIR /usr/local/freesurfer/fsfast
ENV FSFAST_HOME /usr/local/freesurfer/fsfast
ENV FUNCTIONALS_DIR /usr/local/freesurfer/sessions
ENV LOCAL_DIR /usr/local/freesurfer/local
ENV MINC_BIN_DIR /usr/local/freesurfer/mni/bin
ENV MINC_LIB_DIR /usr/local/freesurfer/mni/lib
ENV MNI_DATAPATH /usr/local/freesurfer/mni/data
ENV MNI_DIR /usr/local/freesurfer/mni
ENV MNI_PERL5LIB /usr/local/freesurfer/mni/share/perl5
ENV PERL5LIB /usr/local/freesurfer/mni/share/perl5
ENV SUBJECTS_DIR /usr/local/freesurfer/subjects
ENV PATH /usr/local/freesurfer/bin:/usr/local/freesurfer/fsfast/bin:/usr/local/freesurfer/tktools:/usr/local/freesurfer/mni/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

#make it work under singularity
#mkdir shouldn't be needed on overlay enabled hosts - just add to singularity.conf (without --writable)
RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft /scratch /mnt/share1 /share1

RUN touch /usr/local/freesurfer/license.txt && chmod 777 /usr/local/freesurfer/license.txt
RUN mv /opt/mcr/v92/sys/os/glnxa64/libstdc++.so.6 /opt/mcr/v92/sys/os/glnxa64/libstdc++.so.6.old
