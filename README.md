# ogen

[![Build Status](https://travis-ci.com/holyshared/ogen.svg?branch=master)](https://travis-ci.com/holyshared/ogen)

ogen is a generator of OCaml source of build configuration file.    
The configuration file will generate [dune](https://github.com/ocaml/dune) configuration file.


## Basic usage

### Generate opam configuration

Create an opam project file, execute the following command.

```shell
ogen opam my_package
```

By default, an opam file and Makefile are generated.

```shell
ls -a
my_package.opam
Makefile
```


### Generate library configuration

You can use the lib command to generate a build configuration file for the library.  
In the example below, we create a dune file named **package_xyz** in **lib/xyz**.

```shell
ogen lib package_xyz -p package.xyz -o lib/xyz
```

#### Contents of output dune

```sexp
(library
  (name        package_xyz)
  (public_name package.xyz)
)
```

### Generate module file

You can generate modules using the mod command.  
The following example creates a module file named **example** in **lib/xyz**.  

```shell
ogen mod -o lib/xyz example
```

## Install

You can install using opam.  
The compiler version of OCaml must be **4.09.0** or higher.

```shell
opam switch create 4.09.0
opam pin add ogen https://github.com/holyshared/ogen.git
```

## Build

Install and build the required dependent libraries.  

```shell
opam install -y dune sexplib sexp_pretty cmdliner ppx_jane ppxlib mustache
make build
```

## Run the test

The test only executes the test command.

```shell
opam install -y dune sexplib sexp_pretty cmdliner ppx_jane ppxlib mustache
make test
```
