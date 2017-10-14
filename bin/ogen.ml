open Arg
open Ogen_project

(* Name of library *)
let name = ref ""

(* Public name of library *)
let pub_name = ref ""

(* Library output directory *)
let output = ref ""

let args_spec = [
  ("-p", Set_string pub_name, "Public name of library");
  ("-o", Set_string output, "Library output directory")
]

let lib_name s = name := s

let mkdir dir =
  Unix.mkdir dir 0o755;
  dir

let output_dir_from_cwd () =
  let subdir dir = (Sys.getcwd ()) ^ "/" ^ dir in
  if (String.length !output) > 0 then
    let outout_dir = (subdir !output) in
    if Sys.file_exists outout_dir then
      outout_dir
    else
      mkdir outout_dir
  else
    Sys.getcwd ()

let run () =
  let output_dir = output_dir_from_cwd () in
  print_endline ("output directory: " ^ output_dir);
  match Jbuilder_library.generate ~dir:output_dir ~name:!name () with
    | Ok _ -> print_endline "ok"
    | Error e -> print_endline e

let () =
  parse args_spec lib_name "ogen [OPTIONS] [NAME]";
  run ()
