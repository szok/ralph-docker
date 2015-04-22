FROM allegrogroup/ralph:base
MAINTAINER PyLabs pylabs@allegrogroup.com

USER ralph
ADD createsuperuser.py /root/createsuperuser.py
ADD init.sh /root/init.sh
#ADD upgrade_ralph.sh /home/ralph/upgrade_ralph.sh
#ADD additional-settings.py /home/ralph/additional-settings.py

USER root
ADD start.sh /root/start.sh
RUN chmod +x /root/start.sh
RUN useradd -ms /bin/bash test
RUN echo "test:pass"|chpasswd

ADD snmpd /etc/default/snmpd


EXPOSE 22 8000

CMD ["/root/start.sh"]
