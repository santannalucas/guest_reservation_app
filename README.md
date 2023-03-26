# Guest Reservation API
This is a simple guest reservation API built with Ruby on Rails to handle different payload/booking services.

## Installation

To get started, clone this repository:

```bash
git clone git@github.com:santannalucas/guest_reservation_app.git
```

Then, install the required dependencies using Bundler:

```bash
cd guest_reservation_app
bundle install
```

## Database setup
This application requires a SQLite3 database. Make sure you have it installed and running on your system.

Create the development and test databases:
```bash
rails db:create
```

Migrate the database schema:

```bash 
rails db:migrate
```

## Running tests

To run the test suite, use the following command:

```bash
rspec
```

This will run all the tests for the application.

Alternatively you can ran the tests individually:

### Models
```bash
rspec spec/models/guest_spec.rb
rspec spec/models/reservation_spec.rb
```

### Services
```bash
rspec spec/services/payload_manager_spec.rb
rspec spec/services/payload_parser_spec.rb
```

### Controller
```bash
rspec spec/requests/reservations_spec.rb
```

## Usage

Start the development server:

```bash
rails server
```

### Creating a Reservation
To create a reservation, make a POST request to the http://localhost:3000/reservations endpoint with a JSON payload:
You can use 2 different payload types:

#### Payload 1 example:
```json
{
"reservation_code": "YYY12345678",
"start_date": "2021-04-14",
"end_date": "2021-04-18",
"nights": 4,
"guests": 4,
"adults": 2,
"children": 2,
"infants": 0,
"status": "accepted",
"guest": {
"first_name": "Wayne",
"last_name": "Woodbridge",
"phone": "639123456789",
"email": "wayne_woodbridge@bnb.com"
},
"currency": "AUD",
"payout_price": "4200.00",
"security_price": "500",
"total_price": "4700.00"
}
```

#### Payload 2 example:
```json
{
"reservation": {
"code": "XXX12345678",
"start_date": "2021-03-12",
"end_date": "2021-03-16",
"expected_payout_amount": "3800.00",
"guest_details": {
"localized_description": "4 guests",
"number_of_adults": 2,
"number_of_children": 2,
"number_of_infants": 0
},
"guest_email": "wayne_woodbridge@bnb.com",
"guest_first_name": "Wayne",
"guest_last_name": "Woodbridge",
"guest_phone_numbers": [
"639123456789",
"639123456789"
],
"listing_security_price_accurate": "500.00",
"host_currency": "AUD",
"nights": 4,
"number_of_guests": 4,
"status_type": "accepted",
"total_paid_amount_accurate": "4300.00"
}
}
```

### Requests
A successful request should return STATUS :created and reservation data with id:

#### Payload 1  Example

```bash
 curl -X POST   http://localhost:3000/reservations   -H 'Content-Type: application/json'   -d '{
    "reservation_code": "YYY12345678",
    "start_date": "2021-04-14",
    "end_date": "2021-04-18",
    "nights": 4,
    "guests": 4,
    "adults": 2,
    "children": 2,
    "infants": 0,
    "status": "accepted",
    "guest": {
      "first_name": "Wayne",
      "last_name": "Woodbridge",
      "phone": "639123456789",
      "email": "wayne_woodbridge@bnb.com"
    },
    "currency": "AUD",
    "payout_price": "4200.00",
    "security_price": "500",
    "total_price": "4700.00"
  }'
```

Response
```bash
{"guest_id":3,"reservation_code":"YYY12345678","start_date":"2021-04-14","end_date":"2021-04-18","nights":4,"guests":4,"adults":2,"children":2,"infants":0,"status":"accepted","currency":"AUD","payout_price":"4200.0","security_price":"500.0","total_price":"4700.0","id":5,"created_at":"2023-03-26T07:40:15.640Z","updated_at":"2023-03-26T07:40:15.640Z"}
```

Application also updates data for existing Reservation/Client.
Using previous payload example, a update request should look like:
```bash
 curl -X POST   http://localhost:3000/reservations   -H 'Content-Type: application/json'   -d '{
    "reservation_code": "YYY12345678",
    "start_date": "2021-04-14",
    "end_date": "2021-04-22",
    "nights": 8,
    "guests": 4,
    "adults": 2,
    "children": 2,
    "infants": 0,
    "status": "accepted",
    "guest": {
      "first_name": "Wayne",
      "last_name": "Woodbridge",
      "phone": "639123456789",
      "email": "wayne_woodbridge@bnb.com"
    },
    "currency": "AUD",
    "payout_price": "7500.00",
    "security_price": "500",
    "total_price": "8000.00"
  }'
```

Updated Response:
```json
{
  "guest_id":3,
  "reservation_code":"YYY12345678",
  "start_date":"2021-04-14",
  "end_date":"2021-04-22",
  "nights":8,
  "guests":4,
  "adults":2,
  "children":2,
  "infants":0,
  "status":"accepted",
  "currency":"AUD",
  "payout_price":"7500.0",
  "security_price":"500.0",
  "total_price":"8000.0",
  "id":5,
  "created_at":"2023-03-26T07:40:15.640Z",
  "updated_at":"2023-03-26T07:50:59.067Z"
}
```

#### Unsupported Payload Example

Application accepts both payload types for the same reservation, but if a unsupported payload is provided, response will have status 422 - unprocessable entity and errors will be displayed and 

```bash
curl -X POST   http://localhost:3000/reservations   -H 'Content-Type: application/json'   -d '{
    "reservation_code_id": "YYY12345678",
    "start_date": "2021-04-14",
    "end_date": "2021-04-22",
    "nights": 8,
    "guests": 4,
    "adults": 2,
    "children": 2,
    "infants": 0,
    "status": "accepted",
    "currency": "AUD",
    "payout_price": "7500.00",
    "security_price": "500",
    "total_price": "8000.00"
  }'
```

Response:

```bash
{"errors":"Unsupported payload type"}
```

Application should handle most of errors when out of scope payload is provided

### Guest and Reservation Validation
Missing values will raise different response, API assumes that lower level validations are done on the client ie: (start_date < end_date, values sum, etc.), but missing fields are handle:

#### Missing Guest

Example of missing guest request:

```bash
 curl -X POST   http://localhost:3000/reservations   -H 'Content-Type: application/json'   -d '{
    "reservation_code": "YYY12345678",
    "start_date": "2021-04-14",
    "end_date": "2021-04-18",
    "nights": 4,
    "guests": 4,
    "adults": 2,
    "children": 2,
    "infants": 0,
    "status": "accepted",
    "guest": {
      "first_name": "",
      "last_name": "",
      "phone": "",
      "email": ""
    },
    "currency": "AUD",
    "payout_price": "4200.00",
    "security_price": "500",
    "total_price": "4700.00"
  }'
```

Response

```json
{
  "errors": {
    "email": [
      "can't be blank"
    ],
    "first_name": [
      "can't be blank"
    ],
    "last_name": [
      "can't be blank"
    ]
  }
}
```

#### Missing Reservation Fields

Example of missing reservations fields request:

```bash
 curl -X POST   http://localhost:3000/reservations   -H 'Content-Type: application/json'   -d '{
    "reservation_code": "YYY12345678",
    "guest": {
      "first_name": "Wayne",
      "last_name": "Woodbridge",
      "phone": "639123456789",
      "email": "wayne_woodbridge@bnb.com"
    }}'
```

response

```bash
  "errors": {
    "start_date": [
      "can't be blank"
    ],
    "end_date": [
      "can't be blank"
    ],
    "nights": [
      "can't be blank"
    ],
    "guests": [
      "can't be blank"
    ],
    "adults": [
      "can't be blank"
    ],
    "children": [
      "can't be blank"
    ],
    "infants": [
      "can't be blank"
    ],
    "status": [
      "can't be blank"
    ],
    "currency": [
      "can't be blank"
    ],
    "payout_price": [
      "can't be blank"
    ],
    "security_price": [
      "can't be blank"
    ],
    "total_price": [
      "can't be blank"
    ]
  }
}
```
