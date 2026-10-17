# Portfolio demo deployment

The university deployment targets a legacy PHP/MySQL environment at `/ilcan21/`.
The separate demo configuration preserves that URL prefix and original setup,
but packages the React frontend and PHP API together on PHP 8.3/Apache, backed
by MariaDB 11.4. It requires a Docker Compose host; the PHP API cannot run as a
standard static Vercel frontend deployment.

## Run on a Docker host

1. Copy `.env.demo.example` to `.env.demo`; set two different random database passwords.
2. Run `docker compose --env-file .env.demo -f compose.demo.yaml up -d --build`.
3. Open `http://localhost:8080/ilcan21/`.
4. For a public URL, configure a TLS reverse proxy on the host to forward to `127.0.0.1:8080`.

Demo accounts: `admin@bitirme.local`, `instructor@bitirme.local`,
`student@bitirme.local`; sample password: `Bitirme123!`.
These are public demonstration accounts, not production credentials.

The demo defaults to read-only browsing with login/logout enabled. Mutations
and file uploads return HTTP 403, even after signing in as an administrator.
The frontend displays a demo notice. Only repository example seeds are loaded;
existing `.env` files and uploaded documents are not copied into the image.
Material tables start empty because seed document files are not provided.
Do not import real university accounts, grades or attendance into this instance.

Database initialization runs only on a new empty `demo_db` volume. To reset an
existing demo, back it up if needed, then remove **only its demo volume** and
start again. No destructive reset command is included here.

## Validation and remaining checks

Frontend TypeScript/production build was checked locally. Docker/PHP/MySQL
runtime validation must be completed on a Docker host before publication:

- Login and logout with all three example roles.
- Course, announcement, grade and attendance reads.
- HTTP 403 for writes, `/api/config`, `/api/src`, and database diagnostic endpoints.
- Deep-link refresh at `/ilcan21/tr/courses`.
- HTTPS proxy configuration and a clean database initialization.

## Reports

`main.tex` documents MAT 4901 (frontend modernization); `main2.tex` documents
MAT 4902 (backend integration). Compile with `latexmk -pdf main.tex` and
`latexmk -pdf main2.tex`. The LaTeX edits only improve compilation and layout;
the documents retain their original period-specific claims.
