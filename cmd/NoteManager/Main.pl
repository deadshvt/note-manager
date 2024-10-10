use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../lib";

use Mojolicious::Lite;

use Logger;

use aliased 'NoteManager::Config' => 'Config';
use aliased 'NoteManager::Delivery::HTTP::Handler' => 'Handler';
use aliased 'NoteManager::Repository::Cache::Redis' => 'Cache';
use aliased 'NoteManager::Repository::Database::Postgres' => 'Database';
use aliased 'NoteManager::Repository' => 'Repository';

my $log = Logger::get_logger('main');

$log->('info', 'Loading config...');

my $config = Config->load();

$log->('info', 'Loaded config');

$log->('info', 'Connecting to database...');

my $db = Database->new(
    dsn => $config->{db_dsn},
    username => $config->{db_username},
    password => $config->{db_password},
);

$log->('info', 'Connected to database');

$log->('info', 'Connecting to cache...');

my $cache = Cache->new(
    host => $config->{cache_host},
    port => $config->{cache_port},
    expiration => $config->{cache_expiration},
);

$log->('info', 'Connected to cache');

my $repository = Repository->new(
    db => $db,
    cache => $cache
);

my $handler = Handler->new(
    repository => $repository
);

$handler->register(app);

app->config(hypnotoad => { listen => ["http://*:$config->{server_port}"] });

$log->('info', 'Starting server...');

app->start();
