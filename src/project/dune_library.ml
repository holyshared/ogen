(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Ogen_dune

let generate ?(dir=Sys.getcwd ()) ?pub_name ?libs ~name () =
  Config.(
    create ()
      |> add_library ?pub_name ?libs ~name
      |> save ~dir
  )
