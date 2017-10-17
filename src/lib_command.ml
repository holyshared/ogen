(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 *)

open Arg

let name = "lib"
let description = "Generate a library file"

let lib_name = ref None

let pub_name = ref None
let output = ref None

let args_spec = [
  ("-p", String (fun s -> pub_name := Some s), "Public name of library");
  ("-o", String (fun s -> output := Some s), "Library output directory")
]

let mkdir dir =
  Unix.mkdir dir 0o755;
  dir

let output_dir_from_cwd () =
  let subdir dir = (Sys.getcwd ()) ^ "/" ^ dir in
  match !output with
    | Some o ->
      let outout_dir = (subdir o) in
      if Sys.file_exists outout_dir then
        outout_dir
      else
        mkdir outout_dir
    | None -> Sys.getcwd ()


let gen_if_lib_name_specified ~f () =
  match !lib_name with
    | Some name -> f ~name
    | None -> Error "oops!!"

let gen () =
  let output_dir = output_dir_from_cwd () in
  let config_gen = Jbuilder_library.generate ~dir:output_dir
    |> (fun gen -> gen ?pub_name:!pub_name)
    |> (fun gen -> gen ()) in
  print_endline ("output directory: " ^ output_dir);
  gen_if_lib_name_specified ~f:config_gen ()

(* ogen lib -p foo -o foo foo *)
let run ~gopts =
  parse args_spec (fun s -> lib_name := Some s) "ogen [GLOBAL_OPTIONS] lib [OPTIONS] [LIB_NAME]\n";
  match gen () with
    | Ok _ -> print_endline "ok"
    | Error e ->
      begin
        print_endline e;
        exit 1
      end
