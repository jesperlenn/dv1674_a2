# Author: David Holmqvist <daae19@student.bth.se>

CXX=g++
CXXFLAGS=-std=c++17 -g -Wunused -Wall -Wunused -pthread

DOBJ=obj
DBIN=bin
DSRC=src
DINC=inc

all: pearson_par

pearson_par: vector dataset analysis ${DSRC}/pearson.cpp ${DBIN}
	$(CXX) $(CXXFLAGS) ${DSRC}/pearson.cpp ${DOBJ}/vector.o ${DOBJ}/dataset.o ${DOBJ}/analysis.o -o ${DBIN}/pearson_par

analysis: vector ${DINC}/analysis.hpp ${DSRC}/analysis.cpp
	$(CXX) $(CXXFLAGS) -c ${DSRC}/analysis.cpp -o ${DOBJ}/analysis.o

dataset: vector ${DINC}/dataset.hpp ${DSRC}/dataset.cpp
	$(CXX) $(CXXFLAGS) -c ${DSRC}/dataset.cpp -o ${DOBJ}/dataset.o

vector: ${DINC}/vector.hpp ${DSRC}/vector.cpp ${DOBJ}
	$(CXX) $(CXXFLAGS) -c ${DSRC}/vector.cpp -o ${DOBJ}/vector.o

${DBIN}:
	mkdir -p ${DBIN}

${DOBJ}:
	mkdir -p ${DOBJ}

clean:
	rm -rf ${DBIN} ${DOBJ} *.dSYM 2> /dev/null
