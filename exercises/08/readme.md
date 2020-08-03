# Exercise 08 - Adding a Service Task to the workflow definition

In this exercise you'll go back to the workflow definition you created in a previous exercise and add a Service Task to it to retrieve product information for the product ID specified when workflow instances are created.

## Steps

After completing these steps you'll have a workflow definition with a service task configured, and have deployed and tested it.

### 1. Open up the workflow definition in the IDE

:point_right: Open up your App Studio Workflow Dev Space via the bookmark you saved in a previous exercise.

> If you get an empty page, it's because the Dev Space is in a "STOPPED" state; remove the hashpath from the end of the URL to get back to the Dev Space overview so you can restart the Dev Space and jump back in.

:point_right: Once you're in, open the `orderprocess.workflow` workflow definition that should currently sport only a start event and an end event.

### 2. Add a Service Task

:point_right: Use the Tasks menu in the graphical workflow editor to add a Service Task, and place it between the start event and the end event.

![Service Task selection](servicetaskselection.png)

It should look like this once you've added it:

![Service Task added](servicetaskadded.png)

You may notice a warning triangle decorating the Service Task in your workflow - this signifies that there is some configuration still needed.

:point_right: While the Service Task is selected, go to the "Details" tab of the "Service Task Properties" on the right hand side, and specify the following values:

| Property              | Value              |
| --------------        | ------------------ |
| Destination           | `shopinfo`         |
| Choose a Service from | (leave as "Others") |
| Path                  | `Products('${context.request.Id}')?sap-client=002` |
| HTTP Method           | GET                |
| Response Variable     | `${context.productInfo}` |
| Principal Propagation | (leave unchecked)  |

> The "shopinfo" value is the name of the destination you created in [Exercise 04](../04).

> The "sap-client=002" query parameter is needed here in the "Path" despite the additional property setting in the destination definition as currently the Workflow service does not support that property.

:point_right: Ensure your changes are saved.


### 3. Deploy the workflow definition

Now it's time to redeploy the definition to the Workflow service, so that this addition of a Service Task is live. This is done following a similar build-deploy procedure to what you've used already, in [Exercise 05](../05). But instead of using the context menu and selecting the tasks from a menu, this time you're going to do it in the terminal.

:point_right: First, make sure you've got a terminal ready and available within your App Studio Workflow Dev Space (if you haven't, open one with the menu path "Terminal -> New Terminal") and that you're in the `OrderFlow/` project directory (if you're in the parent `projects/` directory, use `cd OrderFlow/`).

First, the deployable archive must be built. In the terminal, this is done by invoking the Cloud MTA Build Tool (MBT) from the command line, like this:

```
mbt build
```

Like before, the process should complete fairly quickly, and you'll see output that looks similar to the output you got when you invoked the build step via the context menu. This is because it is - the same tool (MBT) is used in both cases.

The output should look something like this:

```
[2020-07-22 10:30:28]  INFO Cloud MTA Build Tool version 1.0.15
[2020-07-22 10:30:28]  INFO generating the "Makefile_20200722103028.mta" file...
[2020-07-22 10:30:28]  INFO done
[2020-07-22 10:30:28]  INFO executing the "make -f Makefile_20200722103028.mta p=cf mtar= strict=true mode=" command...
[2020-07-22 10:30:28]  INFO validating the MTA project
[2020-07-22 10:30:28]  INFO validating the MTA project
[2020-07-22 10:30:28]  INFO building the "OrderProcess" module...
[2020-07-22 10:30:28]  INFO the build results of the "OrderProcess" module will be packaged and saved in the "/home/user/projects/OrderFlow/.OrderFlow_mta_build_tmp/OrderProcess" folder
[2020-07-22 10:30:28]  INFO finished building the "OrderProcess" module
[2020-07-22 10:30:28]  INFO generating the metadata...
[2020-07-22 10:30:28]  INFO generating the "/home/user/projects/OrderFlow/.OrderFlow_mta_build_tmp/META-INF/mtad.yaml" file...
[2020-07-22 10:30:28]  INFO generating the MTA archive...
[2020-07-22 10:30:28]  INFO the MTA archive generated at: /home/user/projects/OrderFlow/mta_archives/OrderFlow_0.0.1.mtar
[2020-07-22 10:30:28]  INFO cleaning temporary files...
```

As indicated in the output, there's a freshly generated `OrderFlow_0.0.1.mtar` file in the `mta_archives/` directory. So now it's time to deploy it. Again, from within the terminal.

:point_right: In the terminal, deploy the archive like this:

```
cf deploy mta_archives/OrderFlow_0.0.1.mtar
```

> You may have to re-authenticate with the CF endpoint, using `cf login`.

Again, the output is given to you directly in the terminal, and will look something like this:

```
Deploying multi-target app archive mta_archives/OrderFlow_0.0.1.mtar in org 898789e9trial / space dev as dj.adams@sap.com...

Uploading 1 files...
  /home/user/projects/OrderFlow/mta_archives/OrderFlow_0.0.1.mtar
OK
Operation ID: f9c57a48-cc06-11ea-a023-eeee0a846b5b
Deploying in org "898789e9trial" and space "dev"
Detected MTA schema version: "3"
No deployed MTA detected - this is initial deployment
Detected new MTA version: "0.0.1"
Service key "OrderProcess-workflow_mta-credentials" for service "default_workflow" already exists
Uploading content module "OrderProcess" in target service "workflow_mta"...
Deploying content module "OrderProcess" in target service "workflow_mta"...
Skipping deletion of services, because the command line option "--delete-services" is not specified.
Process finished.
Use "cf dmol -i f9c57a48-cc06-11ea-a023-eeee0a846b5b" to download the logs of the process.
```

> If you're curious to see some sort of acknowledgement that something has been updated, you can switch to the "Monitor Workflow - Workflow Definitions" Fiori app on your Fiori launchpad, and check that the version number for your "orderprocess" workflow definition has been incremented.


### 4. Create a new instance of the workflow definition

Now we have the Service Task in the workflow definition, let's try it out.

:point_right: Switch back over to Postman and send another "Creat new workflow instance" request (with the blue "Send" button). This should result in another successful 201 status code, showing the details of the freshly minted workflow instance.

:point_right: Now start the "Monitor Workflows - Workflow Instances" app in your Fiori launchpad site, ensuring that the filter is set to show instances in "Completed" status. Find the instance that's just been created, and examine the Workflow Context, which should look something like this:

```json
{
    "request": {
        "Id": "HT-1003",
        "Quantity": 25
    },
    "productInfo": {
        "d": {
            "__metadata": {
                "id": "https://virtuales5:8000/sap/opu/odata/sap/EPM_REF_APPS_SHOP_SRV/Products('HT-1003')",
                "uri": "https://virtuales5:8000/sap/opu/odata/sap/EPM_REF_APPS_SHOP_SRV/Products('HT-1003')",
                "type": "EPM_REF_APPS_SHOP.Product"
            },
            "AverageRating": "3.11",
            "Name": "Notebook Basic 19",
            "Description": "Notebook Basic 19 with 2,80 GHz quad core, 19\" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro",
            "StockQuantity": 150,
            "CurrencyCode": "USD",
            "DimensionDepth": "21",
            "DimensionHeight": "4",
            "DimensionUnit": "cm",
            "DimensionWidth": "32",
            "HasReviewOfCurrentUser": false,
            "Id": "HT-1003",
            "ImageUrl": "/sap/public/bc/NWDEMO_MODEL/IMAGES/HT-1003.jpg",
            "IsFavoriteOfCurrentUser": false,
            "LastModified": "/Date(1595383327000)/",
            "MainCategoryId": "Computer Systems",
            "MainCategoryName": "Computer Systems",
            "MeasureUnit": "each",
            "Price": "1650.00",
            "QuantityUnit": "EA",
            "RatingCount": 9,
            "SubCategoryId": "Notebooks",
            "SubCategoryName": "Notebooks",
            "SupplierId": "100000003",
            "SupplierName": "Talpa",
            "WeightMeasure": "4.2"
        }
    }
}
```

> Some of the properties have been omitted to keep the display concise.

Notice that the context now contains extra data, in the `productInfo` property. This is what was retrieved in the Service Task.

## Summary

You now have a workflow definition that includes a task that fetches data from a remote service, in particular, the service available in the on-prem ABAP stack SAP system that you made available via the SAP Cloud Connector.

## Questions

1. When you switched from HTTP Method POST to GET when setting the Service Task properties, the "Path to XSRF Token" property disappeared. Why was that?

1. How does the product data from the OData service end up where it does in the workflow instance context?

1. When we request an entity from an OData service in the browser, such as the [Chai product from the Northwind dataset](https://services.odata.org/V3/Northwind/Northwind.svc/Products(1)), we usually see it in an XML representation, and have to add a query parameter `$format=json` to the URL, like this: [https://services.odata.org/V3/Northwind/Northwind.svc/Products(1)?$format=json](https://services.odata.org/V3/Northwind/Northwind.svc/Products(1)?$format=json). Why do you think we received a JSON representation even when we didn't use this query parameter in the Service Task settings?
