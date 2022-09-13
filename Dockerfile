FROM ubuntu:22.04
USER root
WORKDIR /root/

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD ./sources.list /etc/apt/sources.list
RUN dpkg --add-architecture i386 && apt-get update -y 
RUN apt-get install -y wine32 wget vim cabextract winetricks winbind alsa-base 

ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8
ENV TZ=Asia/Shanghai

ADD InstMsiW.exe /root/.cache/winetricks/msls31/
ADD W2KSP4_EN.EXE /root/.cache/winetricks/win2ksp4/

ADD ./fonts/* /root/.wine/drive_c/windows/Fonts/
ADD ./fonts/* /usr/share/fonts/
RUN fc-cache


CMD ["/bin/bash"]