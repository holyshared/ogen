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

type t = int [@@deriving sexp]

type config_format = (string * t) [@@deriving sexp]

let create ?(vnum=1) () =
  vnum

let to_sexp = sexp_of_t
let of_sexp = t_of_sexp

let to_string t =
  let open Sexp_pretty in
  Pretty_print.sexp_to_string (sexp_of_config_format ("jbuild_version", t))
