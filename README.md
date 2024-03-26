# Multi-Tiered Architecture on AWS using Terraform #


I created this initial infrastructure on the AWS console.

For a more challenging project, I have created the same infrastrucure with Terraform, including:

- Autoscaling groups
- Load balancers
- Increased availability by deploying in 2 Availability zones
- 1 Public, 2 Private Subnets in each AZ
- RDS Database

## This three-tiered architecture consists of the following layers: ##

Web Tier - handles incoming user requests and can be horizontally scaled for increased capacity. It includes web servers and load balancers for distributing traffic. 

Application Tier - Application servers run our business logic and interact with the database tier. They can also be horizontally scaled to meet demand.

Database Tier - The database stores and manages our application data. In this architecture, we use Amazon RDS for a managed database service.

I created a blog on my process: https://www.linkedin.com/pulse/multi-tiered-architecture-aws-using-terraform-marshall-doyle-vle1c/?trackingId=dzbzbcQYQHKW3ef6Jt8EpQ%3D%3D
