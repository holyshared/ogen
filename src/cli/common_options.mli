(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Cmdliner

type options = {
  verbose: bool
}

val gopts_t: options Term.t
val help_secs: Manpage.block list
