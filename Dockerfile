FROM trenpixster/elixir:latest
MAINTAINER RickR <rickr@akamai.com>

RUN apt-get update && apt-get install -qy nodejs postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN echo %sudo    ALL=NOPASSWD: ALL>>/etc/sudoers

RUN useradd -m -G sudo app

RUN mkdir /phoenixapp
WORKDIR /phoenixapp

COPY ./mix.exs /phoenixapp/mix.exs
COPY ./mix.lock /phoenixapp/mix.lock

RUN yes | mix deps.get

COPY ./ /phoenixapp

ENV PORT 8080
ENV MIX_ENV prod

RUN mix deps.compile

EXPOSE 8080

ENTRYPOINT /phoenixapp/scripts/start-server.sh
