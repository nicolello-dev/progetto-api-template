CC := gcc
CFLAGS += -DEVAL -std=gnu11 -Wall -Werror -pipe -s -static -O2
LDFLAGS += -lm

all: build gen test

build:
	@mkdir -p dist
	@echo "Building project..."
	$(CC) $(CFLAGS) -o dist/main main.c $(LDFLAGS)

gen:
	@mkdir -p tests/generated
	@echo "Generating test cases..."
	@for i in $$(seq 1 10); do \
		input_file=tests/generated/input_$$i.txt; \
		result_file=$$input_file.result; \
		bin/generator > $$input_file; \
		bin/solver < $$input_file > $$result_file; \
		echo "Generated $$input_file and $$result_file"; \
	done


test: build
	@for file in tests/*.txt tests/generated/*.txt; do \
		echo "Testing $$file"; \
		tmpfile=$$(mktemp); \
		./dist/main < $$file > $$tmpfile; \
		if ! diff -q $$file.result $$tmpfile; then \
			echo "\033[31mTest failed for $$file\033[0m"; \
			printf "\033[1m%-38s %-38s\033[0m\n" "EXPECTED" "ACTUAL"; \
			echo "\033[31m----------------------------------------\033[0m"; \
			diff --color=always -y -W 80 $$file.result $$tmpfile; \
			rm $$tmpfile; \
			exit 1; \
		else \
			echo "\033[32mTest passed for $$file\033[0m"; \
		fi; \
		rm $$tmpfile; \
	done
	@echo "\033[32mAll tests passed!\033[0m"

.PHONY: project gen test clean

clean:
	rm -f *.o dist/main
	rm -rf tests/generated dist/