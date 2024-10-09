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

### 1. **Create a New Note**

- **URL**: `/note`
- **Method**: `POST`
- **Headers**: `Content-Type: application/json`
- **Request Body**:
    ```json
    {
        "text": "This is a new note"
    }
    ```
- **Response**:
    - `201 Created`
    - Response body:
        ```json
        {
            "id": 1,
            "text": "This is a new note",
            "created_at": "2024-09-15T20:10:00",
            "updated_at": "2024-09-15T20:10:00"
        }
        ```

### 2. **Get a Note by ID**

- **URL**: `/note/{id}`
- **Method**: `GET`
- **Response**:
    - `200 OK`
    - Response body:
        ```json
        {
            "id": 1,
            "text": "This is a new note",
            "created_at": "2024-09-15T20:10:00",
            "updated_at": "2024-09-15T20:10:00"
        }
        ```

    - `404 Not Found` if note doesn't exist:
        ```json
        {
            "error": "Note not found"
        }
        ```

### 3. **Update a Note**

- **URL**: `/note/{id}`
- **Method**: `PUT`
- **Headers**: `Content-Type: application/json`
- **Request Body**:
    ```json
    {
        "text": "Updated note text"
    }
    ```
- **Response**:
    - `200 OK`
    - Response body:
        ```json
        {
            "id": 1,
            "text": "Updated note text",
            "created_at": "2024-09-15T20:10:00",
            "updated_at": "2024-09-15T20:15:00"
        }
        ```

    - `404 Not Found` if note doesn't exist:
        ```json
        {
            "error": "Note not found"
        }
        ```

### 4. **Delete a Note**

- **URL**: `/note/{id}`
- **Method**: `DELETE`
- **Response**:
    - `204 No Content` on success.
    - `404 Not Found` if note doesn't exist:
        ```json
        {
            "error": "Note not found"
        }
        ```

### 5. **Get All Notes**

- **URL**: `/note`
- **Method**: `GET`
- **Query Parameters**:
    - `order_by`: `id`, `created_at`, or `updated_at`. Default: `id`
- **Response**:
    - `200 OK`
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
