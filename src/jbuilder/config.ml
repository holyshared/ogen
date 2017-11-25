(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Ogen_filesystem

type config =
  | Version of Version.t
  | Library of Library.t

type t = config list

let create () =
  let version = Version.create () in
  (Version version)::[]

let add_library ?pub_name ?libs ~name t =
  let library = Library.create ?pub_name ?libs ~name () in
  (Library library)::t

let to_string t =
  let s = ListLabels.map ~f:(fun c ->
    match c with
      | Version v -> Version.to_string v
      | Library v -> Library.to_string v
  ) t in
  let buf = Buffer.create 1024 in
  ListLabels.iter ~f:(fun cs -> Buffer.add_string buf cs) s;
  Buffer.contents buf

let save ?(dir=Sys.getcwd ()) t =
  let create_jb_config_file = File.puts ~path:(dir ^ "/" ^ "jbuild") in
  match create_jb_config_file (to_string t) with
    | Ok file -> Ok ()
    | Error e -> Error (File.string_of_error e)
