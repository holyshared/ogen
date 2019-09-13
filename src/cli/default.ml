(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Cmdliner

let name = "ogen"
let version = "0.3.1"
let doc = "Code generator for OCaml"

let term =
  let sdocs = Manpage.s_common_options in
  let exits = Term.default_exits in
  Term.(ret (const (fun _ -> `Help (`Pager, None)) $ Common_options.gopts_t)),
  Term.info name ~version ~doc ~sdocs ~exits
