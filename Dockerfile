# main image
FROM ubuntu:18.04

# installing dependencies
RUN apt-get update && apt-get install -y curl git libglu1-mesa openjdk-8-jdk unzip usbutils xz-utils wget zip

# set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# prepare android directories and system variables
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# set up android sdk
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# download flutter sdk
RUN git clone -b 2.0.4 --depth 1 https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

# run basic check
RUN flutter doctor