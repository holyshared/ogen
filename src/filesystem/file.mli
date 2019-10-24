(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

type t

module File_error: sig
  type t
  val create_failed: string -> t
  val already_closed: string -> t
  val to_string: t -> string
end

val path: t -> string
val open_write: string -> (t, File_error.t) result
val write_string: s:string -> t -> (t, File_error.t) result
val write_buffer: buf:Buffer.t -> t -> (t, File_error.t) result
val close: t -> (t, File_error.t) result
val create:
  ?content:string ->
  path:string ->
  (t, File_error.t) result
val is_closed: t -> bool
