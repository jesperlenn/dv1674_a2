
all:
	$(MAKE) -C ./pearson
	$(MAKE) -C ./blur

clean:
	$(MAKE) clean -C ./pearson
	$(MAKE) clean -C ./blur

test:
	$(MAKE) test -C ./pearson
	$(MAKE) test -C ./blur


