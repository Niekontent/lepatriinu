# Lepatriinu

Lepatriinu is a simple polling application. The application should allow users to create new polls, vote in polls, and see real-time updates of the poll results.

## Requirements

- [x] All code should be shared via private Github repository.
- [x] The solution should be built with Phoenix LiveView.
- [x] The solution should use database as a persistent storage.
- [x] Users should be able to create account by inserting their username.
- [x] Users should be able to create new polls.
- [x] Users should be able to vote in existing polls.
- [x] Users should be able to see real-time updates of the poll results.
- [x] User can only vote once in a single poll.
- [x] You are free to use any Elixir/Erlang library and any open-source CSS framework for the UI.
- [x] The application should start with mix phx.server so it can be started locally.
- [x] The application should be well-structured, and the code should be readable.

## How does the application work

User is able to register by the name. User is able to crate polls. Poll contains the question and minimum two options. 
User is able to vote in the polls but only once per poll. After casting the vote user sees current results. 
User sees real-time updates of the poll results.

The core business functionality will be found in **polling.ex** file. This approach is very useful for structuring applications, separating business logic from the concrete implementation and enabling easy code replacement.
Phoenix.PubSub is used to keep PollDetailsLive updated about result changes. The subscriber and receiver modules are independent from each other.

## Tool versions

- The .tool-versions file is used by the asdf tool, which is a version manager for programming languages ​​and tools. 
It allows you to manage different versions of tools in one place.
- To install tool versions from the file: `asdf install`

## Setup

- Install all dependencies: `mix deps.get`
- Create database: `mix ecto.create`
- Run database migrations: `mix ecto.migrate`

## Testing

- Run the tests `mix test`

## Starting app

- Run the application: `mix phx.server`