#!/bin/bash

FILES=(128 256 512 1024)
DDIR=data
ODIR=data_o
RDIR=result/multithread
BIN=multithread/pearson_par
VBIN=multithread/verify
THREADS=(1 2 4 8 16 32 64)

for t in "${THREADS[@]}"; do
  mkdir -p ${RDIR}/${1}/${t}
  mkdir -p ${RDIR}/${1}/${t}/callgrind
  mkdir -p ${RDIR}/${1}/${t}/massif

  echo "" >${RDIR}/${1}/${t}/perf.data

  for f in "${FILES[@]}"; do
    echo -n "Validating ${f} ... "
    ${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data
    ${VBIN} ${ODIR}/${f}_ref.data ${ODIR}/${f}_seq.data
    echo "done."
  done

  # for f in "${FILES[@]}"; do
  #   echo -n "running perf stat with ${t} threads ${f} ... "
  #   perf stat -o ${RDIR}/${1}/${t}/perf.data --append -d --repeat 10 ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data ${t}
  #   echo "done."
  # done
  #
  # rm -f ${RDIR}/${1}/${t}/callgrind/*
  # for f in "${FILES[@]}"; do
  #   echo -n "Running callgrind with ${t} threads ${f} ... "
  #   valgrind -q --tool=callgrind --separate-threads=yes --callgrind-out-file=${RDIR}/${1}/${t}/callgrind/callgrind.out.%p ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data ${t}
  #   echo "done."
  # done
  #
  # rm -f ${RDIR}/${1}/${t}/massif/*
  # for f in "${FILES[@]}"; do
  #   echo -n "Running massif with ${t} threads ${f} ... "
  #   valgrind -q --tool=massif --massif-out-file=${RDIR}/${1}/${t}/massif/massif.out.%p ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data ${t}
  #   echo "done."
  # done
done

notify-send "Tests done."
