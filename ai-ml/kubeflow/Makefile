SHELL := /bin/bash # Use bash syntax

deploy: init \
 create-vpc \
 create-eks-cluster \
 deploy-eks-blueprints-addons \
 deploy-kubeflow-components
	terraform apply -auto-approve

delete: delete-kubeflow-components \
 delete-eks-blueprints-addons \
 delete-eks-cluster \
 delete-vpc
	terraform destroy -auto-approve

init:
	terraform init

create-vpc:
	terraform apply -target="module.vpc" -auto-approve

create-eks-cluster:
	terraform apply -target="module.eks" -auto-approve
	terraform output -raw configure_kubectl | bash

deploy-eks-blueprints-addons:
	terraform apply -target="module.eks_blueprints_addons" -target="module.ebs_csi_driver_irsa" -auto-approve

deploy-kubeflow-components:
	terraform apply -target="module.kubeflow_components" -auto-approve

delete-vpc:
	terraform destroy -target="module.vpc" -auto-approve

delete-eks-cluster:
	terraform destroy -target="module.eks" -auto-approve

delete-eks-blueprints-addons:
	terraform destroy -target="module.eks_blueprints_addons" -auto-approve

delete-kubeflow-components:
	terraform destroy -target="module.kubeflow_components" -auto-approve

# don't create executables
.PHONY: *
