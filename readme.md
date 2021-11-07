# GitHub Webhook Processor

## Summary and Scope

This is a simple demo application which shows how to react to the GitHub webhook events. For the simplicity I have kept the application as minimum as possible to demonstrate only the functionality. Please note, there are quite few areas should be improved before making this application as enterprise grade. Some of the improvements I can think of are:
 - <b>API Specification creation:</b> There is no API specification for now as my intention is to show the process rather than the documentation.
 - <b>Handling different events  using different endpoints:</b> In the current implemention a single endpoint going to handle all the webhooks configured at the Github org level. This could be become messy when many other types of events are enabled through the same webhook. In current application, I have only subscribed for the branch creation event, so it should be fine. I would suggest to create grantular webhook configuration at GitHub and create separate endpoint to handle them.
 - Property encryption: At present I am using the in built encryption of the Anypoiint platform to hide the secrets. In an enterprise grande application, I would expect to have encrypted property file with heavily guarded key.
 - Build and release automation: It can be done easily but does not provide value for the interview demo application.
 - The branch protection is static right now. It can be improved to target various branches with various degree of protection.


## User Guide

Here are the high level steps require to work on this demo E2E:
- Create an API which has an POST endpoint exposes over HTTPS (I am not sure GitHub even support HTTP but I will not suggest it). For this demo app, I have created following endpoint `https://github-webhook-processor-api-v1.uk-e1.cloudhub.io/api/github/webhook`.
- The API mist be reachable from anywhere in the internet. I have deployed the application in AWS and kept it exposes through the shared load balancer for anyone to call.
- For security, I have enabled `HmacSHA256` hex digest verification at the API level.
- Configure the Webhook at the [organisation level](https://docs.github.com/en/rest/reference/orgs#webhooks). I have enabled only 'Branch or tag creation' events for this demo application. This mean, the webhook API will receive event for any tag or branch creation for the organisation. I would like to protect the `main` branch, which is why the API is protecting it whenever a repository creating the main branch. This behaviour can be change to protect any other branch(s) with little change.
- Now test the API by creating a new public repo at the [Neo-Integrations org](https://github.com/organizations/Neo-Integrations/)
- At the end, you should see issue in the repo with a mention of the person who created the branch.

## Prerequisite

- Guthub account: This is needed to create an organisation and test the repo/branch creation action
- MuleSoft Anypoint Account: I am using MuleSoft to create the webhook processor API. You can create a trail account [here](https://anypoint.mulesoft.com/login/signup).
- Need some understanding of how MuleSoft works to build and deploy an API to CloudHub
