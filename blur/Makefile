
build: build_seq build_par

build_seq:
	$(MAKE) -C ./base
	$(MAKE) -C ./precompute
	$(MAKE) -C ./direct
	$(MAKE) -C ./linear

build_par:
	$(MAKE) -C ./multithread
