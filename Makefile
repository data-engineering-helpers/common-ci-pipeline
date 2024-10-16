## HELP

.DEFAULT_GOAL:=help

help: ## Display the help menu.
	@grep -h "\#\#" $(MAKEFILE_LIST)

isset-%: ## Test if variable % is set or exit with error
	# @: $(if $(value $*),,$(error Variable $* is not set))

upgrade: isset-version ## Upgrades the repo version
	@echo $(version) > VERSION;
	@make upgrade-github-actions version=$(version)

upgrade-github-actions: isset-version
	sed -i.bak -r 's,^      uses: data-engineering-helpers/common-ci-pipeline/.github/actions/(.*)@.*,      uses: data-engineering-helpers/common-ci-pipeline/.github/actions/\1@$(version),' .github/actions/**/action.yml && rm .github/actions/**/action.yml.bak