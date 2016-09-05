FROM nvidia/cuda:8.0-cudnn5-devel
MAINTAINER Daniel Petti

# Install dependencies.
RUN apt-get update && apt-get install -y python-numpy python-scipy python-dev python-pip python-nose g++ libopenblas-dev git cmake sudo

# Add a non-root user for theano.
RUN adduser --disabled-password --gecos '' theano
RUN passwd -d theano
RUN adduser theano sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install CnMem
RUN git clone https://github.com/NVIDIA/cnmem.git cnmem
RUN cd cnmem && mkdir build && cd build && cmake .. && make && make install
RUN rm -rf cnmem

# Install Theano.
RUN pip install Theano

# Copy our theanorc file.
COPY theanorc /home/theano/.theanorc

# Update bashrc so Theano can find CUDA stuff.
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64" >> /home/theano/.bashrc
RUN echo "export PATH=$PATH:/usr/local/cuda/bin" >> /home/theano/.bashrc

# Turn over ownership to the theano user.
RUN chown -R theano /home/theano
