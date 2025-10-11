FILES=(128 256 512 1024)
DDIR=../data
ODIR=../data_o
RDIR=../result
BIN=../pearson

if [ $# != 1 ]; then
  echo "./test.sh [result test name]"
  exit 1
fi

mkdir -p ${RDIR}/${1}
mkdir -p ${RDIR}/${1}/callgrind
mkdir -p ${RDIR}/${1}/massif

echo "" >${RDIR}/${1}/perf.data

for f in "${FILES[@]}"; do
  echo -n "running perf stat ${f} ... "
  perf stat -o ${RDIR}/${1}/perf.data --append -d --repeat 10 ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data
  echo "done."
done

rm -f ${RDIR}/${1}/callgrind/*
for f in "${FILES[@]}"; do
  echo -n "Running callgrind ${f} ... "
  valgrind -q --tool=callgrind --callgrind-out-file=${RDIR}/${1}/callgrind/callgrind.out.%p ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data
  echo "done."
done

rm -f ${RDIR}/${1}/massif/*
for f in "${FILES[@]}"; do
  echo -n "Running massif ${f} ... "
  valgrind -q --tool=massif --massif-out-file=${RDIR}/${1}/massif/massif.out.%p ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data
  echo "done."
done

notify-send "Tests done."
