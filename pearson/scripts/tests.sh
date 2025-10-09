#!/bin/bash

#FILES=(128.data 256.data 512.data 1024.data)
FILES=(128.data)
DDIR=data
ODIR=data_o
BIN=pearson

for f in "${FILES[@]}"; do
  echo "Running test on ${DDIR}/${f} ... "
  echo 0 >/proc/sys/kernel/nmi_watchdog
  perf stat -M tma_ports_utilized_3m_group ./${BIN} ${DDIR}/${f} ${ODIR}/seq_${f}
  echo 1 >/proc/sys/kernel/nmi_watchdog
done
