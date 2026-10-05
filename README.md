# Wheelhouse

Wheelhouse manages the customers, bikes, repairs, services, and staff of a bicycle workshop. All five resources can be created, edited, and deleted from the browser. Each repair records its services and the prices charged for them.

## Prerequisites

- Git
- Ruby `4.0.6` and Bundler (see `.ruby-version`)
- Node.js `25.9.0` and Yarn `1.22` (see `.node-version`)
- PostgreSQL 16 or newer running locally on port `5432`
- libvips for image processing and PostgreSQL development headers for the `pg` gem

Rails and the other Ruby dependencies are installed by Bundler. Bootstrap and its CSS tools are installed by Yarn.

Install the system dependencies on Ubuntu/Debian:

```bash
sudo apt update
sudo apt install libvips-tools libpq-dev postgresql postgresql-contrib build-essential
sudo systemctl enable --now postgresql
```

On macOS with Homebrew:

```bash
brew install vips postgresql@16
```

Install Bundler and Yarn if missing:

```bash
gem install bundler
npm install --global yarn@1.22.22
```

Check versions with `ruby -v`, `bundle -v`, `node -v`, `yarn -v`, and `vips --version`.

## Clone and install

```bash
git clone https://github.com/ThaielSC/webtech-wheelhouse.git
cd webtech-wheelhouse
bundle install
yarn install --frozen-lockfile
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
bin/rails db:create db:migrate db:seed
yarn build:css
```

These commands create the databases, apply every migration, and seed the development database with sample customers, bikes, repairs, services, staff, intake photos, and formatted diagnoses. The seed also generates both named photo variants. The seed replaces existing workshop data when run again.

When updating an existing checkout, install dependencies as above and apply pending migrations:

```bash
bin/rails db:migrate
yarn build:css
```

## Start the app

```bash
bin/dev
```

This starts Rails and the CSS watcher. Open [http://localhost:3000/repairs](http://localhost:3000/repairs) to see the intake thumbnails and diagnosis previews. Stop both processes with `Ctrl+C` in the same terminal.

If port 3000 is already occupied, stop the previous server or start on another port:

```bash
PORT=3001 bin/dev
```

Then open [http://localhost:3001](http://localhost:3001).

## Using the repair form

A new repair offers two empty service lines. Editing a repair offers its existing lines and one extra empty line. To add more services, save the repair and open Edit again. A line with no service selected is ignored. Select “Remove this service” to delete an existing line when saving the repair.

## Intake photos and diagnosis

Photos accept JPEG and PNG up to 10 MB per file. Select several files in the repair form to add them in one submission. Editing without selecting files preserves existing photos. An invalid upload rejects the whole submission with status 422; choose the files again after correcting the errors.

Open a repair to see all its larger photos, click a photo for the original file, or remove one photo with a confirmed DELETE request. Write the optional diagnosis in the rich-text editor. Action Text renders its formatting and filters unsafe HTML; list previews use plain text.

The seed creates 16 repairs: 12 have photos, the first has four, and four have none. Fourteen have a formatted diagnosis; the two newly received repairs have none. Running `bin/rails db:seed` again recreates the demonstration data with the same number of rows in every table.

Uploaded originals and generated variants live in `storage/`, which Git ignores. The source photos are committed in [db/seeds/photos](db/seeds/photos). Their authors, source URLs, and CC0 license are listed in [db/seeds/README.md](db/seeds/README.md). Seeding uses local files and requires no image downloads.

## Project documentation

- [User stories and acceptance criteria](docs/user-stories.md)
- [Domain model and entity lifecycle](docs/domain-model.md)
- [Decisions record](docs/decisions.md)
- [Wireframes and navigation](docs/wireframes.md)
