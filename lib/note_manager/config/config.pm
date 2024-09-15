package note_manager::config::config;

use strict;
use warnings;

use Config::Tiny;

sub load {
    my $config = Config::Tiny->read('.env');

    return {
        dsn      => $config->{_}->{DB_DSN},
        username => $config->{_}->{DB_USERNAME},
        password => $config->{_}->{DB_PASSWORD},
        port     => $config->{_}->{SERVER_PORT},
    };
}

1;
