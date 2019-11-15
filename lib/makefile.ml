(**
 * Copyright 2019 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 *)

open Filesystem

module Template = struct
  let make_file_template () =
    let prefix = match Sys.getenv_opt "OPAM_SWITCH_PREFIX" with
      | Some v -> v
      | None -> "" in
    let input = (open_in (prefix ^ "/share/ogen/default.mk")) in
    let template = really_input_string input (in_channel_length input) in
    close_in input;
    template

  let copy_to path =
    match File.create ~content:(make_file_template ()) ~path with
      | Ok _ -> Ok ()
      | Error e -> Error (File.File_error.to_string e)
end
