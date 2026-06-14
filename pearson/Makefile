all: build_seq build_par

build_seq:
	$(MAKE) -C ./base
	$(MAKE) -C ./optimizers
	$(MAKE) -C ./locality
	$(MAKE) -C ./io
	$(MAKE) -C ./cache
	$(MAKE) -C ./loops
	cp ./io/pearson .

build_par:
	$(MAKE) -C ./multithread
	cp ./multithread/pearson_par ./pearson_par

test: build_seq build_par
	./scripts/test_seq.sh
	./scripts/test_par.sh

test_seq: build_seq
	./scripts/test_seq.sh

test_par: build_par
	./scripts/test_par.sh

clean:
	$(MAKE) clean -C ./base
	$(MAKE) clean -C ./optimizers
	$(MAKE) clean -C ./locality
	$(MAKE) clean -C ./io
	$(MAKE) clean -C ./cache
	$(MAKE) clean -C ./loops
	$(MAKE) clean -C ./multithread
	@rm -f pearson
	@rm -f pearson_par
