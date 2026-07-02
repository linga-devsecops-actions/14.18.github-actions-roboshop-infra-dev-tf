locals {
      private_subnet_ids = data.aws_ssm_parameter.private_subnet_ids.value
      eks_control_plane_sg_id      = data.aws_ssm_parameter.eks_control_plane_sg_id.value
      eks_node_sg_id         = data.aws_ssm_parameter.eks_node_sg_id.value
      vpc_id             = data.aws_ssm_parameter.vpc_id.value
}
