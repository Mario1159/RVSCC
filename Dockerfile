# RVSCC developer enviroment
FROM alpine
MAINTAINER Mario Romero <mario@1159.cl>

# Install packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk update \
  && apk add build-base wget git make cmake gcc-riscv-none-elf newlib-riscv-none-elf verilator verilator-dev vim

# Clone the repository
WORKDIR /root
COPY . .

# Initialize the enviroment keeping container alive
ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
