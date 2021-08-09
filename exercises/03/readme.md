# Exercise 03 - Installing & configuring the SAP Cloud Connector

The scenario upon which this Virtual Event is based includes access to an on-prem SAP system, for which the SAP Cloud Connector is required.

> The SAP system we'll be using is not actually on-prem, it's the [public SAP NetWeaver Gateway Demo system](https://blogs.sap.com/2017/06/16/netweaver-gateway-demo-es5-now-in-beta/), known by its System ID "ES5". But for the purposes of understanding and configuring the SAP Cloud Connector, we will treat it as if it is.

In this exercise you'll set up and configure SAP Cloud Connector, to provide the connection between an on-prem SAP system (ES5) and your subaccount on the SAP Cloud Platform, enabling services and apps running in that subaccount to access specific system endpoints in ES5.

The setup will be done in a container, to isolate SAP Cloud Connector and the software upon which it relies. This is a good approach not only for Virtual Event scenarios like this where attendees' machines are all different, but also for use within work environments. Docker is used as the container system.

> This exercise assumes you don't already have any processes listening for HTTP requests on port 8443 of your machine.

## Steps

After completing these steps you'll have an SAP Cloud Connector system running in a container on your machine and connected to your trial account. You'll also have resources in the ES5 system exposed and available through that system too.

### 1. Install an SAP Cloud Connector

Instructions for setting up an SAP Cloud Connector, along with the software upon which it relies, all in a Docker container, is explained in detail in the [nzamani/sap-cloud-connector-docker](https://github.com/nzamani/sap-cloud-connector-docker) repository on GitHub. This repository is accompanied by the blog post "[Installing SAP Cloud Connector into Docker and connecting it to SAP Cloud Platform](https://blogs.sap.com/2018/05/22/installing-sap-cloud-connector-into-docker-and-connecting-it-to-sap-cloud-platform/)" by [Nabi Zamani](https://people.sap.com/pars.man#overview).

> When following these instructions, [please be aware](https://github.com/nzamani/sap-cloud-connector-docker/blob/a1a673af37b4cc4412b11a6542fb5c9fd26760ad/Dockerfile#L31-L33) of how the mechanism works in relation to the End User License Agreement.

:point_right: Follow the [instructions](https://github.com/nzamani/sap-cloud-connector-docker#instructions) in this repository to set things up; at the end you should have a Docker container based SAP Cloud Connector up and running, and you should have successfully logged in (at https://localhost:8443) as user "Administrator".

Once you've done that, return here for the following steps in this README.


### 2. Perform initial setup of the SAP Cloud Connector

In this step you will use the administration interface to perform some initial setup of the SAP Cloud Connector; in particular, you'll connect it to the SAP Cloud Platform.

:point_right: Open your browser and go to the SAP Cloud Connector administration UI at [https://localhost:8443](https://localhost:8443). Remember that this is only possible because, with the `-p 8443:8443` parameter earlier, you specified that port 8443 in the container (which is where SAP Cloud Connector is *actually* running and listening) should be exposed to your machine, the container's host (where Docker is running), also on port 8443.

> Your browser will likely warn you that the site is insecure, because the certificate that the site presents (via HTTPS) has not been signed by any authority it recognizes. This is OK for what we want to achieve in this Virtual Event, and you should proceed through any warning. It's possible to fix this by installing a signed certificate into the SAP Cloud Connector, but this is beyond the scope of this exercise. Check the [Browsers](https://github.com/nzamani/sap-cloud-connector-docker#browsers) section of the other repository for information on how to proceed past the warnings.

:point_right: If you haven't done already, at the "Cloud Connector Login" page, log in with the default username and password "Administrator" and "manage" and then follow the prompts to change this password, selecting the "Save" icon on the right hand side to proceed (leave other options as they are).

Next, you're asked to specify an initial subaccount that you want the SAP Cloud Connector to connect to (you can connect it to multiple subaccounts but we will only specify this initial one in this exercise).

:point_right: Specify the appropriate details for your trial subaccount, as follows:

- "Region": select the entry that reflects the Cloud Foundry API endpoint URL that is related to the organization connected to your trial subaccount. In other words, you can search by entering `cf` in the selection search box to find and select the appropriate entry, such as "Europe (Frankfurt) - AWS", which corresponds to `cf.eu10.hana.ondemand.com`, or "US East (VA) - AWS", which corresponds to `cf.us10.hana.ondemand.com`

- "Subaccount": this should be the ID of your trial subaccount, from your "Trial Subaccount Home" page, as shown in this screenshot, where `b844...` is the ID (note there are other IDs relating to connected environments, but it's the subaccount ID that's needed):

  ![subaccount ID](subaccountid.png)


- "Display Name": specify anything you want here; we recommend you use the Subdomain name of the subaccount

- "Login E-Mail" and "Password": these credentials are the ones related to your trial account

- Leave other parameters as they are, and then complete the initial setup with the "Save" button on the right hand side

![subaccount details](subaccountdetails.png)

At this point, your SAP Cloud Connector, running in a container on your machine, is now up and running with a secure tunnel established to your subaccount on the SAP Cloud Platform. You should see a status page in the SAP Cloud Connector administration UI that looks something like this:

![connection status](connectionstatus.png)

### 5. Make the SAP backend system available

Now that the connection is established, you can define access to the on-prem backend SAP system that the SAP Cloud Connector will facilitate.

> Remember that (a) the secure tunnel is established *outbound* from the SAP Cloud Connector to the SAP Cloud Platform, not the other way round (i.e. connections cannot be initiated from outside your on-prem landscape) and (b) no on-prem system is accessible unless you specify that it is (an "allowlist" approach).

:point_right: Select the "Cloud To On-Premise" item in the navigation menu on the left hand side, and in the "Mapping Virtual To Internal System" section, create a new system mapping entry with the "+" icon. In the dialog that follows, you can specify the details of your backend SAP system, i.e. the ES5 system:

| Setting                | Value                   |
| -------------          | ----------------------- |
| Back-end Type          | ABAP System             |
| Protocol               | HTTPS                   |
| Internal Host          | sapes5.sapdevcenter.com |
| Internal Port          | 443                     |
| Virtual Host           | virtuales5              |
| Virtual Port           | 8000                    |
| Principal Type         | None                    |
| Host in Request Header | Use Virtual Host        |

The dialog summary should look something like this:

![system mapping summary](mappingsummary.png)

:point_right: Select the "Finish" button to create the system mapping.

:point_right: (Optional) To validate connection to your backend SAP system, select the "Check Availability" (calendar with magnifier) icon under "Actions" and make sure "Check Result" comes back "Reachable" as shown below:

![reachable validation](reachablevalidation.png)

### 6. Expose a set of resources in the backend system

While you've established a mapping of a virtual host (that is visible at the SAP Cloud Platform level) to an internal (on-prem) host, there are still no accessible resources available on that host. You must specify these explicitly, and you'll do that now in this step.

:point_right: In the new "Resources of virtuales5:8000" section that is now visible, add a new resource entry with the "+" icon, specifying the following values and finishing with the "Save" button:

| Setting                | Value                   |
| -------------          | ----------------------- |
| URL Path               | /sap/opu/odata          |
| Active                 | (checked)               |
| WebSocket Upgrade      | (leave unchecked)       |
| Access Policy          | Path and all sub-paths  |

This establishes access to OData services, specifically those at path `/sap/opu/odata`. Many standard OData services in an SAP system are available here, and the one we'll use later is too.

> For test purposes, you could also have specified simply `/` as the URL Path to make every HTTP-based resource in the ES5 system available.

This is the sort of thing that you should see when you've completed this step:

![access summary](accesssummary.png)

### 7. Check the connection at the SAP Cloud Platform end

> This option is currently - and temporarily - unavailable for new Feature Set B based accounts, but has been left in as a step in this exercise for Feature Set A based accounts, and also to show you what it would look like.

Now the connection is established, you can also check it in your SAP Cloud Platform trial subaccount.

:point_right: Back on your "Trial Subaccount Home" page in the SAP Cloud Platform Cockpit, select the "Connectivity" item in the navigation menu, and within that, choose the "Cloud Connectors" item. You should see your SAP Cloud Connector connection information, plus the "virtuales5" host you exposed. It should look something like this:

![connection established](connectionestablished.png)

## Summary

You've now got your own SAP Cloud Connector running, connected to your SAP Cloud Platform trial subaccount, and exposing OData services on a backend SAP system ready for consumption. Well done!

## Questions

1. How else could you check that the SAP Cloud Connector was up and running and listening on port 8443?

1. What other resource paths might you want to expose in a backend SAP system?

1. Do you know the origin of the "opu" part of the `/sap/opu/odata` URL path and what it represents?

1. Is the specification of "HTTPS" (as opposed to "HTTP") in the virtual-to-internal system mapping significant?
