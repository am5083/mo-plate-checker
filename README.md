# MO Plate Checker

MO Plate Checker is a learning project built with Elm, with an OCaml backend
in progress. It is not affiliated with the Missouri Department of Revenue and cannot
determine whether a plate is available or whether an application will be
approved.

## Reference

https://github.com/mo-plate-web
https://github.com/mo-custom-plate-finder

## Current status

The Elm code currently includes:

- A basic interface for entering a seed plate
- Plate normalization and validation
- Candidate variation generation
- Automated tests for the plate and variation logic
- UI displays variations
- Checks a fake API endpoint using the fixed `AHMED` query


The OCaml backend is still in progress. The application does not currently query the Missouri DOR.

## OPAM requirements

Install the required packages:

```sh
opam install dune cohttp-eio eio_main alcotest
```

## Server

Build and test the server:

```sh
cd server
opam exec -- dune build
opam exec -- dune runtest
```

Run it on port 8080:

```sh
cd server
PORT=8080 opam exec -- dune exec bin/main.exe
```

The server provides a `GET /api/health` endpoint and returns structured JSON
errors for unknown paths and unsupported methods.

## Implemented API contract

```http
GET /api/health
-> 200  Content-Type: application/json
   {"status":"ok"}

GET /missing
-> 404  Content-Type: application/json
   {"error":"not_found"}

POST /api/health
-> 405  Content-Type: application/json
        Allow: GET
   {"error":"method_not_allowed"}
```

## Planned availability API contract

```http
GET /api/check?plate=AHMED
-> 200  {"plate":"AHMED","available":true}
-> 200  {"plate":"AHMED","available":false}
-> 400  {"error":"invalid_plate"}
-> 429  {"error":"rate_limited"}
-> 502  {"error":"upstream_failure"}
```

`/api/check` is not yet implemented.

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
