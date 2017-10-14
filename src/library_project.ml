module type S = sig
  val generate: ?dir:string
    -> ?pub_name:string
    -> ?libs:string list
    -> name:string
    -> unit
    -> (unit, string) result
end
