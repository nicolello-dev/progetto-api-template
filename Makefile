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
		./dist/main < $$file | diff - $$file.result; \
		if [ $$? -ne 0 ]; then \
			echo "Test failed for $$file"; \
			exit 1; \
		else \
			echo "Test passed for $$file"; \
		fi; \
	done
	echo "All tests passed!"

.PHONY: project gen test clean

clean:
	rm -f *.o dist/main
	rm -rf tests/generated dist/