(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

let mkdir dir =
  Unix.mkdir dir 0o755;
  dir

let from_cwd ?output () =
  let subdir dir = (Sys.getcwd ()) ^ "/" ^ dir in
  match output with
    | Some o ->
      let outout_dir = (subdir o) in
      if Sys.file_exists outout_dir then
        outout_dir
      else
      mkdir outout_dir
    | None -> Sys.getcwd ()
