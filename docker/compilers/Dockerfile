FROM ubuntu:18.04
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update \
  && apt install \
  golang \
  php \
  python3 \
  nodejs \
  default-jdk \
  ruby \
  g++ \
  bash -y
CMD ["bash"]