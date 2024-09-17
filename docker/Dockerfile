FROM perl:latest

RUN cpanm --notest Moo Log::Log4perl DBI DBD::Pg Config::Tiny Mojolicious aliased Redis JSON

RUN mkdir -p /usr/src/app/logs

WORKDIR /usr/src/app

COPY . /usr/src/app

CMD ["hypnotoad", "-f", "cmd/NoteManager/Main.pl"]
