(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 *)

module Library_project = struct
  module type S = sig
    val generate: ?dir:string
      -> ?pub_name:string
      -> ?libs:string list
      -> name:string
      -> unit
      -> (unit, string) result
  end
end

module Dune_library = struct
  open Dune_project

  let generate ?(dir=Sys.getcwd ()) ?pub_name ?libs ~name () =
    let lib_pub_name = Option.value pub_name ~default:name in
    Config.(
      create ()
        |> add_library ~pub_name:lib_pub_name ?libs ~name
        |> save ~dir
    )
end

module Module_file = struct
  open Filesystem

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
      | Ok _ -> Ok ()
      | Error e -> Error (File.File_error.to_string e)
end

module Opam_file = struct
  open Opam_package

  let generate ?(dir=Sys.getcwd ()) ~name () =
    Config.(
      create name |> save ~dir
    )
end

module Makefile = struct
  open Makefile

  let generate ?(dir=Sys.getcwd ()) ?(name="Makefile") () =
    Template.(
      copy_to (dir ^ "/" ^ name)
    )
end
