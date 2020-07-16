# Virtual Event - SAP Cloud Platform Workflow

## Description

This repository contains the material for the virtual event on SAP Cloud Platform Workflow. It is based upon the original [CodeJam - SAP Cloud Platform Workflow](https://github.com/SAP-samples/cloud-workflow-codejam/) content.

Prerequisites and recommendations for this virtual event are documented in the [prerequisites](prerequisites.md) file.

### Virtual event overview

This SAP Cloud Platform Workflow virtual event brings together, over a series of ten exercises, a number of SAP Cloud Platform topics, centred around the SAP Cloud Platform Workflow service, but also covers setting up the SAP Cloud Connector to establish connectivity to an on-prem environment, using the SAP Cloud Platform Portal service to create an SAP Fiori launchpad site, exploring the SAP API Business Hub and using the Workflow API directly. From the Workflow service perspective you'll create, deploy and extend a workflow definition, interact with tasks in the standard My Inbox app and monitor & inspect workflow instances, initiating them from the monitor itself and from a 3rd party application.

### Material organization

The material consists of a series of exercises that are to be done in order (each one building on the previous one). Each exercise is contained in a directory, with a main 'readme' file containing the core exercise instructions, with optional supporting files, such as screenshots and sample files.

### Following the exercises

During the virtual event you will complete each exercise one at a time. At the end of each exercise there are questions; these are designed to help you think about the content just covered, and are to be discussed with the entire class, led by the instructors, when everyone has finished that exercise.

If you finish an exercise early, please resist the temptation to continue with the next one. Instead, explore what you've just done and see if you can find out more about the subject that was covered. That way we all stay on track together and can benefit from some reflection via the questions (and answers).

:point_right: Where there's an action for you to perform, it will be prefixed with this pointing symbol, to help you focus on where you are in each exercise.

> The management tools in SAP Cloud Platform have recently undergone renovation, and there is now the concept of tool "[feature sets](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/Cloud/en-US/caf4e4e23aef4666ad8f125af393dfb2.html)". Throughout this virtual event, the descriptions and screenshots will be from a "Feature Set B" environment.

### The exercises

Here's an overview of the exercises.

- [Exercise 01 - Setting up for Workflow on Cloud Platform](exercises/01/)
- [Exercise 02 - Deploying the Workflow tools](exercises/02/)
- [Exercise 03 - Installing & configuring the SAP Cloud Connector](exercises/03)
- [Exercise 04 - Establishing a destination in SAP Cloud Platform](exercises/04)
- [Exercise 05 - Creating, deploying & instantiating a simple workflow](exercises/05)
- [Exercise 06 - Exploring the API Hub and the Workflow API](exercises/06)
- [Exercise 07 - Calling the Workflow API from Postman](exercises/07)
- [Exercise 08 - Adding a Service Task to the workflow definition](exercises/08)
- [Exercise 09 - Adding a User Task to the workflow definition](exercises/09)
- [Exercise 10 - Accessing contextual information in a Script Task](exercises/10)

### Further experimentation

If you want to further your learning based on what you've built in these exercises, we suggest you extend the workflow definition you've created to add more features. For example, you could set up a Mail Task with appropriate configuration to send a message.

You could also look at branching in the flow, based on decisions, using the Exclusive or Parallel Gateways.

Events are also powerful features that you could investigate. For example, try controlling the flow of your workflow instances via remote API calls by making use of Intermediate Messages, that pause execution until an incoming message is received (via an API call).

For more in-depth coverage of some of the topics in this virtual event, you may find the blog post series [Discovering SCP Workflow](https://qmacro.org/2018/01/16/discovering-scp-workflow/) worth a look.


## Requirements

The requirements to follow the exercises in this repository, including hardware and software, are detailed in the [prerequisites](prerequisites.md) file.


## Download and installation

You do not need to download this repository nor install anything from it. You can just follow the exercises by visiting each of them as listed in the [exercises](#the-exercises) section.


## How to obtain support

Support for the content in this repository is available during virtual events, for which this content has been designed. Otherwise, this content is provided "as-is" with no other support.


## License

Copyright (c) 2020 SAP SE or an SAP affiliate company. All rights reserved.
This project is licensed under the Apache Software License, v. 2 except as noted otherwise in the [LICENSE](LICENSE) file.


