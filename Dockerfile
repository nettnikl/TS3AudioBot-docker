FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine

# install all pre-requisites, these will be needed always
RUN apk add \
      opus-dev \
      ffmpeg

# which version and flavour of the audiobot to use
ARG TS3_AUDIOBOT_RELEASE="0.12.0"
ARG TS3_AUDIOBOT_FLAVOUR="TS3AudioBot_dotnetcore3.1.zip"

# download and install the TS3AudioBot in the specified version and flavour
RUN mkdir -p /opt/TS3AudioBot \
    && cd /opt/TS3AudioBot \
    && wget https://github.com/Splamy/TS3AudioBot/releases/download/${TS3_AUDIOBOT_RELEASE}/${TS3_AUDIOBOT_FLAVOUR} -O TS3AudioBot.zip \
    && unzip TS3AudioBot.zip

# add user to run under
RUN adduser --disabled-password -u 9999 ts3bot

# make data directory and chown it to the ts3bot user
RUN mkdir -p /data
RUN chown -R ts3bot:nogroup /data

# set user to ts3bot, we dont want to be root from now on
USER ts3bot

# set the work dir to data, so users can properly mount their config files to this dir with -v /host/path/to/data:/data
WORKDIR /data

CMD ["dotnet", "/opt/TS3AudioBot/TS3AudioBot.dll", "--non-interactive"]
