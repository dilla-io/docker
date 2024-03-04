build:
	@docker build -t test-dilla-ci --build-arg GITHUB_TOKEN=$$GITHUB_TOKEN .

test:
	@docker run -d --rm -u 0 --name test-ci-dilla -v $$(pwd)/tests:/tests test-dilla-ci:latest tail -f /dev/null
	@docker exec test-ci-dilla /tests/prepare-tests.sh test-ci-dilla
	@docker exec -w /tests test-ci-dilla pytest-3
	@docker kill test-ci-dilla