open Cmdliner
open Ogen_project.Cli

let commands = [ Library.term; Module.term; Opam.term ]

let () =
  Term.(exit @@ eval_choice Default.term commands)
