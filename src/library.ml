open Sexplib

type t = {
  name: string;
  public_name: string option;
  libraries: string list
}

let create ?public_name ?(libraries=[]) ~name =
  {
    name = name;
    public_name = public_name;
    libraries = libraries
  }

let name t = t.name
let public_name t = t.public_name
let libraries t = t.libraries

let to_sexp t =
  let define_of_field name = Sexp.Atom name in
  let string_of_field name v = Sexp.List [ Sexp.Atom name; Sexp.Atom v] in
  let option_string_of_field name v ov = match v with
    | Some v -> Sexp.List [ Sexp.Atom name; Sexp.Atom v]
    | None -> Sexp.List [ Sexp.Atom name; Sexp.Atom ov] in
  let add_field ~field out = field::out in
  let pack v =
    v
    |> add_field ~field:(define_of_field "library")
    |> add_field ~field:(option_string_of_field "public_name" t.public_name t.name)
    |> add_field ~field:(string_of_field "name" t.name) in
  Sexp.List (pack [])

let save t ~dir = ()
