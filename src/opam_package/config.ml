open Ogen_filesystem

module Repo = struct
  type t = {
    url: string option;
    homepage: string option;
    bug_report: string option;
  }

  let create ?homepage ?bug_report url =
    {
      url = Some url;
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
  let add_string_prop name value o =
    match value with
      | Some v -> (name, (`String v))::o
      | None -> o in

  let add_repo_prop repo o =
    let open Repo in
    match repo with
      | Some v ->
          begin
            o |>
            add_string_prop "homepage" v.homepage |>
            add_string_prop "bug_report" v.bug_report |>
            add_string_prop "dev_repo" v.url
          end
      | None -> o in

  let fields = [ ("name", `String t.name) ] |>
    add_string_prop "maintainer" t.maintainer |>
    add_string_prop "author" t.author |>
    add_string_prop "license" t.license |>
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
