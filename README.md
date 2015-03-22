# basis-connector
## Description
An HTTP Client library for MyBasis.com Fitness Trackers

***
## Installation
`$ gem install basis-connector`

***
## Authentication
The user will pass his "email/password" to our Authentication module to generate an access token
`Basis.authorize(email,password)`

***

## Functions
### Get Metrics
`Basis.get_metrics(date)`

### Get Activities
`Basis.get_activities(date)`

### Get Sleep data
`Basis.get_sleep(date)`


***

## Author
Helal Ismail
helal.hamed@gmail.com
