FROM ubuntu
RUN apt-get update -y && apt-get install -y sudo
RUN useradd -m -u 8877 otto
RUN echo "otto:pass" | chpasswd
RUN adduser otto sudo
USER otto
WORKDIR /home/otto
COPY ./install.sh ./
