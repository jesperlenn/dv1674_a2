
build: build_seq build_par

build_seq:
	$(MAKE) -C ./base
	$(MAKE) -C ./precompute
	$(MAKE) -C ./direct
	$(MAKE) -C ./linear

build_par:
	$(MAKE) -C ./multithread

test: test_seq test_par

test_seq: build_seq
	./scripts/test_seq.sh

test_par: build_par
	./scripts/test_par.sh
