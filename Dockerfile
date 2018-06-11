FROM holyshared/ocaml:latest
ENV DEBIAN_FRONTEND noninteractive
LABEL maintainer "Noritaka Horio <holy.shared.design@gmail.com>"
RUN sudo -u develop sh -c 'opam install -y jbuilder sexplib sexp_pretty cmdliner ppx_jane ppxlib'
WORKDIR project
COPY ogen.opam ogen.opam
COPY bin bin
COPY src src
COPY test test
COPY Makefile Makefile
COPY .travis .travis
RUN sudo chown -R develop:develop ogen.opam bin src test Makefile .travis
