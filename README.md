# Manganese

## WIP
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:
* Ruby version
* System dependencies
* Configuration
* Database creation
* Database initialization
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions

## Prescriptions
- After running any generator, go into the migration and
  - set `null: false` where necessary
  - set `type: :uuid` on all foreign key references (see https://railsbytes.com/script/V4Ys1d)
- Use `timestamp_tz`
- If UUID, causes problems with `.first` and `.last` not working, see [this link](https://betterprogramming.pub/empowering-a-rails-application-with-uuid-as-default-primary-key-44cd740828e8)

## 'Script'

### Basics

Start with a basic setup such as would be suitable for any small Rails project.
- `rails new manganese --database=postgresql --skip-coffee`
- UUID: `rails app:template LOCATION='https://railsbytes.com/script/V4Ys1d'`
- Setup (See below)
- Authentication: [Devise](https://github.com/heartcombo/devise)
- [Letter Opener](https://github.com/ryanb/letter_opener)


### Implementation

Move on to setting up things that represent the specific project we're working on
- `rails generate scaffold Artist name:string`
- `rails generate scaffold Album name:string artist:references`
- `rails generate scaffold Recommendation user:references album:references`
- `rails generate scaffold Service name:string`
- `rails generate scaffold Source url:string album:references service:references`
- `rails generate scaffold Event name:string started_at:timestamp`
- `rails generate scaffold Play album:references event:references`


## Setup

A few steps are needed after cloning the repository:
- Initialize data directory: `initdb /opt/homebrew/var/postgres-manganese`
- Create databases: `rake db:setup`
- `bundle install`

## Development Servers

### Start
- Postgres:
  - `postgres -D /opt/homebrew/var/postgres-manganese`, or
  - `pg_ctl -D /opt/homebrew/var/postgres-manganese -l logfile start`
- Rails: `rails s`

### Stop
- Postgres: `pg_ctl stop -D /opt/homebrew/var/postgres-scratch`
- Rails: ctrl c

### Test
- `rails test`
- `rails test:system`
