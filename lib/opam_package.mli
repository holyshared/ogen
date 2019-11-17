(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 *)

module Config: sig
  type t

  module Repo: sig
    type t
    val create: ?homepage:string -> ?bug_report:string -> ?url:string -> unit -> t
  end

  val create: ?maintainer:string -> ?author:string  -> ?license:string -> ?repo:Repo.t -> string -> t
  val save: ?dir:string -> t -> (unit, string) result
end
