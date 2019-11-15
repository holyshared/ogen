(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Cmdliner

module Command: sig
  module type S = sig
    val term: unit Term.t * Term.info
  end
end

module Common_options: sig
  type options = {
    verbose: bool
  }

  val gopts_t: options Term.t
  val help_secs: Manpage.block list
end

module Default: sig
  include Command.S
end

module Library: sig
  include Command.S
end

module Module: sig
  include Command.S
end

module Opam: sig
  include Command.S
end
