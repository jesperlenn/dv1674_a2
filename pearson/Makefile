# Author: David Holmqvist <daae19@student.bth.se>

CXX=g++
CXXFLAGS=-std=c++17 -g -Wunused -Wall -Wunused

DOBJ=obj
DBIN=bin
DSRC=src
DINC=inc

all: pearson verify

pearson: vector dataset analysis pearson.cpp ${DBIN}
	$(CXX) $(CXXFLAGS) ${DSRC}/pearson.cpp ${DOBJ}/vector.o ${DOBJ}/dataset.o ${DOBJ}/analysis.o -o ${DBIN}/pearson

analysis: vector analysis.hpp analysis.cpp
	$(CXX) $(CXXFLAGS) -c ${DSRC}/analysis.cpp -o ${DOBJ}/analysis.o

dataset: vector dataset.hpp dataset.cpp
	$(CXX) $(CXXFLAGS) -c ${DSRC}/dataset.cpp -o ${DOBJ}/dataset.o

vector: vector.hpp vector.cpp ${DOBJ}
	$(CXX) $(CXXFLAGS) -c ${DSRC}/vector.cpp -o ${DOBJ}/vector.o

verify: verify.c ${DBIN}
	$(CC) verify.c -o  ${DBIN}/verify

${DBIN}:
	mkdir -p ${DBIN}

${DOBJ}:
	mkdir -p ${DOBJ}

clean:
	rm -rf ${DBIN} ${DOBJ} *.dSYM 2> /dev/null
