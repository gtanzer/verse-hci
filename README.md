# verse

A synthesizer for synthesizers built on top of the PROSE framework. TODO: expand on this more.

## Usage

Run `verse.sh` on a corpus file (see below for an example). A PROSE configuration will be generated and you will be dropped into an interactive shell with the resulting synthesizer.

e.g. `verse.sh corpus.txt`

## Example

Provide the following `corpus.txt`:

```
@input string x
@output string

append(x, x)
```

## Misc.

Tested using ocaml 4.08.1. No opam libraries required.

Tested using dotnet-core 3.0.1. Additional dotnet libraries are required and should be autoinstalled (check the resulting Verse.csproj file in `output/`).
