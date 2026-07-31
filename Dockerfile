FROM ubuntu:22.04

# Update & install dependencies
RUN apt update && apt install -y \
    qemu-system-x86_64 \
    qemu-utils \
    wget \
    curl \
    unzip \
    xz-utils \
    socat \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Download Windows Server 2022 ISO (eval version)
RUN wget -O /windows.iso "https://go.microsoft.com/fwlink/p/?linkid=2195330" || \
    wget -O /windows.iso "https://archive.org/download/windows-server-2022-english-x-64/windows_server_2022_english_x64.iso"

# Download VirtIO drivers (buat network)
RUN wget -O /virtio.iso "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"

# Buat disk image (20GB)
RUN qemu-img create -f qcow2 /disk.qcow2 20G

# Buat autounattend.xml (auto install windows)
COPY autounattend.xml /autounattend.xml

# Buat startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Buat supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 3389 5900 8006

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
