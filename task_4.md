# Audit

## Motivation
We need a logging module that saves all record changes for multiple models to keep track of record changes.

## Approach: Capture and store data changes to the database via callback

### Step 1: Create an audit Model
- Migration
```ruby
class CreateAudits < ActiveRecord::Migration[6.1]
  def change
    create_table :audits do |t|
      t.references :auditable, polymorphic: true, index: true
      t.string :event
      t.json :object_changes

      t.timestamps
    end
  end
end
```
- Model
```
# app/models/audit.rb

class Audit < ApplicationRecord
  belongs_to :auditable, polymorphic: true
end
```
Note:
- `auditable`: the actual entity that the audit will belong to
- `event`: the event that causes change [:update, :create, :destroy]
- `object_changes`: will store the [`entity.saved_change`](https://github.com/rails/rails/blob/8015c2c2cf5c8718449677570f372ceb01318a32/activerecord/lib/active_record/attribute_methods/dirty.rb#L110)

### Step 2: Create a helper to support the audit
- Create a module that helps us hook to ActiveRecord::Callback
```ruby
# app/models/concerns/audits/auditable.rb
module Audits
  module Auditable
    extend ActiveSupport::Concern
    EVENTS = %i[create update destroy].freeze

    included do
      has_many :audits, -> { order(created_at: :asc) }

      class << self
        def auditable(*events)
          audit_events = (events.empty? ? EVENTS : events)
          audit_events.each do |event|
            method_name = define_callback(event)
            inject_callback(event, method_name)
          end
        end

        private

        def define_callback(event)
          method_name = "_process_audit_on_#{event}"

          class_eval <<-EORUBY, __FILE__, __LINE__ + 1
          def #{method_name}
            attributes = {
              auditable: self,
              event: '#{event}',
              object_changes: saved_changes
            }

            Audit.create! attributes
          end
          EORUBY

          method_name
        end

        def inject_callback(event, processing_method)
          set_callback event.to_sym, :after, processing_method.to_sym
        end
      end
    end
  end
end
```

### Step 3 apply to models

```ruby
# app/models/shipment.rb
class Shipment < ApplicationRecord
  include Audits::Auditable

  auditable
end

# app/models/shipment_items.rb
class ShipmentItem < ApplicationRecord
  include Audits::Auditable

  auditable :update
end
```

### Pros and Cons
- Pros:
  - Quick and easy to implement
  - Can extendable to sync the data to other services via a message broker
- Cons
  - Some methods will skip callback which means we will lose the audit data when we use these methods:
    ref: https://guides.rubyonrails.org/active_record_callbacks.html#skipping-callbacks
  - The data will increase from time to time which might affect the query

### References

### Alternative solution: Create a DB-level log using triggers
In the approach, We are using some methods that skip the callback, which means some audit data will be lost. To
resolve that issue, an approach applies to the database trigger and stores the changes data in the table or
additional column.

- More details approach: https://github.com/palkan/logidze

#### Pros:
  - Triggers can capture all event types: INSERTs, UPDATEs, and DELETEs - no more lost audit data
#### Cons
  - Triggers increase the execution time of the original statement and thus hurt the performance of PostgreSQL.
  - Creating and managing triggers induce additional operational complexity.
  - It is not easy to extend or change since it runs on a database layer
  - Adds additional overhead to the database

### Alternative solution: Using CDC - Trigger based to identify and tracks changes to data in a database
Besides using database triggers, we can use the [change data capture(CDC)](https://en.wikipedia.org/wiki/Change_data_capture) to identify and track changes to data in the
database. With trigger-based CDC, the source database system is configured to trigger a notification when data is
written or altered within the source database.

I don't have much experience in this approach, but this seems suitable to the [Extract Transform Load (ETL)](https://en.wikipedia.org/wiki/Extract,_transform,_load), [Extract, Load Transform(ELT)](https://en.wikipedia.org/wiki/Extract,_load,_transform) data pipeline.


## References
- https://evilmartians.com/chronicles/logidze-1-0-active-record-postgresql-rails-and-time-travel?utm_source=logidze
- https://github.com/paper-trail-gem/paper_trail
- https://github.com/collectiveidea/audited
