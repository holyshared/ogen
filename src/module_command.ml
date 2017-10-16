(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 *)

open Arg

let name = "mod"
let description = "mod"

let mod_name = ref None

let output = ref None

let args_spec = [
  ("-d", String (fun s -> output := Some s), "Module output directory")
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

let gen_if_mod_name_specified ~f () =
  match !mod_name with
    | Some name -> f ~name
    | None -> Error "oops!!"

let gen () =
  let output_dir = output_dir_from_cwd () in
  let mod_gen = Module_file.generate ~dir:output_dir
    |> (fun gf -> gf ~content:"")
    |> (fun gf -> gf ()) in
  gen_if_mod_name_specified ~f:mod_gen ()

(* ogen mod -d foo foo *)
let run ~gopts =
  parse args_spec (fun s -> mod_name := Some s) "ogen [GLOBAL_OPTIONS] mod [OPTIONS] [MODULE_NAME]\n";
  match gen () with
    | Ok _ -> print_endline "ok"
    | Error e ->
      begin
        print_endline e;
        exit 1
      end
