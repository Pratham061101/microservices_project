.PHONY: help
help:
	@echo "Targets:"
	@echo "  bootstrap   - install/check tools (docker/kubectl/kind/helm)"
	@echo "  kind-up     - create kind cluster"
	@echo "  kind-down   - delete kind cluster"
	@echo "  miniblue-docker - run miniblue via docker"
