FROM ubuntu:22.04

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && \
    apt-get install -y curl git wget && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g pnpm && \
    apt-get clean

WORKDIR /
RUN git clone https://github.com/MagicBOTAlex/EyeTracking.git
WORKDIR /EyeTracking/electron-react-app

RUN pnpm install

COPY ./models /models

RUN apt-get update

RUN apt-get install -y --no-install-recommends wget
RUN apt-get install -y --no-install-recommends ca-certificates
RUN apt-get install -y --no-install-recommends libgtk-3-0
RUN apt-get install -y --no-install-recommends libdbus-glib-1-2
RUN apt-get install -y --no-install-recommends libxt6
RUN apt-get install -y --no-install-recommends libx11-xcb1
RUN apt-get install -y --no-install-recommends libxcomposite1
RUN apt-get install -y --no-install-recommends libxdamage1
RUN apt-get install -y --no-install-recommends libxrandr2
RUN apt-get install -y --no-install-recommends libasound2
RUN apt-get install -y --no-install-recommends bzip2
RUN apt-get install -y --no-install-recommends libgl1-mesa-glx
RUN apt-get install -y --no-install-recommends libgl1-mesa-dri
RUN apt-get install -y --no-install-recommends libpci3 
RUN apt-get install -y --no-install-recommends xvfb  

# Python
RUN apt-get install -y --no-install-recommends python3 python3-pip 
RUN pip3 install --no-cache-dir selenium

RUN  apt update -yq \
    && apt install -yq software-properties-common \
    && add-apt-repository ppa:mozillateam/ppa \
    && apt-get update \
    && apt-get install -y firefox-esr \
    && rm -rf /var/lib/apt/lists/*




COPY BrowserManager.py .
COPY LocalStorage.py .
COPY dockerInternalCommands.sh .
COPY Settings.json .
RUN chmod +x dockerInternalCommands.sh
EXPOSE 5173

ENTRYPOINT ["./dockerInternalCommands.sh"]