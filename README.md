# Restaurant API

Rails 8 API backend for the restaurant website.

## Requirements

- Ruby 3.x (see `.ruby-version`)
- PostgreSQL

## Setup

```bash
bin/setup
bin/rails db:seed
bin/rails server
```

## API Endpoints

```
GET  /api/v1/menu_categories                        # all categories
GET  /api/v1/menu_categories/:slug                  # single category with items
GET  /api/v1/menu_categories/:slug/menu_items       # items in a category
GET  /api/v1/menu_items                             # all items
GET  /api/v1/menu_items/:id                         # single item
POST /api/v1/reservations                           # create reservation
GET  /api/v1/reservations/:confirmation_code        # look up reservation
```

### Query parameters

`GET /api/v1/menu_categories` — `?type=food|beverage|paella|tapas`, `?root=true`

`GET /api/v1/menu_categories/:slug/menu_items` — `?featured=true`

`GET /api/v1/menu_items` — `?category=slug`, `?featured=true`

### Create reservation payload

```json
{
  "reservation": {
    "name": "John Smith",
    "email": "john@example.com",
    "phone": "+1 555 0100",
    "party_size": 4,
    "reservation_date": "2026-10-15",
    "reservation_time": "19:00",
    "special_requests": "Window table if possible"
  }
}
```
