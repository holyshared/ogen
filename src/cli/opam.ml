(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Cmdliner
open Ogen_project.Project
open Ogen_filesystem

let generate_opam_file _gopts output_dir pkg_name =
  let dest_dir = Directory.from_cwd ?output:output_dir () in
  let opam_file_gen = Opam_file.generate ~dir:dest_dir
    |> (fun gf -> gf ()) in

  match opam_file_gen ~name:pkg_name with
    | Ok _ -> `Ok ()
    | Error e -> `Error (false, e)

let term =
  let output_dir =
    let doc = "opam file output directory" in
    Arg.(value & opt (some string) None & info ["o"] ~docv:"OUTPUT_DIR" ~doc) in

  let pkg_name =
    let doc = "name of package" in
    Arg.(value & pos 0 string "" & info [] ~docv:"PACKAGE_NAME" ~doc) in

  let doc = "generate a opam file" in
  let exits = Term.default_exits in
  let man = [
    `S Manpage.s_description;
    `P "Create an opam file with the specified name.";
    `Blocks Common_options.help_secs;
  ] in
  let action = Term.(ret Term.(const generate_opam_file $ Common_options.gopts_t $ output_dir $ pkg_name)) in
  let action_info = Term.info "opam" ~doc ~sdocs:Manpage.s_common_options ~exits ~man in
  action, action_info
