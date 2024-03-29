# my-team-api | API Documentation

## Project description

This API serves as a backend for my microverse's full-stack final project, 'My Team Builder'. This repository contains the backend portion of the mentioned project. To get access to the frontend portion, please follow [this link](https://github.com/canriquez/my-team-builder).

### Full stack application concept

This app is used by admins to review ACTIVE applicant's information and express its approval.
It will give admins the ability to browse through the different applicants, filter applicants for the applied position, and search for specific applicants' names.

The app will offer a menu with:

    - Home
    - Preferred active applicants
    - My job Posts

### Live demo @Heroku

[anriquez-my-team-api.herokuapp.com](https://anriquez-my-team-api.herokuapp.com)

### Database Entity Relation Diagram (ERD)

![](./public/images/erd.png)

### Rails Associations Map

![](./public/images/ram.png)

# Authentication and Authorization

## Authentication: Access to resources

Authentication is realized using JWT authentication generated by the API at signup and login endpoints. These tokens will be included in the JSON response.

## Authorization

Authorization is managed via the : user role (user/admin), preventing unauthorized access to application-specific endpoints and resources.

# API Documentation

This API uses `POST`,`GET`, and `PUT` requests to communicate and HTTP [response codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) to indicate status and errors. All responses come in standard JSON. All requests must include a `content-type` of `application/json,` and the body must be valid JSON.

## Response Codes

### Response Codes

```
200: Success
400: Bad Request
401: Unauthorized
404: Cannot be found
405: Method not allowed
422: Unprocessable Entity
50X: Server Error
```

### Error Codes Details

```
100: Bad Request
110: Unauthorized
120: User Authentication Invalid
130: Parameter Error
140: Item Missing
150: Conflict
160: Server Error
```

### Example Validation Error Message

```json
http code 422
{
    "message": "Validation failed: Password can't be blank, Email has already been taken"
}
```

## Login

- You send: Your login credentials.
- You get: An `API-Token` with wich, you can take further actions.

** Request:**

```
http://127.0.0.1:3000/signup?email=foo@bar.com&name=Foo Bar&avatar=https://me.org&password=12345&role=admin

POST /login HTTP/1.1
Accept: application/json
Content-Type: application/json
Content-Length: xy

```

**Successful Response:**

```json
HTTP/1.1 200 OK
Server: http://127.0.0.1:3000
Content-Type: application/json
Content-Length: xy

{
    "auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMSwiZXhwIjoxNjAxOTI2Mjk1fQ.L6VMTsxH4CcOCqtpC3OBryVzOtuWFImLujswdNJK6YM",
    "user": [
        {
            "id": 11,
            "email": "foo@bar.com",
            "name": "Foo Bar",
            "role": "admin",
            "updated_at": "2020-10-04T19:24:15.240Z"
        }
    ]
}
```

**Failed Response:**

```json
HTTP/1.1 401 Unauthorized
Server: http://127.0.0.1:3000
Content-Type: application/json
Content-Length: xy

{
    "message": "Invalid credentials"
}
```

## Signup

- You send: Your signup parameters.
- You get: An `API-Token` with wich you can take further actions.

** Request:**

```
http://127.0.0.1:3000/signup?email=foo@bar.com&name=Foo Bar&avatar=https://me.org&password=12345&role=admin

POST /login HTTP/1.1
Accept: application/json
Content-Type: application/json
Content-Length: xy

```

**Successful Response:**

```json
HTTP/1.1 200 OK
Server: http://127.0.0.1:3000
Content-Type: application/json
Content-Length: xy

{
    "message": "Success! - Account has been created.",
    "auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMSwiZXhwIjoxNjAxOTI1ODU1fQ.TyfBdHFJMuAOdUWsvmRYQafGjMpV2QqgYYOMIKpy94U"
}
```

**Failed Response:**

```json
HTTP/1.1 422 Unprocessable Entity
Server: http://127.0.0.1:3000
Content-Type: application/json
Content-Length: xy

{
    "message": "Validation failed: Password can't be blank, Email has already been taken."
}
```

## Actions with Authorization requirements

Depending on the endpoint required, this action will be requested using `POST`, `GET` and `PUT` and will require submitting the proper `Authorization` headers, including a valid JWT token.

Example endpoint: http://127.0.0.1:3000/users/11

** Request:**

```
http://127.0.0.1:3000/users/11

GET /login HTTP/1.1
Accept: application/json
Content-Type: application/json
Content-Length: xy

```

**Successful Response:**

```json
HTTP/1.1 200 OK
Server: http://127.0.0.1:3000
Content-Type: application/json
Content-Length: xy

HEADERS

{
    "AUTHORIZATION": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMSwiZXhwIjoxNjAxOTI1ODU1fQ.TyfBdHFJMuAOdUWsvmRYQafGjMpV2QqgYYOMIKpy94U"
}
```

## API Endpoints

| Endpoint                       | Functionality                                 | Authentication | Authorization :role | Details                          |
| ------------------------------ | --------------------------------------------- | -------------- | ------------------- | -------------------------------- |
| POST /signup                   | User Signup                                   | NA             | NA                  |                                  |
| POST /auth/login               | User Login                                    | NA             | NA                  |                                  |
|                                | Logout                                        |                |                     | Just kill browser token          |
| GET /users/:id                 | Get User Information                          | token          | :user               | :admin                           | profile page |
| PUT /users/:id                 | Update user profile information               | token          | :user               | :admin                           | profile page |
|                                |                                               |                |                     |                                  |
| GET /applications              | get all applications                          | token          | :admin              |                                  |
| GET /applications/:id          | get detailed application info                 | token          | :admin              | :user                            | It refers to applicant information details |
|                                |                                               |                |                     |                                  |
| POST /applications/:id/likes   | Create a new like / dislike for application   | token          | :admin              |                                  |
| PUT /applications/:id/likes    | Update a like/dislike                         | token          | :admin              |                                  |
| DELETE /applications/:id/likes | delete a like/dislike                         | token          | :admin              |                                  |
|                                |                                               |                |                     |                                  |
| GET /adhome                    | get all application information for home page | token          | :admin              | Custome made query 2ms execution |
|                                |                                               |                |                     |                                  |
|                                |                                               |                |                     |                                  |
| POST /applications             | Create a new application                      | token          | :user & author      | only :user and author            |
| PUT /applications/id           | Update an application                         |                | :user & author      | only :user and author            |
| DELETE /applications/:id/likes | Delete application                            |                | :user & :admin      | only :user, author and :admin    |
|                                |                                               |                |                     |                                  |
| POST /jobposts                 | Create a new application                      |                | :admin              |                                  |
| PUT /jobposts/id               | Update an application                         |                | :admin & author     | only :admin and author           |
| DELETE /jobposts/:id/likes     | Delete application                            |                | :admin & author     | only :admin and author           |

## Environment set up requirements

To run this project, you need ruby, rails and Postgresql installed in your environment
Run the following command:

```
$ ruby -v
ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-darwin21]


$ rails -v
Rails 7.0.3.1
```

- Ruby: If you don't get that result, follow this [link](https://www.ruby-lang.org/en/documentation/installation/) and install Ruby in your local environment.

- Rails: Ruby: If you don't get that result, follow this [link](https://guides.rubyonrails.org/getting_started.html) and install Ruby on Rails in your local environment.

- To install postgreSQL 12 (used in this project), follow [this link](https://www.postgresql.org/docs/12/tutorial-install.html)

### Setup

- Clone this repository in your local environment
- Located on the root of repository, execute

```
bundle install
```

```
rails db:create
rails db:migrate
```

This action will install all the required dependencies.

### Ruby on Rails Database Configuration

- Your local application should be able to create development and test databases.
- For this purpose, the database configuration file contains environment variables for the DB user and password using during the `pg` server creation.
- Please configure the environment variable `MYTEAMAPI_DATABASE_PASSWORD` with the same password used during the pg server configuration.

```

config/database.yml

[...]
#
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: myteamapi
  password: <%= ENV['MYTEAMAPI_DATABASE_PASSWORD'] %>

development:
  <<: *default
  database: my_team_api_development
[...]

```

### Start Development Server

To start the development server run:

```
rails s

=> Booting Puma
=> Rails 7.0.3.1 application starting in development 
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Version 4.3.12 (ruby 3.1.2-p20), codename: Mysterious Traveller
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://127.0.0.1:3000
* Listening on tcp://[::1]:3000
Use Ctrl-C to stop


```

And the API will start listening and answering Requests.

### API endpoint testing

For testing purposes, I recommend you use the application [Postman](https://www.postman.com/), so you can test endpoints and functionalities.

## Test

- This projects uses `RSpec` for testing models and controllers
- The tests set, executes 127 tests that drove the API implementation (TDD).
- To run the test run

```
$ rspec

Finished in 3.33 seconds (files took 3.13 seconds to load)
127 examples, 0 failures
```

## Built With

- Ruby (3.1.2)
- Ruby on Rails (7.0.1)
- PostgreSQL (12.4)
- RSpec
- Capybara
- FactoryBot
- Shoulda-Matchers
- Heroku-22 stack

## Authors

👤 Carlos Anriquez

- Github: [@canriquez](https://github.com/canriquez)
- Twitter: [@cranriquez](https://twitter.com/cranriquez)
- Linkedin: [linkedin](https://www.linkedin.com/in/carlosanriquez/)
- Portfolio: [www.carlosanriquez.com](https://www.carlosanriquez.com/)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](issues/).

## Acknowledgments

- My Family!
- @microverse / The Beagles

## Show your support

Give a ⭐️ if you like this project!

## 📝 License

This project is [MIT](LICENSE) licensed.
