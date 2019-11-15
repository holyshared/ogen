(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Cmdliner

module Command = struct
  module type S = sig
    val term: unit Term.t * Term.info
  end
end

module Common_options = struct
  type options = {
    verbose: bool
  }

  let gopts verbose = { verbose; }

  let gopts_t =
    let docs = Manpage.s_common_options in
    let verbose =
      let doc = "Output detailed logs at runtime." in
      Arg.(value & flag & info ["v"; "verbose"] ~docs ~doc)
    in
    Term.(const gopts $ verbose)

  let help_secs = [
    `S Manpage.s_common_options;
    `P "These options are common to all commands.";
    `S Manpage.s_bugs; `P "Check bug reports at https://github.com/holyshared/ogen/issues.";
  ]

end


module Default = struct
  let name = "ogen"
  let version = "0.3.1"
  let doc = "Code generator for OCaml"

  let term =
    let sdocs = Manpage.s_common_options in
    let exits = Term.default_exits in
    Term.(ret (const (fun _ -> `Help (`Pager, None)) $ Common_options.gopts_t)),
    Term.info name ~version ~doc ~sdocs ~exits
end


module Library = struct
  open Filesystem
  open Project

  let generate_library _gopts pub_name output_dir lib_name =
    let dest_dir = Directory.from_cwd ?output:output_dir () in
  

    match Dune_library.generate ~dir:dest_dir ?pub_name ~name:lib_name () with
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
end



module Module = struct
  open Filesystem
  open Project

  let generate_module _gopts output_dir mod_name =
    let dest_dir = Directory.from_cwd ?output:output_dir () in
    match Module_file.generate ~dir:dest_dir ~content:"" ~name:mod_name () with
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

end


module Opam = struct
  open Filesystem
  open Project

  let generate_opam_file _gopts output_dir pkg_name =
    let dest_dir = Directory.from_cwd ?output:output_dir () in
    match Opam_file.generate ~dir:dest_dir ~name:pkg_name () with
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
end

