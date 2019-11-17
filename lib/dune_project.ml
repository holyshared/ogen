(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

module Library = struct
  module Name = struct
    type t = string
    let name = "name"
    let of_string t = t
    let to_sexp t =
      let open Sexplib.Sexp in
      List [Atom name; Atom t]
  end

  module Public_name = struct
    type t = string option
    let name = "public_name"
    let of_string_opt t = t
    let to_sexp t =
      let open Sexplib.Sexp in
      match t with
        | Some v -> Some (List [Atom name; Atom v])
        | None -> None
  end

  module Dependency_libraries = struct
    type t = string list option

    let name = "libraries"

    let of_strings_opt t = t

    let to_sexp t =
      let open Sexplib.Sexp in
      let sexp_of_name = Atom name in
      let sexp_of_list libs =
        ListLabels.map ~f:(fun lib_name -> Atom lib_name) libs
          |> ListLabels.rev in
      match t with
        | Some v -> Some (List (sexp_of_name::(sexp_of_list v)))
        | None -> None
  end

  type t = {
    name: Name.t;
    public_name: Public_name.t;
    libraries: Dependency_libraries.t;
  }

  let create ?pub_name ?libs ~name () =
    {
      name = Name.of_string name;
      public_name = Public_name.of_string_opt pub_name;
      libraries = Dependency_libraries.of_strings_opt libs
    }

  let name t = t.name
  let public_name t = t.public_name
  let libraries t = t.libraries

  let to_sexp t =
    let open Sexplib.Sexp in
    let add_library l = (Atom "library")::l in
    let add_name l = (Name.to_sexp t.name)::l in
    let add_pub_name_if_not_empty l =
      match Public_name.to_sexp t.public_name with
        | Some v -> v::l
        | None -> l in
    let add_desp_libraries l =
      match Dependency_libraries.to_sexp t.libraries with
        | Some v -> v::l
        | None -> l in
    []
      |> add_desp_libraries
      |> add_pub_name_if_not_empty
      |> add_name
      |> add_library
      |> List

  let to_string t =
    let open Sexp_pretty in
    sexp_to_string (to_sexp t)

  let%test_module _ = (module struct
    open Base

    let%test_unit "configuration of library" =
      let name_by s = create ~name:s ~pub_name:s in
      let lib_conf = name_by "test" () in
      [%test_eq: string] (name lib_conf) "test";
      [%test_eq: string option] (public_name lib_conf) (Some "test");
      [%test_eq: string list option] (libraries lib_conf) None

    let%test_unit "configuration to string" =
      let name_by s = create ~name:s ~pub_name:s () in
      let expected = "(library\n  (name        test)\n  (public_name test))\n" in
      let acutual = to_string (name_by "test") in
      [%test_eq: string] acutual expected

  end)
end

module Config = struct
  open Filesystem

  type config =
    Library of Library.t

  type t = config list

  let create () = []

  let add_library ?pub_name ?libs ~name t =
    let library = Library.create ?pub_name ?libs ~name () in
    (Library library)::t

  let to_string t =
    let s = ListLabels.map ~f:(fun c ->
      match c with
        | Library v -> Library.to_string v
    ) t in
    let buf = Buffer.create 1024 in
    ListLabels.iter ~f:(fun cs -> Buffer.add_string buf cs) s;
    Buffer.contents buf

  let save ?(dir=Sys.getcwd ()) t =
    let create_dune_config_file = File.create ~path:(dir ^ "/" ^ "dune") in
    match create_dune_config_file ~content:(to_string t) with
      | Ok _ -> Ok ()
      | Error e -> Error (File.File_error.to_string e)

end
