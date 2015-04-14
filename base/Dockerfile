FROM ubuntu:12.04
MAINTAINER PyLabs pylabs@allegrogroup.com

ADD provision.sh /root/provision.sh
RUN /root/provision.sh

RUN adduser --disabled-password --home=/home/ralph --gecos "" ralph
ENV HOME /home/ralph
USER ralph
RUN virtualenv /home/ralph/ && /home/ralph/bin/pip install pip==1.5.6 && /home/ralph/bin/pip install setuptools==3.6 && mkdir /home/ralph/.ralph

ONBUILD ADD build.sh /home/ralph/build.sh
ONBUILD RUN chmod 777 /home/ralph/build.sh
ONBUILD USER root
ONBUILD RUN chown ralph:ralph -R /home/ralph/
ONBUILD RUN mkdir /var/run/sshd
ONBUILD RUN chmod 0755 /var/run/sshd
ONBUILD USER ralph

ONBUILD RUN bash -c "/home/ralph/build.sh"
ONBUILD RUN /home/ralph/bin/ralph collectstatic --noinput
ONBUILD ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

USER root
RUN pip install supervisor-stdout

EXPOSE 8000 22
