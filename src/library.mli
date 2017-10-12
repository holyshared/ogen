type t

val create: ?public_name:string
  -> ?libraries:string list
  -> name:string
  -> t
val name: t -> string
val public_name: t -> string option
val libraries: t -> string list
