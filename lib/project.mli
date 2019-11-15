(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 *)

module Library_project: sig
  module type S = sig
    val generate: ?dir:string
      -> ?pub_name:string
      -> ?libs:string list
      -> name:string
      -> unit
      -> (unit, string) result
  end
end

module Dune_library: sig
  include Library_project.S
end

module Module_file: sig
  val generate: ?dir:string
    -> ?content:string
    -> name:string
    -> unit
    -> (unit, string) result
end

module Opam_file: sig
  val generate: ?dir:string
    -> name:string
    -> unit
    -> (unit, string) result
end

module Makefile: sig
  val generate: ?dir:string -> ?name:string -> unit -> (unit, string) result
end
