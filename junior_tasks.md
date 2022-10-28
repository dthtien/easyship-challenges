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

**Note**: Sometimes a shipment has lots of shipment_items. Don't forget to consider performance.

## Task 3

Finally, we would like to add an endpoint `POST /companies/:company_id/shipments/search` where users can search shipments by number of items.

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
