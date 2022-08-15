
all: creature-types oddities

creature-types: normal-cards Makefile
	cat normal-cards | sed -e 's/.*—//g' | tr ' ' '\n' | sort | uniq | tee creature-types

oddities: types
	grep '//' types | tee oddities
normal-cards: types
	grep -v '//' types | tee normal-cards

types: page*.json
	cat page*.json | jq --raw-output '.data[].type_line' | tee types

pages:
	./get-pages

clean:
	rm page*.json types
