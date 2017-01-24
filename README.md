# ToDo API & iOS App Integration Demo

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

## Before Building the API

Before building the API, you must setup a MySQL Database and provide connection information for it in Perfect-ToDo-iOS-Demo/Perfect-ToDo-API/Sources/main.swift

To make life easy, the default MySQL connection information is:

```
MySQLConnector.host		= "127.0.0.1"
MySQLConnector.username	= "perfect"
MySQLConnector.password	= "perfect"
MySQLConnector.database	= "perfect_testing"
MySQLConnector.port		= 3306
```

However, this can be tailored to your environment, needs, or even a remote host. You do not need to make any tables, as these will be generated automatically the first time you run the API executable. 

## Building & Running the API

The following will clone and build the backend API and launch the server on host 0.0.0.0 and port 8181. The iOS App is configured by default to connect to this host on this port locally. If you change it here, you must also change it in the iOS Project's Config.swift file. 

```
git clone [Repo Address Here]
cd Perfect-ToDo-iOS-Demo/Perfect-ToDo-API
swift build
.build/debug/ToDo-API
```

You should see the following output:

```
[INFO] Running setup: todo_items
[INFO] Running setup: users
[INFO] Running setup: tokens
[INFO] Starting HTTP server  on 0.0.0.0:8181
```

This means the servers are running and waiting for connections. Access the public API routes at [http://localhost:8080/](http://127.0.0.1:8080/) and the private API routes at [http://localhost:8181/](http://127.0.0.1:8181/). Hit control-c to terminate the server.

### IMPORTANT NOTE ABOUT USING XCODE WITH THE API

If you choose to generate an Xcode Project, you **MUST** change to the executable target **AND** setup a custom working directory for its scheme in order for the database to create and work properly. 

![Proper Xcode Setup](https://github.com/rymcol/Perfect-ToDo-iOS-Demo/raw/master/Perfect-ToDo-API/Supporting/xcode.png)

## Before Building the iOS App

Make sure that you open the Xcode project, and make sure that in Config.swift the `apiEndpoint` is set to the proper host and port, as noted above. 

## Building & Running the iOS App

Open the project, change the signing identity in the project settings to your own, then just build. Make sure you are running the API before testing the app. The app will show a `"Service Unreachable"` Error when it cannot connect to the API. 

## Testing

The public API routes are located at [http://localhost:8181/api/v1](http://127.0.0.1:8181/api/v1) and are:

#### Public

- [POST] /register
- [POST] /login

#### Secured

- [GET] /count
- [GET] /get/all
- [POST] /create
- [POST] /update
- [POST] /delete

### IMPORTANT NOTE ABOUT ACCESSING THE API

The API is secured using Turnstile, which means that upon a post request to /login, you're given a token. When accessing secured endpoints, you must provide the header with a key of `authorization` and a value of `Bearer (token)` where (token) is the value of the login token, otherwise you will be denied access. This is handled in the iOS App by the `RemoteUser` class .

### /register

To use the user registration endpoint, use your favorite http client to make a post request to /register with URL parameters of `username` and `password`  including the values of the username & password you would like to create. If the user registration is successful, you will receive a JSON response of:

```
{"login":"ok","error":"none"}
```

If the username is already taken, or an error occurs, you will receive an error message and description similar to:

```
{"error":"The account is already registered."}
```

### /login

To use the login system, use your favorite http client to make a post request to /login with URL parameters of `username` and `password`  including the values of the username & password you would like to use to login. If the user login is successful, you will receive a JSON response of:

```
{"login":"ok","token":"7cf_VfgMUQmkTtWqdc_5AA","error":"none"}
```

It is important to note and save the token at the time of login, as it will only be available at that time. If you lose or forget it, you will have to login again. Tokens that have not been logged into in more than 24 hours are considered invalid, and you will have to perform a new login at that time. 

If the login is not successful, or an error occurs, you will receive an error message and description similar to:

```
{"error":"Invalid username or password"}
```

### /count

To use count, use your favorite http client to make a get request to /count with the appropriate authorization header including the token as described above. If the token is valid and has a corresponding user, you will receive a JSON response similar to:

```
{"count":10}
```

It is not necessary to provide the username and password URL parameters, the authorization header token is sufficient. 

If anything is unauthorized, the API will produce a 401 Unauthorized error. In the unlikely event there is a valid token, but there is no user or some other kind of error, the API will produce an error and corresponding message similar to:

```
{"error":"An unknown error occurred"}
```

### /get/all

To use the get todo's endpoint, use your favorite http client to make a get request to /get/all with the appropriate authorization header including the token as described above. If the token is valid and has a corresponding user, you will receive a JSON response similar to:

```
{"todos":[]}
```
Or assuming you actually have items:
```
{"todos":[{"id":1,"item":"testB","dueDate":"2017-12-09 12:00:00","completed":false},{"id":2,"item":"testC","dueDate":"NULL","completed":false}]}
```

It is not necessary to provide the username and password URL parameters, the authorization header token is sufficient. 

If anything is unauthorized, the API will produce a 401 Unauthorized error. In the unlikely event there is a valid token, but there is no user or some other kind of error, the API will produce an error and corresponding message similar to:

```
{"error":"An unknown error occurred"}
```

### /create

To create ToDo items, use your favorite http client to make a post request to /create with the appropriate authorization header including the token as described above, as well as JSON body containing at lest the key "item" with a title for the ToDo item. You may also choose to provide a dueDate in the SQL `DateTime` format, but this is entirely optional and not required for item creation. 

```
{
	"item": "item title/name goes here"
	"dueDate": "2017-12-31 12:00:00"
}
```

It is not necessary to provide the username and password URL parameters, the authorization header token is sufficient. 

If you've successfully created an item, you will receive a message with the ToDo item's details, including the all important id, which is generated during the creation process: 

```
{"id":3,"item":"test thing","dueDate":"NULL"}
```

If anything is unauthorized, the API will produce a 401 Unauthorized error. In the unlikely event there is a valid token, but there is no user or some other kind of error, the API will produce an error and corresponding message similar to:

```
{"error":"An unknown error occurred"}
```

### /update

To update ToDo items, use your favorite http client to make a post request to /update with the appropriate authorization header including the token as described above, as well as JSON body containing at lest the key "id" containing the id number for the ToDo item. You may also choose to provide a new item name, dueDate in the SQL `DateTime` format, or completion. All parameters outside id are optional, but you should provide at least one, otherwise it will not be a very fun API endpoint to call, as it needs at least one item to change or update. 

```
{
	"id": 3
	"item": "the new item name goes here"
	"dueDate": "2017-12-31 12:00:00"
	"completed": true
}
```

It is not necessary to provide the username and password URL parameters, the authorization header token is sufficient. 

If you've successfully updated an item, you will receive a message with the ToDo item's full details: 

```
{"id":3,"item":"testC","dueDate":"nil","completed":true}
```

If anything is unauthorized, the API will produce a 401 Unauthorized error. In the unlikely event there is a valid token, but there is no user or some other kind of error, the API will produce an error and corresponding message similar to:

```
{"error":"Failed to update"}
```

### /delete

To delete a ToDo item, use your favorite http client to make a post request to /delete with the appropriate authorization header including the token as described above, as well as JSON body containing the key "id" with the id for the ToDo item you want to destroy. 

```
{
	"id": 3
}
```

It is not necessary to provide the username and password URL parameters, the authorization header token is sufficient. 

If you've successfully deleted an item, you will receive a message from the system confirming it: 

```
{"id":3,"deleted":true}
```

If anything is unauthorized, the API will produce a 401 Unauthorized error. In the unlikely event there is a valid token, but there is no corresponding id or some other kind of error, the API will produce an error and corresponding message similar to:

```
{"error":"Failed to delete"}
```

## Notes about the iOS App

Current the iOS app supports user registration, login, ToDo item browsing, ToDo item deletion/mark complete/mark incomplete (swipe for actions), and ToDo item creation.

## Issues

We are transitioning to using JIRA for all bugs and support related issues, therefore the GitHub issues has been disabled.

If you find a mistake, bug, or any other helpful suggestion you'd like to make on the docs please head over to [http://jira.perfect.org:8080/servicedesk/customer/portal/1](http://jira.perfect.org:8080/servicedesk/customer/portal/1) and raise it.

A comprehensive list of open issues can be found at [http://jira.perfect.org:8080/projects/ISS/issues](http://jira.perfect.org:8080/projects/ISS/issues)



## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
