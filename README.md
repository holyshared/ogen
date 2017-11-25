# ogen

[![Build Status](https://travis-ci.org/holyshared/ogen.svg?branch=master)](https://travis-ci.org/holyshared/ogen)

ogen is a generator of OCaml source of build configuration file.    
The configuration file will generate [jbuilder](https://github.com/janestreet/jbuilder) configuration file.


## Basic usage

### Generate library configuration

You can use the lib command to generate a build configuration file for the library.  
In the example below, we create a jbuild file named **package_xyz** in **src/xyz**.

```shell
ogen lib package_xyz -p package.xyz -o src/xyz
```

#### Contents of output jbuild

```sexp
(library (
  (name        package_xyz)
  (public_name package.xyz)))
(jbuild_version 1)
```

### Generate module file

You can generate modules using the mod command.  
The following example creates a module file named **example** in **src/xyz**.  

```shell
ogen mod -o src/xyz example
```

## Install

You can install using opam.  
The compiler version of OCaml must be **4.06.0** or higher.

```shell
opam switch 4.06.0
opam pin add ogen https://github.com/holyshared/ogen.git
```

## Build

Install and build the required dependent libraries.  

```shell
opam install -y jbuilder sexplib sexp_pretty ounit
make build
```

## Run the test

The test only executes the test command.

```shell
opam install -y jbuilder sexplib sexp_pretty ounit
make test
```
