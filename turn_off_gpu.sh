#!/usr/bin/env sh
nvidia-smi --id 0000:64:00.0 --persistence-mode 0
nvidia-smi drain --pciid 0000:64:00.0 --modify 1
nvidia-smi --persistence-mode 1

