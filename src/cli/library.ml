(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Cmdliner
open Ogen_project.Project
open Ogen_filesystem

let generate_library _gopts pub_name output_dir lib_name =
  let dest_dir = Directory.from_cwd ?output:output_dir () in
  let config_gen = Dune_library.generate ~dir:dest_dir
                   |> (fun gen -> gen ?pub_name)
                   |> (fun gen -> gen ()) in
  match config_gen ~name:lib_name with
    | Ok _ -> `Ok ()
    | Error e -> `Error (false, e)

let term =
  let pub_name =
    let doc = "public name of library" in
    Arg.(value & opt (some string) None & info ["p"] ~docv:"PUBLIC_NAME" ~doc) in
  let output_dir =
    let doc = "library output directory" in
    Arg.(value & opt (some string) None & info ["o"] ~docv:"OUTPUT_DIR" ~doc) in
  let lib_name =
    let doc = "name of library to build" in
    Arg.(value & pos 0 string "" & info [] ~docv:"LIBRARY_NAME" ~doc) in

  let doc = "generate a library file" in
  let exits = Term.default_exits in
  let man = [
    `S Manpage.s_description;
    `P "Create a dune configuration file for library package";
    `Blocks Common_options.help_secs;
  ] in
  let action = Term.(ret Term.(const generate_library $ Common_options.gopts_t $ pub_name $ output_dir $ lib_name)) in
  let action_info = Term.info "lib" ~doc ~sdocs:Manpage.s_common_options ~exits ~man in
  action, action_info
