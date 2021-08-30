FROM jupyter/minimal-notebook
MAINTAINER David Wright davecwright3@gmail.com

USER root
ENV NB_UID=1000
RUN apt update && apt install -y git libfontconfig libgl1-mesa-glx libasound2 wget avahi-daemon
RUN rm -rf /var/lib/apt/lists/*
ENV JUPYTER_ENABLE_LAB true

USER $NB_UID
RUN mkdir /home/jovyan/wolfram
RUN git -C /home/jovyan/wolfram clone https://github.com/WolframResearch/WolframLanguageForJupyter

ARG WolframInstall=WolframEngine_12.3.1_LINUX.sh 
COPY --chown=$NB_UID $WolframInstall /home/jovyan/wolfram/
RUN chmod 777 /home/jovyan/wolfram/$WolframInstall
USER root
# Link unxz to /usr/bin to bypass bug in wolfram installer
RUN ln -s /opt/conda/bin/xz /usr/bin/unxz
RUN /home/jovyan/wolfram/$WolframInstall -- -auto
USER $NB_ID
RUN echo "export PATH=$PATH:"/usr/local/Wolfram/WolframEngine/12.1/SystemFiles/Kernel/Binaries/Linux-x86-64/"" >> /etc/environment

