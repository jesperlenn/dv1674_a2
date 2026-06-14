#!/bin/bash

set -e

FILES=(128 256 512 1024)
# VERSIONS=(base optimizers cache io locality loops alignment)
VERSIONS=(loops)
DDIR=./data
ODIR=./data_o
RDIR=./result

for ver in "${VERSIONS[@]}"
do
  echo "Testing ${ver}"
  BIN=./${ver}/pearson
  VBIN=./${ver}/verify

  mkdir -p ${RDIR}/${ver}
  mkdir -p ${RDIR}/${ver}/callgrind
  mkdir -p ${RDIR}/${ver}/massif

  echo "" >${RDIR}/${ver}/perf.data

  for f in "${FILES[@]}"; do
    echo -n "Validating ${f} ... "
    ${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data
    ${VBIN} ${ODIR}/${f}_ref.data ${ODIR}/${f}_seq.data
    echo "done."
  done

  for f in "${FILES[@]}"; do
    echo -n "running perf stat ${f} ... "
    perf stat -o ${RDIR}/${ver}/perf.data --append -d --repeat 10 ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data
    echo "done."
  done

  rm -f ${RDIR}/${ver}/callgrind/*
  for f in "${FILES[@]}"; do
    echo -n "Running callgrind ${f} ... "
    valgrind -q --tool=callgrind --cache-sim=yes --branch-sim=yes --dump-instr=yes --callgrind-out-file=${RDIR}/${ver}/callgrind/callgrind.out.%p ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data
    echo "done."
  done

  rm -f ${RDIR}/${1}/massif/*
  for f in "${FILES[@]}"; do
    echo -n "Running massif ${f} ... "
    valgrind -q --tool=massif --massif-out-file=${RDIR}/${ver}/massif/massif.out.%p ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data
    echo "done."
  done

  echo "Finished testing ${ver}"
done

notify-send "Tests done."
