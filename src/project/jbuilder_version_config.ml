(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

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
  Sexp.to_string_hum (to_sexp t)
