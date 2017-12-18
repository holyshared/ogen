(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

open Sexplib
open Conv

let is_none v =
  v = None

type t = {
  name: string;
  public_name: string sexp_option;
  libraries: string list sexp_option;
} [@@deriving sexp]

type config_format = (string * t) [@@deriving sexp]

let create ?pub_name ?libs ~name () =
  {
    name = name;
    public_name = pub_name;
    libraries = libs
  }

let name t = t.name
let public_name t = t.public_name
let libraries t = t.libraries

let to_sexp = sexp_of_t
let of_sexp = t_of_sexp
let to_string t =
  let open Sexp_pretty in
  Pretty_print.sexp_to_string (sexp_of_config_format ("library", t))

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
    let expected = "(library (\n  (name        test)\n  (public_name test)))\n" in
    let acutual = to_string (name_by "test") in
    [%test_eq: string] acutual expected
end)
