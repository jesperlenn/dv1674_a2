#!/bin/bash

set -e

FILES=(im1 im2 im3 im4)
VERSIONS=(base precompute direct linear)
DDIR=./data
ODIR=./data_o
RDIR=./result

red=$(tput setaf 1)

for ver in "${VERSIONS[@]}"
do
  echo
  echo "=== Testing ${ver} ==="
  BIN=./${ver}/blur

  mkdir -p ${RDIR}/${ver}
  # mkdir -p ${RDIR}/${ver}/callgrind
  mkdir -p ${RDIR}/${ver}/massif

  echo "" >${RDIR}/${ver}/perf.data

  for f in "${FILES[@]}"; do
    echo -n "Validating ${f} ... "
    ${BIN} 15 "./data/${f}.ppm" "./data_o/blur_${f}_blurred.ppm" 

    if ! cmp -s "./data_o/${f}_verified.ppm" "./data_o/blur_${f}_blurred.ppm"
    then
        echo "${red}Error: Incongruent output data detected when blurring image ${f}.ppm"
        exit 1
    fi
    echo "done."
  done

  for f in "${FILES[@]}"; do
    echo -n "running perf stat ${f} ... "
    perf stat -o ${RDIR}/${ver}/perf.data --append -d --repeat 10 ./${BIN} 15 ${DDIR}/${f}.ppm ${ODIR}/${f}_seq.ppm
    echo "done."
  done

  # rm -f ${RDIR}/${ver}/callgrind/*
  # for f in "${FILES[@]}"; do
  #   echo -n "Running callgrind ${f} ... "
  #   valgrind -q --tool=callgrind --cache-sim=yes --branch-sim=yes --dump-instr=yes --callgrind-out-file=${RDIR}/${ver}/callgrind/callgrind.out.%p ./${BIN} 15 ${DDIR}/${f}.ppm ${ODIR}/${f}_seq.ppm 2> /dev/null
  #   echo "done."
  # done

  rm -f ${RDIR}/${1}/massif/*
  for f in "${FILES[@]}"; do
    echo -n "Running massif ${f} ... "
    valgrind -q --tool=massif --massif-out-file=${RDIR}/${ver}/massif/massif.out.%p ./${BIN} 15 ${DDIR}/${f}.ppm ${ODIR}/${f}_seq.ppm 2> /dev/null
    echo "done."
  done

  echo "Finished testing ${ver}"
done

notify-send "Tests done."
