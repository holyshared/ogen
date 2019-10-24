(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Ogen_opam_package

let generate ?(dir=Sys.getcwd ()) ~name () =
  Config.(
    create name |> save ~dir
  )
