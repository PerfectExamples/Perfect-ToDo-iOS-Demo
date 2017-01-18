# Multiple Server Instances Demo

<p align="center">
<a href="http://perfect.org/get-involved.html" target="_blank">
<img src="http://perfect.org/assets/github/perfect_github_2_0_0.jpg" alt="Get Involved with Perfect!" width="854" />
</a>
</p>

<p align="center">
<a href="https://github.com/PerfectlySoft/Perfect" target="_blank">
<img src="http://www.perfect.org/github/Perfect_GH_button_1_Star.jpg" alt="Star Perfect On Github" />
</a>  
<a href="http://stackoverflow.com/questions/tagged/perfect" target="_blank">
<img src="http://www.perfect.org/github/perfect_gh_button_2_SO.jpg" alt="Stack Overflow" />
</a>  
<a href="https://twitter.com/perfectlysoft" target="_blank">
<img src="http://www.perfect.org/github/Perfect_GH_button_3_twit.jpg" alt="Follow Perfect on Twitter" />
</a>  
<a href="http://perfect.ly" target="_blank">
<img src="http://www.perfect.org/github/Perfect_GH_button_4_slack.jpg" alt="Join the Perfect Slack" />
</a>
</p>

<p align="center">
<a href="https://developer.apple.com/swift/" target="_blank">
<img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift 3.0">
</a>
<a href="https://developer.apple.com/swift/" target="_blank">
<img src="https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat" alt="Platforms OS X | Linux">
</a>
<a href="http://perfect.org/licensing.html" target="_blank">
<img src="https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat" alt="License Apache">
</a>
<a href="http://twitter.com/PerfectlySoft" target="_blank">
<img src="https://img.shields.io/badge/Twitter-@PerfectlySoft-blue.svg?style=flat" alt="PerfectlySoft Twitter">
</a>
<a href="http://perfect.ly" target="_blank">
<img src="http://perfect.ly/badge.svg" alt="Slack Status">
</a>
</p>

This repository holds a project designed to show you how to setup and use multiple server instances. 

In this example, you are designing an API for a shipping company, when you realize that you need both a private and public API. One for your staff to use to add and modify shipments, and one for customers or third party software to use to track it. 

The objects are separated by function:

- Shipment is the model
- ShipmentManager interacts with the database through SQLiteStORM
- Shipments uses ShipmentManager to produce JSON for the handlers
- Handers contains the functions that the server uses to respond to requests
- Database & PrivateAuth are helpers for setup and demo

## Compatibility with Swift

The master branch of this project currently compiles with **Xcode 8.2** or the **Swift 3.0.2** toolchain on Ubuntu.

## Building & Running

The following will clone and build an empty starter project and launch the server on port 8080 and 8181.

```
git clone [Repo Address Here]
cd MultipleServerInstances
swift build
.build/debug/MultipleServerInstances
```

You should see the following output:

```
[INFO] Starting HTTP server Public API on 0.0.0.0:8080
[INFO] Starting HTTP server Private API on 0.0.0.0:8181
```

This means the servers are running and waiting for connections. Access the public API routes at [http://localhost:8080/](http://127.0.0.1:8080/) and the private API routes at [http://localhost:8181/](http://127.0.0.1:8181/). Hit control-c to terminate the server.

### IMPORTANT NOTE ABOUT XCODE

If you choose to generate an Xcode Project, you **MUST** change to the executable target **AND** setup a custom working directory for its scheme in order for the database to create and work properly. 

![Proper Xcode Setup](https://github.com/rymcol/MultipleServerInstances/raw/master/Supporting/xcode.png)

## Testing

The public API routes at [http://localhost:8080/](http://127.0.0.1:8080/) are:

- / (This only returns a welcome message)
- /track

### /track

To use track, use your favorite http client to make a post request to /track with a JSON body including the key `trackingNumber` and the value of the tracking number you would like to track (assuming one has been created). Example:

```
{"trackingNumber":"13100E4F-6878-4E80-B93A-22B84AD0A11E"}
```

The private API routes at [http://localhost:8181/](http://127.0.0.1:8181/) are:

- / (This only returns a welcome message)
- /track (works the same as above)
- /count
- /create
- /update
- /set/delivered
- /delete

### IMPORTANT NOTE ABOUT THE PRIVATE API

There is a filter on the private API that will return an unauthorized error if you do not add a header value to your request of key `token` and value `13100E4F22B84AD0A11E`

This is to simulate an API key for private requests, showing that it's easy to make a public/private API pair using multiple server instances on groups of the same routes. 

### /count

To use /count, you make a get request. It will return JSON containing a count of the number of shipments in the database. 

### /create

To use /create, make a post request with the following keys and whatever values you would like:

```
{
"destination":"1234 Test Ln",
"hub":"Tampa, FL"
}
```

Where `destination` is the address the shipment is going to, and `hub` is the identifier for the shipping hub/terminal/office (where it's originating from, and what will become the last known location). 

The API will return JSON with information about the shipment, including the new tracking number it generated. It should look like this:

```
{"LastLocation":"Tampa, FL","Destination":"1234 Test Ln","Tracking Number":"895AFBF2-265D-4F56-81E1-E7336EAEEF10"}
```

### /update

To use /update, make a post request with the following keys and whatever values you would like (or you can include only one, such as only updating the current hub for tracking):

```
{
"trackingNumber":"895AFBF2-265D-4F56-81E1-E7336EAEEF10",
"destination":"1235 Test Ln, Tampa, FL 34200",
"hub":"Houston, TX"
}
```

The API will respond with {"success": true} (or false if it encountered any errors)

### /set/delivered

To mark a shipment delivered, make a post request with the tracking number to /set/delivered, i.e.:

```
{
"trackingNumber":"895AFBF2-265D-4F56-81E1-E7336EAEEF10"
}
```

The API will respond with {"success": true} (or false if it encountered any errors)

### /delete

To delete a shipment from the database, make a post request with the tracking number to /set/delivered, i.e.:

```
{
"trackingNumber":"895AFBF2-265D-4F56-81E1-E7336EAEEF10"
}
```

The API will respond with {"success": true} (or false if it encountered any errors)

## Issues

We are transitioning to using JIRA for all bugs and support related issues, therefore the GitHub issues has been disabled.

If you find a mistake, bug, or any other helpful suggestion you'd like to make on the docs please head over to [http://jira.perfect.org:8080/servicedesk/customer/portal/1](http://jira.perfect.org:8080/servicedesk/customer/portal/1) and raise it.

A comprehensive list of open issues can be found at [http://jira.perfect.org:8080/projects/ISS/issues](http://jira.perfect.org:8080/projects/ISS/issues)



## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
