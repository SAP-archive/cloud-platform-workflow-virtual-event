# Exercise 02 - Deploying the Workflow tools

In this exercise, you'll import a complete project into your IDE, build it, and deploy it to your Cloud Foundry (CF) "dev" space in the organization associated with your SAP Cloud Platform subaccount. This project contains everything you need to set up a Fiori launchpad site using the Portal service, and inject into it tiles appropriate for accessing the Workflow related tools which you'll be using throughout the rest of this Virtual Event.


## Steps

After completing these steps you'll have a Fiori launchpad with an app for viewing and processing Workflow items ("My Inbox") and a "Workflow Monitor" app for monitoring, starting and interacting with workflow definitions and instances.


### 1. Download the project ZIP file

The GitHub project [SAP-samples/cloud-process-visibility](https://github.com/SAP-samples/cloud-process-visibility) contains a number of release artifacts. It's from here that you can download the project which contains all you need.

:point_right: Jump directly to the [1.0.0 Release](https://github.com/SAP-samples/cloud-process-visibility/releases/tag/1.0.0) page and download the [BPMServicesFLP.zip](https://github.com/SAP-samples/cloud-process-visibility/releases/download/1.0.0/BPMServicesFLP.zip) file.

![BPMServicesFLP.zip file](bpmservicesflpzip.png)

Once you have the ZIP file downloaded, unpack it into its own "BPMServicesFLP" directory. Here's what that looks like on my computer:

```
i347491@C02CH7L4MD6T [~/Downloads]
▶ tree
.
├── BPMServicesFLP
│   ├── BPMFLP
│   │   ├── README.md
│   │   ├── package.json
│   │   ├── portal-site
│   │   │   ├── CommonDataModel.json
│   │   │   ├── business-apps
│   │   │   │   └── business-rules.json
│   │   │   └── i18n
│   │   │       ├── defaultCatalogId.properties
│   │   │       ├── defaultGroupId.properties
│   │   │       └── workflow.properties
│   │   └── xs-app.json
│   ├── BPMServicesFLP_appRouter
│   │   ├── package.json
│   │   └── xs-app.json
│   ├── mta.yaml
│   └── xs-security.json
└── BPMServicesFLP.zip

6 directories, 13 files
```

### 2. Bring the project into App Studio

It's easy to bring such a project into your App Studio Dev Space. First, you need to make sure that you have a workspace opened in the Explorer. Then, you just need to drag the project folder into there.

:point_right: Switch to the Explorer perspective in App Studio using the folders icon in the far left hand side, and use the Open Workspace button to select and open the "projects" directory.

![Open Workspace button](openworkspace.png)

> The App Studio gives you a local filesystem to work within; it even has a Terminal that you can start up, to navigate that filesystem and run commands.

:point_right: Using your local computer's file system tools, find and drag the "BPMServicesFLP" directory into the Explorer space in the App Studio, and expand it. You should end up with something that looks like this:

![BPMServiceFLP project](bpmserviceflpproject.png)










## Summary

Not only do you have an instance of the main workflow service now, but also access to your own FLP site with the "My Inbox" app for managing workflow related task items, and a pair of apps for managing workflow definitions and instances. But you also have some insight into how MTAs work and what the relationship is between modules and resources defined in MTA descriptor files.

Good work!


## Questions

1. Why is the `workflowtilesFLP` app not listed in the "Referencing Applications" column for the instance of the `html5-apps-repo` service?

1. What do you think the difference between a "workflow instance" and a "workflow definition" is?

1. Can you find out what the ID of the "Monitor Workflow" app is, that is accessed through the two "Monitor Workflow" tiles?

1. Were you able to follow the deployment process in detail? How else might you do that?
<!-- See https://blogs.sap.com/2020/05/01/terminal-tip-a-cf-remote-monitor-script/ -->
