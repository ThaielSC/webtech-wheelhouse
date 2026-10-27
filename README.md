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

## Configure the API token

The API token is stored only in encrypted credentials as `api.token`. Never
commit a credentials key or a plaintext token. A local development token and
its ignored key may already exist in your working copy.

For a **fresh clone**, you do not have the author's development key. Replace
only the encrypted development credentials with your own before starting Rails:

```bash
rm config/credentials/development.yml.enc
EDITOR=nano bin/rails credentials:edit --environment development
```

Rails generates `config/credentials/development.key` (ignored by Git). In the
editor, save this structure, replacing the placeholder with a randomly generated
secret (for example, generate one with `openssl rand -hex 32`):

```yaml
api:
  token: YOUR_RANDOM_SECRET
```

On an existing configured checkout, run only the editor command to update the
token; do not remove credentials you can already decrypt. Keep the key private
and back it up securely. For production use
`EDITOR=nano bin/rails credentials:edit --environment production`, set the same
structure, and provide that environment's key through `RAILS_MASTER_KEY`.
The Lab 9 global encrypted credentials are preserved.

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

## Workshop Accounts & Authentication (Lab 11)

Only the service price list (`/services`) and authentication pages (`/session/new`, `/registration/new`, `/passwords/*`) are publicly accessible without signing in. Accessing any other page in the application requires an active session.

### Development seed accounts

The development database is seeded with accounts for the workshop team, plus an unassigned account with the default role. **These accounts exist only in the development environment**:

| Staff Member | Workshop Role | Email Address | Development Password |
|---|---|---|---|
| Marcus Vance | `owner` | `marcus@wheelhouse.cl` | `OwnerPass1234!` |
| Lucas Morales | `counter` | `lucas@wheelhouse.cl` | `CounterPass1234!` |
| Elena Rostova | `mechanic` | `elena@wheelhouse.cl` | `ElenaPass1234!` |
| Mateo Valenzuela | `mechanic` | `mateo@wheelhouse.cl` | `MateoPass1234!` |
| Sofia Alarcon | `mechanic` | `sofia@wheelhouse.cl` | `SofiaPass1234!` |
| *(None / Trainee)* | `mechanic` *(default)* | `trainee@wheelhouse.cl` | `TraineePass1234!` |

New accounts created through the registration form (`/registration/new`) default to the `mechanic` role (the role with the fewest permissions; see [Decisions record](docs/decisions.md#4-default-account-role-and-permission-hierarchy)). Role elevation or staff linking is managed via seeds or console.

### Reading emails in development

The application never uses external SMTP services, mail providers, or remote credentials. All emails generated in development (such as new account welcome emails and password reset links) are delivered locally to files using Action Mailer's `:file` delivery method:

- **Location of sent emails:** `tmp/mails/` (named after the recipient's email address, e.g., `tmp/mails/lucas@wheelhouse.cl`).
- **Reading an email:** Open the file in any text editor or with `cat tmp/mails/<recipient_email>`.
- **Testing password reset:** When requesting a reset at `/passwords/new`, inspect the file generated in `tmp/mails/`, copy the reset link (`http://localhost:3000/passwords/<token>/edit`), open it in your local browser, submit a new password of at least 10 characters, and sign in.
- **Mailer previews:** You can also preview email layouts in the browser at [http://localhost:3000/rails/mailers](http://localhost:3000/rails/mailers) (`PasswordsMailer` and `UserMailer`).


## Personal page and JSON API (Lab 10)

Published personal page: [Thaiel's page on GitHub Pages](https://thaielsc.github.io/webtech-lab-01/#wheelhouse).
Its source is [webtech-lab-01](https://github.com/ThaielSC/webtech-lab-01).
Run this API at **http://localhost:3000** for that page's Wheelhouse section to
load the price list. Start with `bin/dev` as above, or after building CSS use
`bin/rails server -p 3000`. The page's other sections work if the API is offline.
Your browser may request permission for the published page to access the local
network; allow it for this page if prompted.

For local page development, clone the page repository and serve it separately:

```bash
git clone https://github.com/ThaielSC/webtech-lab-01.git
cd webtech-lab-01
python3 -m http.server 5500 --bind localhost
```

Open `http://localhost:5500`. CORS allows exactly that origin and
`https://thaielsc.github.io`, only for public GET service requests.

Public price list from a terminal:

```bash
curl -i http://localhost:3000/api/v1/services
```

Private repairs, after entering the token you saved in credentials:

```bash
read -rsp 'API token: ' WHEELHOUSE_TOKEN
curl -i -H "Authorization: Bearer $WHEELHOUSE_TOKEN" \
  'http://localhost:3000/api/v1/repairs?state=completed'
unset WHEELHOUSE_TOKEN
```

Create a service with a Bearer header and a JSON body:

```bash
read -rsp 'API token: ' WHEELHOUSE_TOKEN
curl -i -X POST http://localhost:3000/api/v1/services \
  -H "Authorization: Bearer $WHEELHOUSE_TOKEN" \
  -H 'Content-Type: application/json' \
  --data '{"service":{"name":"Tune-up","description":"Adjust gears and brakes","standard_price":"35.20"}}'
unset WHEELHOUSE_TOKEN
```

See [the API contract](docs/api.md) for all routes, document shapes, errors,
price decisions and data omissions. No token is needed by the personal page.

Verify the API after preparing PostgreSQL:

```bash
RAILS_ENV=test bin/rails db:prepare
bin/rails test
bin/rubocop
bin/rails routes
```

Integration tests cover response shapes, HTML Accept headers, authentication,
strong parameters, validation/malformed-body errors, CORS, read-only GETs, and
query counts while increasing repairs and service lines. Test tokens are fixtures
in memory and are never the development/production credentials.

## Using the repair form

A new repair offers two empty service lines. Editing a repair offers its existing lines and one extra empty line. To add more services, save the repair and open Edit again. A line with no service selected is ignored. Select “Remove this service” to delete an existing line when saving the repair.

## Intake photos and diagnosis

Photos accept JPEG and PNG up to 10 MB per file. Select several files in the repair form to add them in one submission. Editing without selecting files preserves existing photos. An invalid upload rejects the whole submission with status 422; choose the files again after correcting the errors.

Open a repair to see all its larger photos, click a photo for the original file, or remove one photo with a confirmed DELETE request. Write the optional diagnosis in the rich-text editor. Action Text renders its formatting and filters unsafe HTML; list previews use plain text.

The seed creates 16 repairs: 12 have photos, the first has four, and four have none. Fourteen have a formatted diagnosis; the two newly received repairs have none. Running `bin/rails db:seed` again recreates the demonstration data with the same number of rows in every table.

Uploaded originals and generated variants live in `storage/`, which Git ignores. The source photos are committed in [db/seeds/photos](db/seeds/photos). Their authors, source URLs, and CC0 license are listed in [db/seeds/README.md](db/seeds/README.md). Seeding uses local files and requires no image downloads.

## Project documentation

- [API v1 contract](docs/api.md)
- [User stories and acceptance criteria](docs/user-stories.md)
- [Domain model and entity lifecycle](docs/domain-model.md)
- [Decisions record](docs/decisions.md)
- [Wireframes and navigation](docs/wireframes.md)
