FROM holyshared/ocaml:latest
ENV DEBIAN_FRONTEND noninteractive
LABEL maintainer "Noritaka Horio <holy.shared.design@gmail.com>"
RUN sudo -u develop sh -c 'opam install -y dune sexplib sexp_pretty cmdliner ppx_jane ppxlib mustache'
WORKDIR project
COPY ogen.opam ogen.opam
COPY bin bin
COPY lib lib
COPY test test
COPY Makefile Makefile
COPY .travis .travis
RUN sudo chown -R develop:develop ogen.opam bin lib test Makefile .travis
