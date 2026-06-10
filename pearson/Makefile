build_seq:
	$(MAKE) -C ./base
	$(MAKE) -C ./optimizers
	$(MAKE) -C ./locality
	$(MAKE) -C ./io
	$(MAKE) -C ./cache
	$(MAKE) -C ./loops
	$(MAKE) -C ./alignment

build_par:
	$(MAKE) -C ./multithread

test_all: build_seq build_par
	./scripts/test_seq.sh
	./scripts/test_par.sh

test_seq: build_seq
	./scripts/test_seq.sh

test_par: build_par
	./scripts/test_par.sh
