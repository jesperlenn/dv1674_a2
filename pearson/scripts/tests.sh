#!/bin/bash

FILES=(128.data 256.data 512.data 1024.data)
#FILES=(1024.data)
DDIR=data
ODIR=data_o
BIN=./pearson
PBIN=./pearson_par

for f in "${FILES[@]}"; do
  echo "Running threaded tests ... "
  for t in {0..5}; do
    thread=$((2 ** t))
    perf stat --repeat 10 -d ./${PBIN} ${DDIR}/${f} ${ODIR}/seq_${f} ${thread}
  done
done
