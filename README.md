# Wheelhouse

Wheelhouse manages the customers, bikes, repairs, services, and staff of a bicycle workshop. All five resources can be created, edited, and deleted from the browser. Each repair records its services and the prices charged for them.

## Prerequisites

- Git
- Ruby `4.0.6` and Bundler (see `.ruby-version`)
- Node.js `25.9.0` and Yarn `1.22` (see `.node-version`)
- PostgreSQL running locally on port `5432`; this project uses PostgreSQL 16 in development

Rails and the other Ruby dependencies are installed by Bundler. Bootstrap and its CSS tools are installed by Yarn.

## Clone and install

```bash
git clone https://github.com/ThaielSC/webtech-wheelhouse.git
cd webtech-wheelhouse
bundle install
yarn install
```

## Prepare PostgreSQL

Start your local PostgreSQL service. On macOS with Homebrew:

```bash
brew services start postgresql@16
```

Confirm that it accepts connections:

```bash
pg_isready
```

The default configuration in `config/database.yml` connects locally using your operating-system username. That PostgreSQL role must exist and have permission to create databases. On macOS, Homebrew normally creates it during installation. If it is missing, create it using an existing PostgreSQL administrator account. On Linux with a local `postgres` administrator:

```bash
sudo -u postgres createuser --createdb "$USER"
```

If you use a different PostgreSQL account or server, set `username`, `password`, and `host` under `development` in `config/database.yml` to match it.

## Create the database and build the CSS

For a fresh clone with an empty database:

```bash
bin/rails db:setup
yarn build:css
```

`db:setup` creates the databases, loads the schema, and seeds the development database with sample customers, bikes, repairs, services, and staff. The seed replaces existing workshop data when run again.

When updating an existing checkout, install dependencies as above and apply pending migrations:

```bash
bin/rails db:migrate
yarn build:css
```

## Start the app

```bash
bin/dev
```

This starts Rails and the CSS watcher. Open [http://localhost:3000](http://localhost:3000). Stop both processes with `Ctrl+C` in the same terminal.

If port 3000 is already occupied, stop the previous server or start on another port:

```bash
PORT=3001 bin/dev
```

Then open [http://localhost:3001](http://localhost:3001).

## Using the repair form

A new repair offers two empty service lines. Editing a repair offers its existing lines and one extra empty line. To add more services, save the repair and open Edit again. A line with no service selected is ignored. Select “Remove this service” to delete an existing line when saving the repair.

## Project documentation

- [User stories and acceptance criteria](docs/user-stories.md)
- [Domain model and entity lifecycle](docs/domain-model.md)
- [Decisions record](docs/decisions.md)
- [Wireframes and navigation](docs/wireframes.md)
