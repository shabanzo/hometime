# Hometime API

This is a simple API application designed to handle reservation requests from various channels and clients.

## Contents

1. [Getting Started](https://github.com/shabanzo/hometime/blob/main/README.md#getting-started)
2. [Testing](https://github.com/shabanzo/hometime/blob/main/README.md#testing)
    - [Test Category](https://github.com/shabanzo/hometime/tree/main#test-category)
3. [Assumptions](https://github.com/shabanzo/hometime/blob/main/README.md#assumptions)
4. [API Documentation](https://github.com/shabanzo/hometime/blob/main/README.md#api-documentation)
    - [Reservation - Upsert API](https://github.com/shabanzo/hometime/blob/main/README.md#reservation-upsert-api)
5. [Technical Documentation](https://github.com/shabanzo/hometime/blob/main/README.md#api-documentation)
    - [ER Diagram](https://github.com/shabanzo/hometime/tree/main#er-diagram)
    - [Additional Notes](https://github.com/shabanzo/hometime/tree/main#additional-notes)
    - [How to Add A New Channel](https://github.com/shabanzo/hometime/tree/main#how-to-add-a-new-channel)

## Getting Started

1. Make sure you have Ruby (v3.2.2) installed on your machine.
2. Set up the application environment with the following command:

```
bin/setup
```

3. Run the application using:

```
rails s
```

## Testing

Run tests with:

```
rspec
```

### Test Category

1. Unit Test: For services and models, testing different contexts within the services.
2. Integration Test: For controllers, testing the end-to-end process from the controller to the model.

## Assumptions

1. Payload #1 corresponds to Airbnb payload.
2. Payload #2 corresponds to Bookingcom payload.
3. Airbnb and Bookingcom are considered as channels.
4. Guest details will be updated if there are any changes.

## API Documentation

### Reservation - Upsert API

This API allows you to update or insert reservation data, considering the following requirements:

1. Accepts two types of payload formats: Airbnb and Bookingcom.
2. Parses and saves payloads to a Reservation model linked to a Guest.
3. Supports changes to both reservation and guest details.
4. Rolls back changes if updating the guest fails.

#### Endpoint

```
POST /api/v1/reservations/upsert
```

#### Payload example (Airbnb):

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

#### Payload example (Bookingcom):
```json
{
  "reservation": {
    "code": "YYY12345678",
    "start_date": "2021-04-14",
    "end_date": "2021-04-18",
    "expected_payout_amount": "4200.00",
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
      "639123456789"
    ],
    "listing_security_price_accurate": "500",
    "host_currency": "AUD",
    "nights": 4,
    "number_of_guests": 4,
    "status_type": "accepted",
    "total_paid_amount_accurate": "4700.00"
  }
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
  "payout_price": "4200.0",
  "security_price": "500.0",
  "start_date": "2021-04-14",
  "status": "accepted",
  "total_price": "4700.0"
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

## Technical Documentation
### ER Diagram
![ER Diagram](https://github.com/shabanzo/hometime/blob/main/public/Hometime%20-%20ER%20Diagram.png?raw=true)

### Additional Notes

1. [::Reservations::Payload::Converter](https://github.com/shabanzo/hometime/tree/main/app/services/reservations/payload/converter) - [Here](https://github.com/shabanzo/hometime/blob/main/app/services/reservations/upsert.rb#L31-L35) utilizing [Factory Method (Design Pattern)](https://refactoring.guru/design-patterns/factory-method)
    - [::Reservations::Payload::Converter::Airbnb](https://github.com/shabanzo/hometime/tree/main/app/services/reservations/payload/converter/airbnb) - Converts Airbnb payload to a standardized structure.
    - [::Reservations::Payload::Converter::Bookingcom](https://github.com/shabanzo/hometime/tree/main/app/services/reservations/payload/converter/bookingcom) - Converts Bookingcom payload to a standardized structure.
2. [::Reservations::Update](https://github.com/shabanzo/hometime/blob/main/app/services/reservations/update.rb) - Updates reservations and guests using Dry::Transactions. The transaction rolls back if any step fails, ensuring data consistency.
3. Modules, for example: [::Reservations module](https://github.com/shabanzo/hometime/blob/main/app/services/reservations.rb) - Help organize common methods and namespace services based on their domain, such as Reservations.
4. `Dry::Monads` for handling response properly.
## How to add a new channel?

1. Add a new identifier on [::Reservations::Payload::Identifier](https://github.com/shabanzo/hometime/blob/main/app/services/reservations/payload/identifier.rb)
2. Create a new converter under [::Reservations::Payload::Converter](https://github.com/shabanzo/hometime/tree/main/app/services/reservations/payload/converter)

