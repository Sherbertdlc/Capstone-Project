# Capstone-Project

The idea behind this project is to host my website on a server - with the files from persistent source (s3 bucket).

- I created a simple html layout for my personal one pager CV. 
- I altered the css file to stylise my website.

I created the initial infrastructure on the AWS console.

For a more challenging project, I have created the same infrastrucure with Terraform, including the addition of:

- Autoscaling group
- Load balancer 
- Increased availability by deploying in 2 Availability zones
- 1 Public, 2 Private Subnets in each AZ
- Database
The new infrastructure represents a Three-Tiered Web Application - Web, Application and Database.
