type t

type file_error =
  | CreateFailed of string
  | AlreadyClosed of string

val path: t -> string
val create: string -> (t, file_error) result
val write_string: s:string -> t -> (t, file_error) result
val write_buffer: buf:Buffer.t -> t -> (t, file_error) result
val close: t -> (t, file_error) result
val puts: s:string
  -> string
  -> (t, file_error) result
val string_of_error: file_error -> string
val is_closed: t -> bool
