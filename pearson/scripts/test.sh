FILES=(128 256 512 1024)
DDIR=../data
ODIR=../data_o
BIN=../pearson

for f in "${FILES[@]}"; do
  perf stat -d --repeat 10 ./${BIN} ${DDIR}/${f}.data ${ODIR}/${f}_seq.data
done
