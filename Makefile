## build: build the k8s docker image
build:
	@echo "Building kinda docker image...."
	docker build -t kinda .
	@echo "Don!"

## run: runs the dokcer image
run:
	@echo "Running Kinda Cluster"
	docker run -p 6443:6443 -d --name kinda kinda:latest
	@echo "Done!"

