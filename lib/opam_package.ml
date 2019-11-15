(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 *)

open Ogen_filesystem

module Config = struct
  module Repo = struct
    type t = {
      url: string option;
      homepage: string option;
      bug_report: string option;
    }

    let create ?homepage ?bug_report ?url () =
      {
        url = url;
        homepage = homepage;
        bug_report = bug_report
      }
  end

  type t = {
    name: string;
    maintainer: string option;
    author: string option;
    license: string option;
    repo: Repo.t option;
  }

  let create ?maintainer ?author ?license ?repo name =
    {
      name = name;
      maintainer = maintainer;
      author = author;
      license = license;
      repo = repo;
    }

  let to_json t =
    let some v = v in

    let get ?(defaultv="") value = 
      Option.fold ~none:defaultv ~some:some value in

    let add_string_prop name value o =
      (name, (`String value))::o in

    let add_repo_prop repo o =
      let get_or_default repo =
        Option.fold ~none:(Repo.create ()) ~some:some repo in
      let add_repo v o =
        let open Repo in
        o |>
          add_string_prop "homepage" (get v.homepage) |>
          add_string_prop "bug_report" (get v.bug_report) |>
          add_string_prop "dev_repo" (get v.url) in
      add_repo (get_or_default repo) o in

    let fields = [ ("name", `String t.name) ] |>
      add_string_prop "maintainer" (get t.maintainer) |>
      add_string_prop "author" (get t.author) |>
      add_string_prop "license" (get t.license) |>
      add_repo_prop t.repo in

    `O fields

  let mustache_template =
    let prefix = match Sys.getenv_opt "OPAM_SWITCH_PREFIX" with
      | Some v -> v
      | None -> "" in
    let input = (open_in (prefix ^ "/share/ogen/opam.mustache")) in
    let template = really_input_string input (in_channel_length input) in
    close_in input;
    Mustache.of_string template

  let render_template = Mustache.render mustache_template

  let output_file ?dir name =
    let opam_file = name ^ ".opam" in
    match dir with
      | Some v -> v ^ "/" ^ opam_file
      | None -> opam_file

  let save ?(dir=Sys.getcwd ()) t =
    let content = render_template (to_json t) in
    match File.create ~content:content ~path:(output_file ~dir t.name) with
      | Ok _ -> Ok ()
      | Error e -> Error (File.File_error.to_string e)
end
