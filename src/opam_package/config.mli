module Repo: sig
  type t
  val create: ?homepage:string -> ?bug_report:string -> string -> t
end

type t

val create: ?maintainer:string -> ?author:string  -> ?license:string -> ?repo:Repo.t -> string -> t

val save: ?dir:string -> t -> (unit, string) result
