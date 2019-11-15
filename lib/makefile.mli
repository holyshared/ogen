(**
 * Copyright 2019 Noritaka Horio <holy.shared.design@gmail.com>
 *
 * This source file is subject to the MIT license that is bundled
 * with this source code in the file LICENSE.
 *)

module Template: sig
  val copy_to: string -> (unit, string) result
end
