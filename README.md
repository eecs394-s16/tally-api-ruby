# Tally API
## Authorization
In order to make the majority of requests, you must pass in a `session_key` with the request.


This `session_key` can be retrieved when [creating a user](#create-new-user) or [logging a user in](#login).


To authenticate the request, set the `session_key` as the `Authorization` header of the request. You can set the `Authorization` header of all requests in Angular, or set the header of each individual request.

## Table of Contents
1. Data Structures
   * [User](#user)
   * [Session](#session)
   * [Collection](#collection)
   * [Item](#item)
2. User Routes
   * [Create New User](#create-new-user)
   * [Login](#login)
3. Collection Routes
   * [Get User Collections](#get-user-collections)
   * [Get Collection by ID](#get-collection-by-id)
   * [Import Collection From Pinterest](#import-collection-from-pinterest)

## Data Structures
### User
```json
{
  "id": <int>,
  "username": <string>,
  "access_token": <string>
}
```

### Session
```json
{
  "id": <int>,
  "session_key": <string>
}
```

### Collection
```json
{
  "id": <int>,
  "name": <string>
}
```

### Item
```json
{
  "id": <int>,
  "price": <int>, // Price in cents
  "name": <string>
}
```


## User Routes
### Create New User
```json
POST /users

// Request
// ========
{
  "username": <string>,
  "password": <string>,
  "access_token": <string>
}

// Response
// =========
{
  "user": <User>,
  "session": <Session>
}
```

### Login
```json
POST /login

// Request
// ========
{
  "username": <string>,
  "password": <string>
}

// Response
// =========
{
  "session": <Session>
}
```

## Collection Routes
### Get User Collections
```json
GET /collections

// Response
// =========
{
  "collections": [<Collection>]
}

### Get Collection by ID
```json
GET /collections/:id

// Response
// =========
{
  "collection": <Collection>,
  "items": [<Item>]
}
```

### Import Collection From Pinterest
```json
POST /pinterest/collections/:collection_id/import

// Request
// ========
{
  "name": <string>
}

// Response
// =========
{
  "collection": <Collection>,
  "items": [<Item>]
}
```
