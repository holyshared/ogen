FROM holyshared/ocaml:latest
ENV DEBIAN_FRONTEND noninteractive
MAINTAINER Noritaka Horio <holy.shared.design@gmail.com>
RUN sudo -u develop sh -c 'opam install -y jbuilder sexplib ounit'
WORKDIR project
COPY ogen.opam ogen.opam
COPY bin bin
COPY src src
COPY tests tests
COPY Makefile Makefile
COPY .travis .travis
RUN sudo chown -R develop:develop ogen.opam bin src tests Makefile .travis
