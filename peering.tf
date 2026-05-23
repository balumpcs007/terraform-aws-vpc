resource "aws_vpc_peering_connection" "default" {
count = var.is_peering_requied ? 1 : 0
  peer_vpc_id   = data.aws_vpc.default.id # accepter Default vpc id
  vpc_id        = aws_vpc.main.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  auto_accept = true

   tags = merge(
    var.vpc_tags,
    local.comman_tags,
    {
        Name = "${local.comman_name_suffix}-default"
    }
  )
}

## Public route
resource "aws_route" "public-peering" {
count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

## Default route
resource "aws_route" "default-peering" {
count = var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}
