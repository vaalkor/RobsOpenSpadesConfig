#!/bin/bash

sudo yum install git -y
sudo yum groupinstall "Development Tools" -y
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
python get-pip.py
pip install cython twisted jinja2 pillow pygeoip pycrypto pyasn1


git clone https://github.com/NateShoffner/PySnip
cd PySnip

./build.sh
./run_server.sh
