Attached is a zip with a repo on which we ask you to complete the following tasks (You can ignore the `.md` files).

- **Repository:** Create a private repository on Github and share it with shhavel, JMCRomao and rockotseng
- **Questions** Please add this file to the root of your project and submit it to git
- **Bugs:** Fix any bugs you find and feel free to suggest changes to make the codes cleaner
- **Git Workflow:** For each task, create a new feature branch. Base the first branch off master, and the remaining ones off the previous one
- **Review:** Open a PR and request reviews once the last task is completed. We will be commenting on your PRs and requesting changes, if needed
- **Test:** To ensure code changes adhere to the desired functionality, please write tests using RSpec

## Task 1
The frontend needs to display the items included in a shipment. Write an instance method for `shipment` that groups its associated `shipment_items` by description and returns an array of hashes. The hashes should be ordered by count, in descending or ascending order depending on the `items_order` param.

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

### Task 2

Our clients want to track their shipments so we need to create a new endpoint that will allow them to retrieve this information.
Create a new endpoint with the following route `GET /companies/:company_id/shipments/:id/tracking` that returns the tracking information provided by the [Aftership API](https://developers.aftership.com/reference/overview) in the response.

``` jsonc
{
  "status": "InTransit",
  "current_location": "ISC NEW YORK NY(USPS)",
  "last_checkpoint_message": "Processed Through Facility",
  "last_checkpoint_time": "Friday, 21 July 2022 at 8:55 PM"
}
```

Notes:
- You don't need to make real API calls. Instead, write tests and make sure they pass (hint: `mock` or `stub`)
- Fake responses are available under `spec/fixtures/aftership/`
- Don't forget to deal with the situation where tracking information is unavailable
- We expect you to make your own implementation of an Aftership client instead of using an off-the-shelf one

### Task 3
Please create an endpoint with the following route `POST /companies/:company_id/shipments/search` where users can search shipments by number of items.

``` jsonc
// Example request body
{ "shipment_items_size": 1 }

// Example response
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

### Task 4

To keep track of record changes, we need a logging module that saves all record changes for multiple models.

Please create a `task_4.md` file and write pseudo codes that track changes of shipments and shipment items.

