#!/bin/bash

FILES=(128.data 256.data 512.data 1024.data)
#FILES=(128.data)
DDIR=../data
ODIR=../data_o
BIN=../bin/pearson

for f in "${FILES[@]}"; do
  echo "Running test on ${DDIR}/${f} ... "
  perf stat --repeat 10 -ddd ./${BIN} ${DDIR}/${f} ${ODIR}/seq_${f}
  perf stat --repeat 10 -M tma_bad_speculation_group ./${BIN} ${DDIR}/${f} ${ODIR}/seq_${f}
  perf stat --repeat 10 -M tma_backend_bound_group ./${BIN} ${DDIR}/${f} ${ODIR}/seq_${f}
done
