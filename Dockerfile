FROM ubuntu:20.04

# Install baseline
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata
RUN apt install -y curl wget git build-essential software-properties-common
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt update

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install -y nodejs

# Install C compilers
RUN apt install -y gcc-7 gcc-8 gcc-9 gcc-10 gcc-11

# Install C++ compilers
RUN apt install -y g++-7 g++-8 g++-9 g++-10 g++-11

# Install LLVM
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 9
RUN ./llvm.sh 10
RUN ./llvm.sh 11
RUN ./llvm.sh 12
RUN ./llvm.sh 13

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y

# Install Compiler Explorer
RUN git clone https://github.com/compiler-explorer/compiler-explorer /opt/compiler-explorer
RUN rm -rf /opt/compiler-explorer/etc/config/*.properties
COPY configs/* /opt/compiler-explorer/etc/config/
RUN cd /opt/compiler-explorer && npm install

ENV PATH="/root/.cargo/bin:$PATH"
WORKDIR /opt/compiler-explorer
ENTRYPOINT [ "make" ]