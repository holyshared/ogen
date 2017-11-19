
(**
 * Copyright 2017 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
*)

type t

val generate: ?dir:string ->
  ?pub_name:string  ->
  ?libs:string list ->
  name:string  ->
  unit -> (unit, string) result
