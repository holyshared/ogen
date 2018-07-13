(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Sexplib

type t

val create: ?vnum:int -> unit -> t
val to_sexp: t -> Sexp.t
val of_sexp: Sexp.t -> t
val to_string: t -> string
