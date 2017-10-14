open Sexplib

type t = {
  version: int
}

let create ?(version=1) () =
  { version = version }

let to_sexp t =
  Sexp.List [
    Sexp.Atom "jbuild_version";
    Sexp.Atom (string_of_int t.version)
  ]

let to_string t =
  Sexp.to_string (to_sexp t)
