(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Sexplib
open Conv

let is_none v =
  v = None

type t = {
  name: string;
  public_name: string option [@default None] [@sexp_drop_if is_none];
  libraries: string list option [@default None] [@sexp_drop_if is_none];
} [@@deriving sexp]

type config_format = (string * t) [@@deriving sexp]

let create ?pub_name ?libs ~name =
  {
    name = name;
    public_name = pub_name;
    libraries = libs
  }

let name t = t.name
let public_name t = t.public_name
let libraries t = t.libraries

let to_sexp = sexp_of_t
let of_sexp = t_of_sexp
let to_string t =
  let open Sexp_pretty in
  Pretty_print.sexp_to_string (sexp_of_config_format ("library", t))
