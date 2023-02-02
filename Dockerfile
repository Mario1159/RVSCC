# RVSCC developer enviroment
FROM alpine
MAINTAINER Mario Romero <mario@1159.cl>

# Install packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk update \
  && apk add build-base wget git make cmake gcc-riscv-none-elf newlib-riscv-none-elf verilator vim

# Clone the repository
WORKDIR /root
RUN git clone https://git.1159.cl/Mario1159/RVSCC.git

# Initialize the enviroment keeping container alive
ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
