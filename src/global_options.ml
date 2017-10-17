open Arg

type t = {
  verbose: bool
}

let verbose = ref false

let spec = [
  ("-v", Set verbose, "verbose")
]

let get () =
  {
    verbose = !verbose
  }

let usage_string () =
  usage_string spec "GLOBAL_OPTIONS\n"
