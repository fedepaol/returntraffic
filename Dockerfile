FROM fedora:37

RUN dnf install -y netcat tcpdump
RUN dnf install -y iproute
