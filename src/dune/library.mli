(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Sexplib

type t

val create: ?pub_name:string ->
  ?libs:string list ->
  name:string ->
  unit -> t

val name: t -> string
val public_name: t -> string option
val libraries: t -> string list option
val to_sexp: t -> Sexp.t
val to_string: t -> string
