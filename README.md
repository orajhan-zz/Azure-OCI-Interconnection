# Azure Oracle Cloud nterconnection

Oracle has partnered with Microsoft to provide low latency, private connectivity between Oracle Cloud and Microsoft Azure. 
Please refer to https://docs.oracle.com/en/solutions/learn-azure-oci-interconnect/index.html#GUID-FBE38C70-A4CF-40C5-A37A-121241D21199

![](images/overview.png)

### Prerequisites in Azure

Your will need Virtual Network Gateway, ExpressRT, Network Security Group, Route table, etc in Azure end. 
Only thing you need is to change CIDR if needed

```sh
1. update provider.tf with your Azure account details
2. Terraform Plan
3. Terraform Apply
4. Log into VM in Azure
5. Conenct to Database or VM running in Oracle Cloud
```

### Known issue in Azure Terraform
output.tf works only all is provisioned. 
```sh
 1. complete the existing terraform scripts without changing any. Once it's done, please go to step #2.
 2. mv output.tf.bak
 3. terraform apply
 4. you will see the details as follows:
 5. Copy service Key from the output and paste it when FastConnect is created in Oracle Cloud to complete interconnection between FastConnect and ExpressRT

```
 ![](images/output.png)


### Expected cost in Azure for this demo
This Azure Terraform will not cost more than 2 dollars with ExpressRT and others unless you let it run for 24 hours or more.
There will be a test VM provision as B1ls that is the smallest shape at this moment.(USD 3.8 for a month, hence it will be less than 10 cents for this demo)
![](images/B1ls.png)
