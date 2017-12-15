(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Ogen_filesystem

let content_of = function
  | Some v -> v
  | None -> ""

let create_files ?content ~dir ~name =
  let file_path = dir ^ "/" ^ name in
  let files = [
    ((file_path ^ ".ml"), content);
    ((file_path ^ ".mli"), None)
  ] in
  let create files =
    let rec create_all files =
      match files with
        | [] -> Ok ()
        | hd::tail ->
          let path, content = hd in
          match File.create ~path ?content with
            | Ok _ -> create_all tail
            | Error e -> Error e in
    create_all files in
  create files

let generate ?(dir=Sys.getcwd ()) ?content ~name () =
  match create_files ~dir ~name ?content with
    | Ok file -> Ok ()
    | Error e -> Error (File.string_of_error e)
