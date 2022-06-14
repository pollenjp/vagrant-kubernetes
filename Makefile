SHELL := /bin/bash

.PHONY: up
up:  ## run servers
	vagrant up

.PHONY: re-run
re-run:  ## clean and run servers
	${MAKE} clean
	${MAKE} up

.PHONY: halt
halt:  ## halt vagrant
	vagrant halt

.PHONY: clean
clean:  ## clean all
	${MAKE} halt
	vagrant destroy -f

.PHONY : help
help:  ## show help
	@cat $(MAKEFILE_LIST) \
		| grep -E '^[.a-zA-Z0-9_-]+ *:.*##.*' \
		| xargs -I'<>' \
			bash -c "\
				printf '<>' | awk -F'[:]' '{ printf \"\033[36m%-15s\033[0m\", \$$1 }'; \
				printf '<>' | awk -F'[##]' '{ printf \"%s\n\", \$$3 }'; \
			"
