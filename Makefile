
all: creature-types

creature-types: sub-types Makefile
	grep -w -E -v "Blood|Clue|Contraption|Equipment|Food|Fortification|Gold|Treasure|Vehicle" sub-types | tee creature-types

sub-types: ac-type-lines
	cat ac-type-lines | sed -e 's/.*—//g' | tr ' ' '\n' | sort | uniq | tee sub-types

ac-type-lines: normal-cards oddities
	cat oddities  | sed -e 's| // |\n|g' | grep Artifact | grep Creature >ac-type-lines
	cat normal-cards >>ac-type-lines

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
