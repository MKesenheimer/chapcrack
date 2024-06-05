ARG UBUNTU_VERSION=16.04
FROM ubuntu:$UBUNTU_VERSION

ARG PYTHON_VERSION=2.7.9

# Install dependencies
RUN apt-get update \
  && apt-get install -y unzip git wget gcc make openssl libffi-dev libgdbm-dev libsqlite3-dev libssl-dev zlib1g-dev python-passlib python-dpkt python-m2crypto \
  && apt-get clean

# Build Python from source
WORKDIR /tmp/
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
  && tar --extract -f Python-$PYTHON_VERSION.tgz \
  && cd ./Python-$PYTHON_VERSION/ \
  && ./configure --with-ensurepip=install --enable-optimizations --prefix=/usr/local \
  && make && make install \
  && cd ../ \
  && rm -r ./Python-$PYTHON_VERSION*

# check
RUN python --version \
  && pip --version

# install requirement for chapcrack
#RUN pip install passlib

# clone into net-creds
WORKDIR /app
RUN git clone https://github.com/moxie0/chapcrack.git
WORKDIR /app/chapcrack

# install
ENV PYTHONPATH "${PYTHONPATH}:/usr/lib/python2.7/dist-packages"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/lib"
RUN python setup.py build
RUN python setup.py install
