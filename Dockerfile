# Pull base image.
FROM ubuntu

# Install Glances (develop branch)
RUN apt-get update \
    && apt-get -y install curl \
    && apt-get install -y nvme-cli
    
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y git python3 python3-pip python3-dev gcc lm-sensors wireless-tools

RUN git clone -b develop https://github.com/nicolargo/glances.git

RUN pip3 install -r /glances/requirements.txt \
    && pip3 install -r /glances/optional-requirements.txt

# Define working directory.
WORKDIR /glances

# EXPOSE PORT (For XMLRPC)
EXPOSE 61209

# EXPOSE PORT (For Web UI)
EXPOSE 61208

# Define default command.
CMD python3 -m glances -C /glances/conf/glances.conf $GLANCES_OPT
