#!/bin/bash

# Jalankan QEMU dengan RDP port forwarding
qemu-system-x86_64 \
    -m 2048 \
    -smp 2 \
    -drive file=/disk.qcow2,format=qcow2 \
    -cdrom /windows.iso \
    -drive file=/virtio.iso,index=1,media=cdrom \
    -boot d \
    -netdev user,id=net0,hostfwd=tcp::3389-:3389,hostfwd=tcp::8006-:8006 \
    -device e1000,netdev=net0 \
    -vnc :0 \
    -cpu host \
    -enable-kvm \
    -daemonize

# Tunggu QEMU jalan
sleep 30

# TCP Proxy ke port 3389
exec socat TCP-LISTEN:3389,fork,reuseaddr TCP:localhost:3389
