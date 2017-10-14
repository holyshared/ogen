(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 *)

module Version = Jbuilder_version_config
module Library = Jbuilder_library_config

let build_content ?pub_name ?(libs=[]) ~name =
  let version = Version.create () in
  let library_conf = Library.create ?pub_name ~name ~libs in
  let buf = Buffer.create 1024 in
  Buffer.(
    add_string buf (Version.to_string version);
    add_string buf (Library.to_string library_conf);
    contents buf
  )

let generate ?(dir=Sys.getcwd ()) ?pub_name ?(libs=[]) ~name () =
  let create_jb_config_file = File.puts ~path:(dir ^ "/" ^ "jbuild") in
  let build_config = build_content ?pub_name ~name ~libs in
  match create_jb_config_file build_config with
    | Ok file -> Ok ()
    | Error e -> Error (File.string_of_error e)
