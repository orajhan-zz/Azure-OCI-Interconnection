# Azure Oracle Cloud nterconnection

Oracle has partnered with Microsoft to provide low latency, private connectivity between Oracle Cloud and Microsoft Azure. 
Please refer to https://docs.oracle.com/en/solutions/learn-azure-oci-interconnect/index.html#GUID-FBE38C70-A4CF-40C5-A37A-121241D21199

![](images/overview.png)

### Prerequisite 

1. update provider.tf with your Azure account details
2. Terraform Plan
3. Terraform Apply

Feel free to change CIDR if needed

### Known issue
output.tf works only all is provisioned. 
```sh
 1. mv output.tf.bak
 2. terraform apply
 3. you will see the details as follows:
 4. Copy service Key from the output and paste it when FastConnect is created in Oracle Cloud to complete interconnection between FastConnect and ExpressRT 
 ![](images/output.png)
```
