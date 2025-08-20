CC := gcc
DFLAGS := -DEVAL -std=gnu11 -Wall -Werror -pipe
CFLAGS += $(DFLAGS) -s -static -O2
CFLAGSDBG = $(DFLAGS) -g -O0 -fno-omit-frame-pointer
LDFLAGS += -lm
DBG_INPUT_FILE = tests/example.txt

all: build gen solve test

build:
	@mkdir -p dist
	@echo "Building project..."
	$(CC) $(CFLAGS) -o dist/main main.c $(LDFLAGS)

debug: build
	@echo "Building project in debug mode..."
	$(CC) $(CFLAGSDBG) -o dist/main-debug main.c $(LDFLAGS)
	@echo "### Running memgrind ###"
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --expensive-definedness-checks=yes --dsymutil=yes ./dist/main-debug < $(DBG_INPUT_FILE) > /dev/null
	@echo "### Running cachegrind ###"
	valgrind --tool=cachegrind ./dist/main-debug < $(DBG_INPUT_FILE) > /dev/null
	@echo "### Running callgrind ###"
	valgrind --tool=callgrind ./dist/main-debug < $(DBG_INPUT_FILE) > /dev/null

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

update:
	@git stash
	@git pull
	@git stash pop

solve:
	@echo "Solving test cases..."
	@echo "This may take a very long time"
	@for file in tests/*.txt tests/generated/*.txt; do \
		if [ ! -f $$file.result ]; then \
			echo "Solving $$file"; \
			result_file=$$file.result; \
			bin/solver < $$file > $$result_file; \
			echo "Solved $$file and created $$result_file"; \
		else \
			echo "Skipping $$file, already solved."; \
		fi; \
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
	rm -f callgrind.out.*
	rm -f cachegrind.out.*