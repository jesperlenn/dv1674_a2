#!/bin/bash

FILES=(im1 im2 im3 im4)
DDIR=data
ODIR=data_o
RDIR=result/multithread
BIN=multithread/blur_par
THREADS=(1 2 4 8 16 32 64)

for t in "${THREADS[@]}"; do
  mkdir -p ${RDIR}/${1}/${t}
  # mkdir -p ${RDIR}/${1}/${t}/callgrind
  mkdir -p ${RDIR}/${1}/${t}/massif

  echo "" >${RDIR}/${1}/${t}/perf.data

  for f in "${FILES[@]}"; do
    echo -n "Validating with ${t} threads ${f} ... "
    ${BIN} 15 "./data/${f}.ppm" "./data_o/blur_${f}_blurred.ppm" ${t}

    if ! cmp -s "./data_o/${f}_verified.ppm" "./data_o/blur_${f}_blurred.ppm"
    then
        echo "${red}Error: Incongruent output data detected when blurring image ${f}.ppm"
        exit 1
    fi
    echo "done."
  done

  for f in "${FILES[@]}"; do
    echo -n "running perf stat with ${t} threads ${f} ... "
    perf stat -o ${RDIR}/${1}/${t}/perf.data --append -d --repeat 10 ./${BIN} 15 "./data/${f}.ppm" "./data_o/blur_${f}_blurred.ppm" ${t}
    echo "done."
  done

  # rm -f ${RDIR}/${1}/${t}/callgrind/*
  # for f in "${FILES[@]}"; do
  #   echo -n "Running callgrind with ${t} threads ${f} ... "
  #   valgrind -q --tool=callgrind --separate-threads=yes --callgrind-out-file=${RDIR}/${1}/${t}/callgrind/callgrind.out.%p ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data ${t}
  #   echo "done."
  # done

  rm -f ${RDIR}/${1}/${t}/massif/*
  for f in "${FILES[@]}"; do
    echo -n "Running massif with ${t} threads ${f} ... "
    valgrind -q --tool=massif --massif-out-file=${RDIR}/${1}/${t}/massif/massif.out.%p ./${BIN} 15 "./data/${f}.ppm" "./data_o/blur_${f}_blurred.ppm" ${t}
    echo "done."
  done
done

notify-send "Tests done."
