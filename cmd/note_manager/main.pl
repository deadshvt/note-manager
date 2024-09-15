use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../lib";

use Mojolicious::Lite;

use Log::Log4perl;

use aliased 'note_manager::config::config' => 'Config';
use aliased 'note_manager::repository::repository' => 'Repository';
use aliased 'note_manager::repository::database::postgres::postgres' => 'Database';
use aliased 'note_manager::delivery::http::handler' => 'Handler';

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
    dsn => $config->{dsn},
    username => $config->{username},
    password => $config->{password},
);

info("Connected to database");

my $repository = Repository->new(
    db => $db
);

my $handler = Handler->new(
    repository => $repository
);

$handler->register(app);

app->config(hypnotoad => { listen => ["http://*:$config->{port}"] });

info("Starting server...");

app->start();
