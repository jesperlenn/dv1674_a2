# Author: David Holmqvist <daae19@student.bth.se>

CXX=g++
CXXFLAGS=-std=c++17 -g -Wunused -Wall -Wunused -O3 -pthread

all: pearson pearson_par verify

# ======= Sequential =======

pearson: vector dataset analysis pearson.cpp 
	$(CXX) $(CXXFLAGS) pearson.cpp vector.o dataset.o analysis.o -o pearson_par

analysis: vector analysis.hpp analysis.cpp
	$(CXX) $(CXXFLAGS) -c analysis.cpp -o analysis.o

dataset: vector dataset.hpp dataset.cpp
	$(CXX) $(CXXFLAGS) -c dataset.cpp -o dataset.o

vector: vector.hpp vector.cpp
	$(CXX) $(CXXFLAGS) -c vector.cpp -o vector.o

# ======= Parallel =======

pearson_par: vector dataset analysis_par pearson.cpp 
	$(CXX) $(CXXFLAGS) -DPAR pearson.cpp vector.o dataset.o analysis.o -o pearson_par

analysis_par: vector analysis.hpp analysis.cpp
	$(CXX) $(CXXFLAGS) -DPAR -c analysis.cpp -o analysis.o

# ======= Verify =======

verify: verify.c
	$(CC) verify.c -o verify

# ======= Clean =======

clean:
	rm -rf verify pearson *.o *.dSYM 2> /dev/null
