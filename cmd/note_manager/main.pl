use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../lib";

use Mojolicious::Lite;

use Log::Log4perl;

use note_manager::config::config;
use note_manager::repository::repository;
use note_manager::repository::database::postgres::postgres;
use note_manager::delivery::http::handler;

Log::Log4perl->init('log4perl.conf');
my $logger = Log::Log4perl->get_logger();

sub info {
    my ($message) = @_;
    $logger->info("[COMPONENT=main] $message");
}

info("Loading config...");

my $config = note_manager::config::config::load();

info("Loaded config");

info("Connecting to database...");

my $db = note_manager::repository::database::postgres::postgres->new(
    dsn => $config->{dsn},
    username => $config->{username},
    password => $config->{password},
);

info("Connected to database");

my $repository = note_manager::repository::repository->new(
    db => $db
);

my $handler = note_manager::delivery::http::handler->new(
    repository => $repository
);

$handler->register(app);

app->config(hypnotoad => { listen => ["http://*:$config->{port}"] });

info("Starting server...");

app->start();
