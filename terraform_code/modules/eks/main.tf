# Fetch the latest EKS-optimized AMI for Linux for your cluster version.
data "aws_ami" "eks_worker" {
  most_recent = true
  owners      = ["602401143452"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-1.*"]  # Ensures it's an official EKS AMI
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Create a launch template that uses the provided key pair and includes the bootstrap script.
resource "aws_launch_template" "node_group_lt" {
  name_prefix   = "${var.cluster_name}-node-"
  image_id      = data.aws_ami.eks_worker.id
  instance_type = "t3.medium"  # Adjust as needed.
  key_name      = var.key_name

  user_data = base64encode(<<EOF
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${var.cluster_name} --kubelet-extra-args '--node-labels=role=worker'
EOF
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }

  }

  # Apply common tags to EC2 instances created by this template
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      "Name" = "${var.cluster_name}-worker-node"
    })
  }
}

# Create Security Group for EKS Cluster Control Plane
resource "aws_security_group" "eks_control_plane" {
  name        = "${var.cluster_name}-control-plane"
  description = "EKS Control Plane Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow worker nodes to communicate with EKS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_worker_nodes.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group for Worker Nodes
resource "aws_security_group" "eks_worker_nodes" {
  name        = "${var.cluster_name}-worker-nodes"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all traffic between worker nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EKS cluster.
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.eks_control_plane.id]
  }

  # Apply common tags to the EKS Cluster
  tags = merge(var.common_tags, {
    "Name" = "${var.cluster_name}-eks-cluster"
  })

  depends_on = [aws_security_group.eks_control_plane]
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

  # Apply common tags to the node group
  tags = merge(var.common_tags, {
    "Name" = "${var.cluster_name}-node-group"
  })

  depends_on = [
    aws_eks_cluster.this,
    aws_security_group.eks_worker_nodes
  ]
}
