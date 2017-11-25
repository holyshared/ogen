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

let gopts verbose = { verbose; }

let gopts_t =
  let docs = Manpage.s_common_options in
  let verbose =
    let doc = "Output detailed logs at runtime." in
    Arg.(value & flag & info ["v"; "verbose"] ~docs ~doc)
  in
  Term.(const gopts $ verbose)

let help_secs = [
  `S Manpage.s_common_options;
  `P "These options are common to all commands.";
  `S Manpage.s_bugs; `P "Check bug reports at https://github.com/holyshared/ogen/issues.";
]
