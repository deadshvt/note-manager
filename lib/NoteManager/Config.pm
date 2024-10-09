package NoteManager::Config;

use strict;
use warnings;

use Config::Tiny;

sub load {
    my $config = Config::Tiny->read('.env');

    return {
        db_dsn           => $config->{_}->{DB_DSN},
        db_username      => $config->{_}->{DB_USERNAME},
        db_password      => $config->{_}->{DB_PASSWORD},
        cache_host       => $config->{_}->{CACHE_HOST},
        cache_port       => $config->{_}->{CACHE_PORT},
        cache_expiration => $config->{_}->{CACHE_EXPIRATION},
        server_port      => $config->{_}->{SERVER_PORT},
    };
}

1;
