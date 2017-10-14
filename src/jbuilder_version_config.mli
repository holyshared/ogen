(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 *)

type t
val create: ?version:int -> unit -> t
val to_sexp: t -> Sexplib.Sexp.t
val to_string: t -> string
