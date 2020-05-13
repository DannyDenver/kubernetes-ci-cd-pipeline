
lint: 
	./hadolint Dockerfile

build: 
	eksctl create cluster \
		--name kubernetes-cluster \
		--region us-east-2 \
		--nodegroup-name node-workers \
		--node-type t2.micro \
		--nodes 3 \
		--nodes-min 2 \
		--nodes-max 4 \
		--managed