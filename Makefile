## build: build the k8s docker image
build:
	@echo "Building kinda docker image...."
	docker build -t kinda .
	@echo "Done!"

## run: runs the dokcer image
run:
	@echo "Running Kinda Cluster"
	docker run -p 6443:6443 -d --name kinda kinda:latest
	@echo "Done!"

## rerun: deletes the container builds the container with new entrypoint shell and runs it
rerun:
	@echo "Deleting Kinda from docker..."
	docker rm kinda
	@echo "Building the container with new shell..."
	docker build -t kinda .
	@echo "Running the updated Container"
	docker run -p 6443:6443 -d --name kinda kinda:latest
	@echo "Done!"