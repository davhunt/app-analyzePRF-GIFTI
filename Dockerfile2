FROM mcr:neurodebian1604-r2017a

RUN apt-get update
#RUN apt-get install 
RUN sudo apt-get update
#RUN sudo apt-get install -y mrtrix 

#ADD mrtrix.conf /etc/mrtrix.conf

#WORKDIR /output

#ENV PATH=$PATH:/usr/lib/mrtrix/bin

#make it work under singularity
RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft

#ENTRYPOINT ["/app/ensembletracking.sh"]
