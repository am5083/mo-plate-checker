# MO Plate Checker

MO Plate Checker is a learning project built with Elm, with an OCaml backend
planned. It is not affiliated with the Missouri Department of Revenue and cannot
determine whether a plate is available or whether an application will be
approved.

## Current status

The Elm code currently includes:

- A basic interface for entering a seed plate
- Plate normalization and validation
- Candidate variation generation
- Automated tests for the plate and variation logic

Displaying generated variations in the interface and building the OCaml backend
are still in progress. The application does not currently query the Missouri DOR.

## Background

I came across Elm in a job listing and got curious, so I decided to build this
project as a learning exercise. I had already written an OCaml version of the
tool, and the similarities between the two languages made Elm a natural choice
for a port.

This repository is a complete rewrite of that first attempt.

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
