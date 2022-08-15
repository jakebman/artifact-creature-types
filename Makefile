
all: creature-types tribal-type-lines

creature-types: sub-types
	grep -w -E -v "Blood|Clue|Contraption|Equipment|Food|Fortification|Gold|Treasure|Vehicle" sub-types | tee creature-types


sub-types: ac-type-lines
	cat ac-type-lines | sed -e 's/.*—//g' | tr ' ' '\n' | sort | uniq | tee sub-types
tribal-sub-types: tribal-type-lines
	cat tribal-type-lines | sed -e 's/.*—//g' | tr ' ' '\n' | sort | uniq | tee tribal-sub-types

ac-type-lines: normal-cards oddities
	cat oddities  | sed -e 's| // |\n|g' | grep Artifact | grep Creature >ac-type-lines
	cat normal-cards | grep Artifact | grep Creature >>ac-type-lines
tribal-type-lines: normal-cards oddities
	(cat oddities |  sed -e 's| // |\n|g' | grep Artifact | grep Tribal || true) >tribal-type-lines
	cat normal-cards | grep Artifact | grep Tribal >>tribal-type-lines


oddities: types
	grep '//' types | tee oddities
normal-cards: types
	grep -v '//' types | tee normal-cards

types: .made-pages
	cat page*.json | jq --raw-output '.data[].type_line' | tee types

.made-pages:
	./get-pages
	touch .made-pages

clean:
	rm page*.json types *-type-lines *-types oddities normal-cards .made-pages ||echo "it's okay to fail rm"
