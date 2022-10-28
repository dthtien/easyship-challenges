## Task 1

The frontend needs to display the items included in a shipment. Write a instance method for `shipment` that groups its associated `shipment_items` by description and returns an array of hashes. The hashes should be ordered by count, in descending or ascending order depending on the `items_order` param.

Given a `shipment` containing following `shipment_items`: 1 Apple Watch, 2 iPhones, and 3 iPads, the function is expected to be able to return:

``` ruby
# with ascending order
[
  { description: 'Apple Watch', count: 1 },
  { description: 'iPhone', count: 2 },
  { description: 'iPad', count: 3 }
]

# with descending order
[
  { description: 'iPad', count: 3 },
  { description: 'iPhone', count: 2 },
  { description: 'Apple Watch', count: 1 }
]
```

## Task 2

Now let's implement an endpoint `GET /companies/:company_id/shipments/:id?items_order={asc/desc}` to retrieve data of a specific shipment. The response should look like this:

``` jsonc
// when items_order `asc`
{
  "shipment": {
    "company_id": 1,
    "destination_country": "USA",
    "origin_country": "HKG",
    "tracking_number": "UM111116399USA",
    "slug": "usps",
    "created_at": "2021 May 26 at 2:30 PM (Monday)",
    "items": [
      { "description": "Apple Watch", "count": 1 },
      { "description": "iPhone", "count": 2 },
      { "description": "iPad", "count": 3 }
    ]
  }
}

// when items_order `desc`
{
  "shipment": {
    "company_id": 1,
    "destination_country": "USA",
    "origin_country": "HKG",
    "tracking_number": "UM111116399USA",
    "slug": "usps",
    "created_at": "2021 May 26 at 2:30 PM (Monday)",
    "items": [
      { "description": "iPad", "count": 3 },
      { "description": "iPhone", "count": 2 },
      { "description": "Apple Watch", "count": 1 }
    ]
  }
}
```

## Task 3

Our clients want to track theier shipments, so let's update that endpoint to include tracking information provided by the [Aftership API](https:#developers.aftership.com/reference/overview) in the response. Make a request to the Aftership API to retrieve the required information and update the response accordingly:

``` jsonc
{
  "shipment": {
    "company_id": 1,
    "destination_country": "USA",
    "origin_country": "HKG",
    "tracking_number": "92748902711539543475379057",
    "slug": "usps",
    "created_at": "2021 May 26 at 2:30 PM (Monday)",
    "tracking": {
      "status": "InTransit",
      "current_location": "ISC NEW YORK NY(USPS)",
      "last_checkpoint_message": "Processed Through Facility",
      "last_checkpoint_time": "Friday, 21 July 2017 at 8:55 PM"
    }
  }
}
```

- Notes
  - Don't need to make real API calls; instead, write tests and make sure that pass (hint: `mock` or `stub`)
  - Fake responses are available under `spec/fixtures/aftership/`
  - Don't forget to deal with the situation where tracking information is unavailable

## Task 4

By this time, you may have noticed that we have an endpoint `GET /companies/:company_id/shipments` that now retrieves all shipments but that's certainly buggy! Have a look and fix it so that only shipments that belong to a certain company are included in the response. The response should look like this:

``` jsonc
{
  "shipments": [
    {
      "id": 1,
      "company_id": 1,
      "destination_country": "USA",
      "origin_country": "HKG",
      "tracking_number": "UM111116399USA",
      "slug": "usps",
      "created_at": "2021 May 26 at 2:30 PM (Monday)",
      "items": [
        { "description": "Apple Watch", "count": 1 },
        { "description": "iPhone", "count": 2 },
        { "description": "iPad", "count": 3 }
      ]
    },
    // ... omitted ...
    {
      "id": 999,
      "company_id": 1,
      "destination_country": "USA",
      "origin_country": "HKG",
      "tracking_number": "UM459056399US",
      "slug": "dhl",
      "created_at": "2021 May 26 at 2:30 PM (Monday)",
      "items": [
        { "description": "Apple Watch", "count": 1 },
        { "description": "iPhone", "count": 2 },
        { "description": "iPad", "count": 3 }
      ]
    }
  ]
}
```

**Note**: a shipment could have lots of shipment_items. Keep performance in mind implementing the feature

## Task 5

We would like to add another endpoint `POST /companies/:company_id/shipments/search` where users can search shipments by number of items.

``` jsonc
// request body
{ "shipment_items_size": 1 }

// response
{
  "shipments": [
    {
      "id": 1,
      "company_id": 1,
      "destination_country": "USA",
      "origin_country": "HKG",
      "tracking_number": "UM111116399USA",
      "slug": "usps",
      "created_at": "2021 May 26 at 2:30 PM (Monday)",
      "items": [
        { "description": "Apple Watch", "count": 1 }
      ]
    },
    // ... omitted ...
    {
      "id": 999,
      "company_id": 1,
      "destination_country": "USA",
      "origin_country": "HKG",
      "tracking_number": "UM459056399US",
      "slug": "dhl",
      "created_at": "2021 May 26 at 2:30 PM (Monday)",
      "items": [
        { "description": "iPhone", "count": 1 }
      ]
    }
  ]
}
```

**BONUS**: search by shipment_item's description

``` jsonc
// request body
{ "shipment_items": { "description": "Apple Watch" } }

// response
{
  "shipments": [
    {
      "id": 1,
      "company_id": 1,
      "destination_country": "USA",
      "origin_country": "HKG",
      "tracking_number": "UM111116399USA",
      "slug": "usps",
      "created_at": "2021 May 26 at 2:30 PM (Monday)",
      "items": [
        { "description": "Apple Watch", "count": 1 },
        { "description": "iPhone", "count": 1 }
      ]
    },
    // ... omitted ...
    {
      "id": 999,
      "company_id": 1,
      "destination_country": "USA",
      "origin_country": "HKG",
      "tracking_number": "UM459056399US",
      "slug": "dhl",
      "created_at": "2021 May 26 at 2:30 PM (Monday)",
      "items": [
        { "description": "Apple Watch", "count": 1 }
      ]
    }
  ]
}
```

## Task 6

To keep track of record changes, we need a logging module that saves all record changes for multiple models. Please create a `task6.md` file and write pseudo codes that track changes of shipments and shipment items.

**BONUS**: Log changes only for specified columns

## Task 7

Thanks to your contributions, our website becomes popular. For the endpoint `GET companies/:company_id/shipments/:id`, we get 100 times more requests than before and clients start to complain slow response time. Please create a `task7.md` file and share possible solutions to improve the response time.
