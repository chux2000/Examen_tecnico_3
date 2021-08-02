# 端口规划
# 9000 - nginx
# 9001 - websocketify
# 5901 - tigervnc

# based on ubuntu 18.04 LTS
FROM python:3.8.3-slim-buster

# 各种环境变量
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    PORT=9000 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_ARG0=/sbin/entrypoint.sh \
    VNC_GEOMETRY=1366x768 \
    VNC_PASSWD='' \
    USER_PASSWD='' \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install wget tar vim
RUN groupadd user && useradd -m -g user user && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        gzip git ca-certificates locales nginx sudo xorg xfce4 python-numpy rxvt-unicode tigervnc-standalone-server tigervnc-xorg-extension \
        tigervnc-common libcurl4-openssl-dev libssl-dev python3-dev python3-pip gcc wget \
        net-tools locales bzip2 python-numpy gconf-service \
        libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1  libgcc1  libgconf-2-4 \
        libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
        libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 \
        libxss1 libxtst6 fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils xvfb 

RUN wget https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz && tar -xzvf s6-overlay-amd64.tar.gz

RUN wget -O ~/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-73.0&os=linux64"
RUN tar xjf ~/FirefoxSetup.tar.bz2 -C /opt/
RUN mkdir -p /usr/lib/firefox 
RUN ln -s /opt/firefox/firefox /usr/bin/firefox 
RUN rm ~/FirefoxSetup.tar.bz2 

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz
RUN tar -xvzf geckodriver-v0.26.0-linux64.tar.gz 
RUN mkdir -p /opt/drivers 
RUN mv geckodriver /opt/drivers/geckodriver

RUN ln -s /init /init.entrypoint && \
    locale-gen en_US.UTF-8 && \
    mkdir -p /app/src  && \
    git clone --depth=1 https://github.com/novnc/noVNC.git /app/src/novnc  && \
    git clone --depth=1 https://github.com/novnc/websockify.git /app/src/websockify  && \
    apt-get autoremove -y  && \
    apt-get clean

COPY ./docker-root /

EXPOSE 9000/tcp 9001/tcp 5901/tcp

COPY . .

RUN pip3 install -r /app/requirements.txt
RUN mkdir -p /tmp/download
RUN ls -la docker-root/sbin
RUN chmod a+x -R app/vncmain.sh && chmod 777 -R app/vncmain.sh
RUN chmod a+x -R etc/X11/Xvnc-session && chmod 777 -R etc/X11/Xvnc-session
RUN chmod a+x -R sbin/entrypoint.sh && chmod 777 -R sbin/entrypoint.sh

CMD [ "python3", "hello_world.py" ]
ENTRYPOINT ["/init.entrypoint"]
CMD ["start"]
