# KubeFlow on EKS

---
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0, < 6.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.13.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.7.0 |
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider\_aws.virginia) | 5.7.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ebs_csi_driver_irsa"></a> [ebs\_csi\_driver\_irsa](#module\_ebs\_csi\_driver\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.20 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 19.13 |
| <a name="module_eks_blueprints_addons"></a> [eks\_blueprints\_addons](#module\_eks\_blueprints\_addons) | aws-ia/eks-blueprints-addons/aws | ~> 1.0 |
| <a name="module_eks_blueprints_outputs"></a> [eks\_blueprints\_outputs](#module\_eks\_blueprints\_outputs) | ./modules/blueprints-extended-outputs | n/a |
| <a name="module_kubeflow_components"></a> [kubeflow\_components](#module\_kubeflow\_components) | ./modules/kubeflow-components | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.karpenter_node_template_cpu](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_node_template_gpu](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_provisioner_cpu](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_provisioner_gpu](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [aws_ec2_instance_type_offerings.availability_zones_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type_offerings) | data source |
| [aws_ec2_instance_type_offerings.availability_zones_gpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type_offerings) | data source |
| [aws_ecrpublic_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecrpublic_authorization_token) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of cluster | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.27`) | `string` | `"1.27"` | no |
| <a name="input_enable_aws_telemetry"></a> [enable\_aws\_telemetry](#input\_enable\_aws\_telemetry) | Enable AWS telemetry component | `bool` | `true` | no |
| <a name="input_kf_helm_repo_path"></a> [kf\_helm\_repo\_path](#input\_kf\_helm\_repo\_path) | Full path to the location of the helm repo for KF | `string` | `"../../.."` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | The instance type of an EKS node | `string` | `"m5.xlarge"` | no |
| <a name="input_node_instance_type_gpu"></a> [node\_instance\_type\_gpu](#input\_node\_instance\_type\_gpu) | The instance type of a gpu EKS node. Will result in the creation of a separate gpu node group when not null | `string` | `null` | no |
| <a name="input_notebook_cull_idle_time"></a> [notebook\_cull\_idle\_time](#input\_notebook\_cull\_idle\_time) | If a Notebook's LAST\_ACTIVITY\_ANNOTATION from the current timestamp exceeds this value then the Notebook will be scaled to zero (culled). ENABLE\_CULLING must be set to 'true' for this setting to take effect.(minutes) | `string` | `30` | no |
| <a name="input_notebook_enable_culling"></a> [notebook\_enable\_culling](#input\_notebook\_enable\_culling) | Enable Notebook culling feature. If set to true then the Notebook Controller will scale all Notebooks with Last activity older than the notebook\_cull\_idle\_time to zero | `string` | `false` | no |
| <a name="input_notebook_idleness_check_period"></a> [notebook\_idleness\_check\_period](#input\_notebook\_idleness\_check\_period) | How frequently the controller should poll each Notebook to update its LAST\_ACTIVITY\_ANNOTATION (minutes) | `string` | `5` | no |
| <a name="input_region"></a> [region](#input\_region) | Region to create the cluster | `string` | n/a | yes |
| <a name="input_using_gpu"></a> [using\_gpu](#input\_using\_gpu) | Whenether using GPU instances. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_configure_kubectl"></a> [configure\_kubectl](#output\_configure\_kubectl) | Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | EKS cluster ID |
| <a name="output_eks_managed_nodegroups"></a> [eks\_managed\_nodegroups](#output\_eks\_managed\_nodegroups) | EKS managed node groups |
| <a name="output_region"></a> [region](#output\_region) | AWS region |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | VPC CIDR |
| <a name="output_vpc_private_subnet_cidr"></a> [vpc\_private\_subnet\_cidr](#output\_vpc\_private\_subnet\_cidr) | VPC private subnet CIDR |
| <a name="output_vpc_public_subnet_cidr"></a> [vpc\_public\_subnet\_cidr](#output\_vpc\_public\_subnet\_cidr) | VPC public subnet CIDR |
