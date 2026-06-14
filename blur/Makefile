
all: build_seq build_par

build_seq:
	$(MAKE) -C ./base
	$(MAKE) -C ./precompute
	$(MAKE) -C ./direct
	$(MAKE) -C ./linear
	cp ./linear/blur .

build_par:
	$(MAKE) -C ./multithread
	cp ./multithread/blur_par .

test: test_seq test_par

test_seq: build_seq
	./scripts/test_seq.sh

test_par: build_par
	./scripts/test_par.sh

clean:
	$(MAKE) clean -C ./base
	$(MAKE) clean -C ./precompute
	$(MAKE) clean -C ./direct
	$(MAKE) clean -C ./linear
	$(MAKE) clean -C ./multithread
	@rm -f ./blur_par
	@rm -f ./blur

