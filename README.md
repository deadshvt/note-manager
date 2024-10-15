# note-manager

## Overview

This is a simple Note Manager API built with Perl using Mojolicious. It provides functionality for creating, reading, updating, and deleting notes.

## Installation

1. **Clone the repository:**

```shell
git clone https://github.com/deadshvt/note-manager.git
```

2. **Go to the project directory:**

```shell
cd note-manager
```

## Running the application

1. **Run containers**

```shell
make run
```

2. **Stop containers**

```shell
make stop
```

3. **Check logs**

```shell
make logs
```

4. **Restart containers**

```shell
make restart
```

## API

### 1. **Get a Note by ID**

- **Path**: `/note/{id}`
- **Method**: `GET`
- **Response**:
    - `200 OK` on success:
      - Response body:
          ```json
          {
              "id": 1,
              "text": "This is a new note",
              "created_at": "2024-09-15T20:10:00",
              "updated_at": "2024-09-15T20:10:00"
          }
          ```

    - `400 Bad Request` if ID is missing:
      - Response body:
          ```json
          {
              "error": "Missing ID"
          }
          ```
        
    - `400 Bad Request` if ID ain't valid:
      - Response body:
          ```json
          {
              "error": "Invalid ID"
          }
          ```

    - `404 Not Found` if note ain't exist:
      - Response body:
          ```json
          {
              "error": "Note not found"
          }
          ```

    - `500 Internal Server Error` if there is a failure in getting a note by ID:
      - Response body:
          ```json
          {
              "error": "Error message"
          }
          ```

### 2. **Create a New Note**

- **Path**: `/note`
- **Method**: `POST`
- **Headers**: `Content-Type: application/json`
- **Request Body**:
    ```json
    {
        "text": "This is a new note"
    }
    ```
- **Response**:
    - `201 Created` on success:
      - Response body:
          ```json
          {
              "id": 1,
              "text": "This is a new note",
              "created_at": "2024-09-15T20:10:00",
              "updated_at": "2024-09-15T20:10:00"
          }
          ```

    - `500 Internal Server Error` if there is a failure in creating a note:
      - Response body:
          ```json
          {
              "error": "Error message"
          }
          ```

### 3. **Update a Note**

- **Path**: `/note/{id}`
- **Method**: `PUT`
- **Headers**: `Content-Type: application/json`
- **Request Body**:
    ```json
    {
        "text": "Updated note text"
    }
    ```
- **Response**:
    - `200 OK` on success:
      - Response body:
          ```json
          {
              "id": 1,
              "text": "Updated note text",
              "created_at": "2024-09-15T20:10:00",
              "updated_at": "2024-09-15T20:15:00"
          }
          ```

    - `400 Bad Request` if ID is missing:
      - Response body:
          ```json
          {
              "error": "Missing ID"
          }
          ```

    - `400 Bad Request` if ID ain't valid:
      - Response body:
          ```json
          {
              "error": "Invalid ID"
          }
          ```

    - `404 Not Found` if note ain't exist:
      - Response body:
          ```json
          {
              "error": "Note not found"
          }
          ```

    - `500 Internal Server Error` if there is a failure in updating a note:
      - Response body:
          ```json
          {
              "error": "Error message"
          }
          ```

### 4. **Delete a Note**

- **Path**: `/note/{id}`
- **Method**: `DELETE`
- **Response**:
    - `204 No Content` on success

    - `400 Bad Request` if ID is missing:
      - Response body:
          ```json
          {
              "error": "Missing ID"
          }
          ```

    - `400 Bad Request` if ID ain't valid:
      - Response body:
          ```json
          {
              "error": "Invalid ID"
          }
          ```

    - `404 Not Found` if note ain't exist:
      - Response body:
          ```json
          {
              "error": "Note not found"
          }
          ```

    - `500 Internal Server Error` if there is a failure in deleting a note:
      - Response body:
          ```json
          {
              "error": "Error message"
          }
          ```

### 5. **Get All Notes**

- **Path**: `/note`
- **Method**: `GET`
- **Query Parameters**:
    - `order_by`: `id`, `created_at`, or `updated_at`. Default: `id`
- **Response**:
    - `200 OK` on success:
      - Response body:
          ```json
          [
              {
                  "id": 1,
                  "text": "First note",
                  "created_at": "2024-09-15T20:10:00",
                  "updated_at": "2024-09-15T20:15:00"
              },
              {
                  "id": 2,
                  "text": "Second note",
                  "created_at": "2024-09-15T20:20:00",
                  "updated_at": "2024-09-15T20:25:00"
              }
          ]
          ```

    - `400 Bad Request` if order_by ain't valid:
      - Response body:
          ```json
          {
              "error": "Invalid order_by"
          }
          ```

    - `500 Internal Server Error` if there is a failure in getting all notes:
      - Response body:
          ```json
          {
              "error": "Error message"
          }
          ```
