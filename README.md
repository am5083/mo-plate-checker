# MO Plate Checker

MO Plate Checker is a learning project built with Elm, with an OCaml backend
in progress. It is not affiliated with the Missouri Department of Revenue and cannot
determine whether a plate is available or whether an application will be
approved.

## Current status

The Elm code currently includes:

- A basic interface for entering a seed plate
- Plate normalization and validation
- Candidate variation generation
- Automated tests for the plate and variation logic
- UI displays variations
- Checks a fake API endpoint using the fixed `AHMED` query

The OCaml backend currently exists in the `server/` directory. The library, and executable logic
are both in `server/lib` and `server/bin`, respectively.

The backend tests exist in `server/test`

The OCaml backend is still in progress. The application does not currently query the Missouri DOR.

## Server demo

``` sh
cd server
opam exec -- dune build
opam exec -- dune exec bin/main.exe
opam exec -- dune runtest
```

## Fake API Contract
```http
GET /api/health
200 { "status": "ok" }
```

```http
GET /api/check?plate=AHMED
-> 200  { "plate": "AHMED", "available": true } 
-> 200  { "plate": "AHMED", "available": false } 
-> 400  { "error": "invalid_plate" }
-> 429  { "error": "rate_limited" }
-> 502  { "error": "upstream_failure" }
```

## Background

Elm rewrite of an existing OCaml project.

## Running locally

You will need Elm 0.19.1 and `elm-test` installed.

Compile the Elm application:

```sh
elm make src/Main.elm --output=public/app.js
```

Serve the `public` directory:

```sh
python3 -m http.server 8000 --directory public
```

Then open <http://localhost:8000>.

## Tests

Run the Elm test suite with:

```sh
elm-test
```

## License

This project is available under the MIT License. See [LICENSE](LICENSE) for
details.
