# Hometime API

A simple API-based application to store reservation request from multiple-channels/clients.

## Contents

1. [Getting Started](https://github.com/shabanzo/hometime/blob/main/README.md#getting-started)
2. [Testing](https://github.com/shabanzo/hometime/blob/main/README.md#testing)
3. [Assumptions](https://github.com/shabanzo/hometime/blob/main/README.md#assumptions)
4. [API Documentation](https://github.com/shabanzo/hometime/blob/main/README.md#api-documentation)
   - [Reservation API](https://github.com/shabanzo/hometime/blob/main/README.md#reservations-upsert-api)

## Getting Started

1. Ensure you have installed Ruby in your machine, specifically for this application we're using Ruby v.3.2.2
2. Setup the application environment by executing this command:

```
bin/setup
```

3. The application is ready to run by executing this command:

```
rails s
```

## Testing

Simply execute this command:

```
rspec
```

### Test Category

1. Unit Test - For services and models - Testing contexts under the services
2. Integration Test - For controllers - Testing end-to-end process from controller to model

## Assumptions

1. Payload #1 as AirBNB payload
2. Payload #2 as Bookingcom payload

## API Documentation

### Reservations - Upsert API

API for upserting (updating or inserting) a reservation data with this requirements:

1. Can accept two kinds of payload formats: AirBNB and Bookingcom
2. Parse and save the payloads to a Reservation model that belongs to a Guest
3. Can accept changes to the reservation and the guest
4. Rollback changes when the updating guest fails

#### How to add a new channel?

1. Add a new identifier on [::Reservations::Payload::Identifier](https://github.com/shabanzo/hometime/blob/main/app/services/reservations/payload/identifier.rb)
2. Create a new converter under [::Reservations::Payload::Converter](https://github.com/shabanzo/hometime/tree/main/app/services/reservations/payload/converter) because it's using Factory Method (Design Pattern).

#### Endpoint

```
POST /api/v1/reservations/upsert
```

#### Payload example:

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

#### Success response example (status: 200):

```json
{
  "adults": 2,
  "children": 2,
  "code": "YYY12345678",
  "currency": "AUD",
  "end_date": "2021-04-18",
  "guest": {
    "email": "wayne_woodbridge@bnb.com",
    "first_name": "Wayne",
    "last_name": "Woodbridge",
    "phone": "639123456789"
  },
  "guests": 4,
  "infants": 0,
  "nights": 4,
  "payout_price": "4200.00",
  "security_price": "500",
  "start_date": "2021-04-14",
  "status": "accepted",
  "total_price": "4700.00"
}
```

#### Failed response example (status: 501):

```json
{
  "message": "The payload can not be identified!"
}
```

| Error code | Descriptions                                                              |
| ---------- | ------------------------------------------------------------------------- |
| 501        | The payload can't be identified                                           |
| 422        | Unprocessable content - the details will be provided in the error message |
