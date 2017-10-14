type t

val create: ?pub_name:string
  -> ?libs:string list
  -> name:string
  -> t
val name: t -> string
val public_name: t -> string option
val libraries: t -> string list
val to_sexp: t -> Sexplib.Sexp.t
val to_string: t -> string
