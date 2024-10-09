use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../lib";

use Mojolicious::Lite;

use Log::Log4perl;

use aliased 'NoteManager::Config' => 'Config';
use aliased 'NoteManager::Delivery::HTTP::Handler' => 'Handler';
use aliased 'NoteManager::Repository::Cache::Redis' => 'Cache';
use aliased 'NoteManager::Repository::Database::Postgres' => 'Database';
use aliased 'NoteManager::Repository' => 'Repository';

Log::Log4perl->init('log4perl.conf');
my $logger = Log::Log4perl->get_logger();

sub info {
    my ($message) = @_;
    $logger->info("[COMPONENT=main] $message");
}

info("Loading config...");

my $config = Config->load();

info("Loaded config");

info("Connecting to database...");

my $db = Database->new(
    dsn => $config->{db_dsn},
    username => $config->{db_username},
    password => $config->{db_password},
);

info("Connected to database");

info("Connecting to cache...");

my $cache = Cache->new(
    host => $config->{cache_host},
    port => $config->{cache_port},
    expiration => $config->{cache_expiration},
);

info("Connected to cache");

my $repository = Repository->new(
    db => $db,
    cache => $cache
);

my $handler = Handler->new(
    repository => $repository
);

$handler->register(app);

app->config(hypnotoad => { listen => ["http://*:$config->{server_port}"] });

info("Starting server...");

app->start();
