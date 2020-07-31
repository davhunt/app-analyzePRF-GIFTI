FROM brainlife/mcr:r2019a
MAINTAINER David Hunt <davhunt@iu.edu>

#download and untar freesurfer installation on /usr/local/freesurfer
RUN apt-get -y update && apt-get install -y curl tcsh libglu1-mesa libgomp1 libjpeg62 wget
RUN wget -O- ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz | tar xzv -C /usr/local
#recon-all dependencies
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y jq bc libsys-hostname-long-perl libglib2.0

#make it work under singularity
RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft /scratch /mnt/share1

# Download and install Connectome Workbench 1.4.2
# Compatible with HCP v4.0.0
RUN cd /usr/local && \
    wget https://www.humanconnectome.org/storage/app/media/workbench/workbench-linux64-v1.4.2.zip -O workbench.zip && \
    unzip workbench.zip && \
    rm workbench.zip && \
    cd /

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
ENV LD_LIBRARY_PATH /usr/local/workbench/libs_linux64:/usr/local/workbench/libs_linux64_software_opengl:$LD_LIBRARY_PATH
ENV PATH /usr/local/freesurfer/bin:/usr/local/freesurfer/fsfast/bin:/usr/local/freesurfer/tktools:/usr/local/freesurfer/mni/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/workbench/bin_linux64:$PATH
ENV CARET7DIR=/usr/local/workbench/bin_linux64
