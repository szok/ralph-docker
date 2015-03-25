FROM      ubuntu:12.04
MAINTAINER PyLabs pylabs@allegrogroup.com

ADD provision.sh /root/provision.sh
RUN /root/provision.sh

RUN adduser --disabled-password --home=/home/ralph --gecos "" ralph
ENV HOME /home/ralph
USER ralph
RUN virtualenv /home/ralph/ && /home/ralph/bin/pip install pip==1.5.6 && /home/ralph/bin/pip install setuptools==3.6 && mkdir /home/ralph/.ralph

ADD fixtures.py /home/ralph/fixtures.py
ONBUILD ADD ./sources /home/ralph/sources/
ONBUILD USER root
ONBUILD RUN chown ralph:ralph -R /home/ralph/
ONBUILD USER ralph
ONBUILD RUN bash -c "cd /home/ralph/; . /home/ralph/bin/activate; cd sources && make install"
ONBUILD RUN /home/ralph/bin/ralph collectstatic --noinput
ONBUILD ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf


USER root 
RUN pip install supervisor-stdout

EXPOSE 8000 22