# RVSCC developer enviroment
FROM alpine
MAINTAINER Mario Romero <mario@1159.cl>

# Install packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk update \
  && apk add wget git make cmake gcc-riscv-none-elf newlib-riscv-none-elf verilator vim

# Copy RISC-V repository into container
COPY . /root

# Initialize the enviroment
WORKDIR /root
CMD ["/bin/sh"]
