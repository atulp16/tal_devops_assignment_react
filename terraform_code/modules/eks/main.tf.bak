# Fetch the latest EKS-optimized AMI for Linux for your cluster version.
data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  most_recent = true
  owners      = ["602401143452"]
}

# Create a launch template that uses the provided key pair and includes the bootstrap script.
resource "aws_launch_template" "node_group_lt" {
  name_prefix   = "${var.cluster_name}-node-"
  image_id      = data.aws_ami.eks_worker.id
  instance_type = "t3.medium"  # Adjust as needed.
  key_name      = var.key_name

  # The bootstrap script enables the instance to join the EKS cluster.
  user_data = base64encode(<<EOF
#!/bin/bash
/etc/eks/bootstrap.sh ${var.cluster_name} --kubelet-extra-args '--node-labels=role=worker'
EOF
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }
}

# Create the EKS cluster.
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

# Create the EKS node group using the launch template.
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_instance_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  launch_template {
    id      = aws_launch_template.node_group_lt.id
    version = "$Latest"
  }

  depends_on = [
    aws_eks_cluster.this
  ]
}
