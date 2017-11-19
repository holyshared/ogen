(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Cmdliner
open Ogen_project
open Ogen_filesystem

let generate_module gopts output_dir mod_name =
  let dest_dir = Directory.from_cwd ?output:output_dir () in
  let mod_gen = Module_file.generate ~dir:dest_dir
                |> (fun gf -> gf ~content:"")
                |> (fun gf -> gf ()) in
  match mod_gen ~name:mod_name with
    | Ok _ -> `Ok ()
    | Error e -> `Error (false, e)

let term =
  let output_dir =
    let doc = "module output directory" in
    Arg.(value & opt (some string) None & info ["o"] ~docv:"OUTPUT_DIR" ~doc) in
  let mod_name =
    let doc = "name of module to include in library" in
    Arg.(value & pos 0 string "" & info [] ~docv:"MODULE_NAME" ~doc) in
  let doc = "generate a module file" in
  let exits = Term.default_exits in
  let man = [
    `S Manpage.s_description;
    `P "Create a module to include in the library with the specified name.";
    `Blocks Common_options.help_secs;
  ] in
  let action = Term.(ret Term.(const generate_module $ Common_options.gopts_t $ output_dir $ mod_name)) in
  let action_info = Term.info "mod" ~doc ~sdocs:Manpage.s_common_options ~exits ~man in
  action, action_info
