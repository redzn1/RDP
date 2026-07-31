FROM debian:bullseye-slim

RUN apt update && apt install -y \
    qemu-system-x86 \
    qemu-utils \
    wget \
    socat \
    && rm -rf /var/lib/apt/lists/*

# Download Windows ISO (pake yang kecil)
RUN wget -O /windows.iso "https://go.microsoft.com/fwlink/p/?linkid=2195330"

# Buat disk
RUN qemu-img create -f qcow2 /disk.qcow2 10G

# Auto install
COPY autounattend.xml /autounattend.xml
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3389

CMD ["/start.sh"]
