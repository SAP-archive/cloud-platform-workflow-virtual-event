# Exercise 06 - Exploring the API Hub and the Workflow API

In this exercise you'll take a look at the details of the Workflow service API in the SAP API Business Hub, and use the API to create an instance of your `orderprocess` definition, instead of doing it via the "Monitor Workflows" app.

## Steps

After completing these steps you'll have set up an environment in the SAP API Business Hub that reflects the details of your trial account, and tried out a couple of API calls to start off a workflow via the API.

### 1. Log on to SAP API Business Hub

:point_right: Go to the [SAP API Business Hub](https://api.sap.com/) and log on.

This is the central place for discovery and consumption of APIs - see it as your "one stop shop" to learn about and try out APIs in the SAP universe. Take a few moments to look around and familiarize yourself with the site.

### 2. Find the Workflow API

The Workflow API is of course documented and available for exploration here in the API Hub.

:point_right: [Search for](https://api.sap.com/search?searchterm=workflow+API&tab=all) the Workflow API - you should find a number of results. The one we're interested in here is the [Workflow API for Cloud Foundry](https://api.sap.com/api/SAP_CP_Workflow_CF/resource). You should see something like this:

![Workflow API summary](workflowapisummary.png)

It describes the different aspects that the API covers, such as:

- User Task Instances
- Workflow Definitions
- Workflow Instances
- Forms

and so on.

For each aspect there are a number of verb/noun combinations, in the form of HTTP methods (representing the verbs) and URL paths (representing the nouns). This verb/noun approach suggests that the Workflow API exhibits some qualities of the Representational State Transfer (REST) architectural style.

:point_right: Explore each of the aspects, in particular "Workflow Instances". Try to identify which verb/noun combination in the "Workflow Instances" aspect would be appropriate to create a new instance of a workflow definition.


### 3. Configure an API Environment

In the API Hub you can not only explore but also try out APIs. For this, there's a generic sandbox environment provided, but it's better and more convenient to set up an API environment that reflects your Cloud Foundry (CF) trial account setup. In this step you'll do just that, defining an API environment using credentials relating to the workflow service instance you've set up there.

When you configure an environment, you need to supply endpoint and credential information, so the API Hub can facilitate making API calls for you. This information is available in the details of your workflow service instance, so you'll go there first to get that information, then return to the API Hub to specify it during the configuration.

:point_right: Open up a new browser tab and go to your "Dev Space Home". Find the workflow service instance (use the "Service Instances" within "Services" in the left hand navigation) and select it, remembering that its name is `default_workflow`.

:point_right: Now select the "Service Keys" navigation item which will reveal that there's a service key "OrderProcess-workflow_mta-credentials" that's been created for you. It should look something like this:

![service key details](servicekey.png)

:point_right: Make a note of the following properties, the names of which reflect their "full paths" within the JSON structure:

- `endpoints.workflow_rest_url`
- `uaa.clientid`
- `uaa.clientsecret`
- `uaa.url`

:point_right: Now switch back to the API Hub tab and select the "Configure Environments" link to get to a dialog where you can create a new environment. You should see something like this:

![environment configuration](environmentconfiguration.png)

You should be defaulted to the "Create New Environment" mode.

:point_right: Specify the following values, noting that the Starting URL selection should reflect the value of the `endpoints.workflow_rest_url` property, including the particular region:

| Property       | Value                   |
| -------------- | ----------------------- |
| Starting URL   | the value of `endpoints.workflow_rest_url` |
| Display Name for Environments | MyEnv |
| OAuth 2.0 Client Id | the value of `uaa.clientid` |
| OAuth 2.0 Secret    | the value of `uaa.clientsecret` |
| consumersubdomain   | the most significant hostname part of the fully qualified domain name value of `uaa.url` |
| landscapehost    | the rest of the fully qualified domain name value of `uaa.url`, excluding the 'authentication' part |
| Apply this environment to all APIs in this package that are not yet configured | _checked_ |
| Save this environment for future sessions | _selected_ |

Regarding the values for the properties "consumersubdomain" and "landscapehost", these are parts that contribute towards the generated value for "Token URL". Here's an example:

- the value of `uaa.url` is `https://898789e9.authentication.eu10.hana.ondemand.com`
- the value of "consumersubdomain" should be `898789e9trial`
- the value of "landscapehost" should be `eu10.hana.ondemand.com`
- the resulting "Token URL" should be `https://898789e9trial.authentication.eu10.hana.ondemand.com/oauth/token`

Don't forget to save the settings when you're done.

### 4. Request workflow definition information via the API

Now you can try out your new API environment by requesting information on the workflow definitions that you've already deployed to the Workflow service. If this is your first experience with the Workflow service, you should just see the single `orderprocess` definition in the results.

:point_right: Select the "Workflow Definitions" aspect, and identify the verb/noun combination:

```
GET /v1/workflow-definitions
```

:point_right: Select your new API environment in the dropdown selection at the top of the verb/noun list, so that the "MyEnv" environment is shown as selected.

![MyEnv selected](envselected.png)

:point_right: Use the "Try out" link to expand and explore the API call. You can leave all the parameters as they are, and use the "Execute" button to make the API call.

An API call is made for you, with your credentials, in the context of the environment that you defined. The results are shown, including the HTTP status code (200), the body of the response, and the response headers. They should look something like this:

**Response body**

```json
[
  {
    "id": "orderprocess",
    "version": "1",
    "name": "orderprocess",
    "createdBy": "sb-clone-9a1a2e0e-d3f0-4bc6-92dd-cf1cda8495ba!b44074|workflow!b10150",
    "createdAt": "2020-07-21T06:53:42.998Z",
    "jobs": []
  }
]
```

You've just made your first API call - nice work!


### 5. Create a new workflow instance via the API

Now that you've tried out a simple API call, it's time to use the API to create a new instance of your `orderprocess` workflow definition.

:point_right: Select the "Workflow Instances" aspect and thence the `POST /v1/workflow-instances` verb/noun combination. Select the "Try out" link to be able to set up and execute the call.

A payload is sent with this call, and you specify it in the "body" parameter here.

:point_right: Specify the following for the value of the "body" parameter, being careful to get it exactly right, as it's JSON -- and quotes, colons and curly braces matter:

```json
{
  "definitionId": "orderprocess",
  "context": {
    "request": {
      "Id": "HT-1002",
      "Quantity": 42
    }
  }
}
```

_Note: It should be fairly evident what this is - it's the payload that is to be supplied to the workflow instance (very much like what we specified in the previous exercise), along with the workflow definition identifier._

:point_right: Use the "Execute" button to send the request.

You should see a response with an HTTP status code of 201, and a response body & response headers that look like this:

**Response body**

```json
{
  "id": "b2b8f958-cbfe-11ea-a160-eeee0a8df42a",
  "definitionId": "orderprocess",
  "definitionVersion": "1",
  "subject": "orderprocess",
  "status": "RUNNING",
  "businessKey": "",
  "startedAt": "2020-07-22T09:35:36.882Z",
  "startedBy": "sb-clone-9a1a2e0e-d3f0-4bc6-92dd-cf1cda8495ba!b44074|workflow!b10150",
  "completedAt": null
}
```

Great!


### 6. Check the newly created instance in the Fiori launchpad

It is of course possible to use the "Workflow Monitor - Workflow Instances" to view this newly created instance. You can do that in this step.

:point_right: Open up the "Workflow Monitor - Workflow Instances" app in your Fiori launchpad site. Don't forget to ensure that the filter is still allowing the display of instances in the "Completed" state.

_Note: By the time you open the app, the instance will have completed, but it's nice to see the status immediately after creation, which was shown in the response body to the `POST /v1/workflow-instances` request. This status, as you can see above, was "RUNNING"._

:point_right: Examine the details for the instance, and try to match values up with what you saw from the results of the API call. You should be able to see that the values for the "Instance ID" and "Started At" properties, for example, are the same.

_Note: Timezones play a part in dates and times, so the hour values may be offset - the time given in the API output is in UTC._

Here's an example of what you might see:

![instance details](instancedetails.png)


## Summary

You've explored the Workflow API in the API Hub and successfully started a workflow instance via that API, supplying data that finds its way into the context of that instance. You've also managed to find evidence of that instance in the administration UI. Nice work!

## Questions

1. Why are there square brackets surrounding the response to the `GET /v1/workflow-definitions` API call?

1. In the payload of the `POST` call to `/v1/workflow-instances`, can you explain all aspects of the data contained therein?

1. What does HTTP response code 201 signify and how does it differ from 200?

1. Did you notice anything interesting about the instance created via the API, when compared to the ones you created via the Fiori monitor app?
