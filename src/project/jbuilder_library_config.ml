(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Sexplib

type t = {
  name: string;
  public_name: string option;
  libraries: string list
}

let create ?pub_name ?(libs=[]) ~name =
  {
    name = name;
    public_name = pub_name;
    libraries = libs
  }

let name t = t.name
let public_name t = t.public_name
let libraries t = t.libraries

let to_sexp t =
  let define_of_field name = Sexp.Atom name in
  let string_of_field name v = Sexp.List [ Sexp.Atom name; Sexp.Atom v] in
  let string_list_of_field name v =
    Sexp.List [ Sexp.Atom name; Sexp.List (ListLabels.map (fun v -> define_of_field v) v)] in
  let option_string_of_field name v ov = match v with
    | Some v -> Sexp.List [ Sexp.Atom name; Sexp.Atom v]
    | None -> Sexp.List [ Sexp.Atom name; Sexp.Atom ov] in
  let add_field ~field out = field::out in
  let fields v =
    let list_sexp_of v = Sexp.List (List.rev v) in
    v
    |> add_field ~field:(option_string_of_field "public_name" t.public_name t.name)
    |> add_field ~field:(string_of_field "name" t.name)
    |> add_field ~field:(string_list_of_field "libraries" t.libraries)
    |> list_sexp_of in
  let pack v =
    v
    |> add_field ~field:(define_of_field "library")
    |> fun v -> (fields [])::v in
  Sexp.List (List.rev (pack []))

let to_string t =
  Sexp.to_string (to_sexp t)

let save t ~dir = ()
