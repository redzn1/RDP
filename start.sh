#!/bin/bash

qemu-system-x86_64 \
    -m 1024 \
    -smp 1 \
    -drive file=/disk.qcow2,format=qcow2 \
    -cdrom /windows.iso \
    -boot d \
    -netdev user,id=net0,hostfwd=tcp::3389-:3389 \
    -device e1000,netdev=net0 \
    -vnc :0 \
    -nographic

# Ga pake socat, langsung forward
