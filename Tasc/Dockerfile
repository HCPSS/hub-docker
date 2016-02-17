FROM debian:jessie

# Install the prerequsites for PyTasc
RUN apt-get update \
  && apt-get install -y git python-pip python-yaml \
  && pip install gitpython

# Install PyTasc
RUN mkdir /srv/tasc \
  && git clone https://github.com/hcpss-banderson/py-tasc.git /srv/tasc \
  && git -C /srv/tasc checkout tags/v1.0.0 \
  && ln -s /srv/tasc/py_tasc.py /usr/local/bin/tasc
