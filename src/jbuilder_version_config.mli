type t
val create: ?version:int -> unit -> t
val to_sexp: t -> Sexplib.Sexp.t
val to_string: t -> string
