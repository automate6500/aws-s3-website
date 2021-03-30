TAG    = $(shell git rev-parse --short HEAD)
BRANCH = $(shell git branch --show-current)
IGNORE = -x "*.git*" -x "*terraform*" -x "*~" -x "*.zip"

zip: check docs
	$(shell [ $(BRANCH) == 'default' ])
	zip -r ../zips/$(notdir $(CURDIR)).zip . $(IGNORE)
	zip -r ../zips/$(notdir $(CURDIR))-$(BRANCH)-$(TAG).zip . $(IGNORE)
	ls -ltr ../zips/

clean:
	rm -vf ../zips/$(notdir $(CURDIR))*.zip

docs:
	terraform-docs markdown . > README.md

check:
	@ if [ "${BRANCH}" != "default" ]; then \
		echo "Zips should only be created from the default branch. BRANCH == $(BRANCH)"; \
		exit 99; \
	fi

all: clean zip

.PHONY: zip clean docs check all
