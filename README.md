# Tally API
## Table of Contents
1. Data Structures
   * [User](#User)
   * [Session](#Session)
2. User Routes
   * [Create New User](#create-new-user)
3. Collection Routes

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
