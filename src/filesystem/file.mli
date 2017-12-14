(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

type t

type file_error =
  | CreateFailed of string
  | AlreadyClosed of string

val path: t -> string
val open_write: string -> (t, file_error) result
val write_string: s:string -> t -> (t, file_error) result
val write_buffer: buf:Buffer.t -> t -> (t, file_error) result
val close: t -> (t, file_error) result
val create:
  ?content:string ->
  path:string ->
  (t, file_error) result
val string_of_error: file_error -> string
val is_closed: t -> bool
