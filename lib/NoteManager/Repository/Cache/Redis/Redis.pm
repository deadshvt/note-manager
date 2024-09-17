package NoteManager::Repository::Cache::Redis::Redis;

use strict;
use warnings;

use Moo;
with 'NoteManager::Repository::Cache::Cache';

use Redis;
use Log::Log4perl;

has 'host' => (is => 'ro', required => 1);
has 'port' => (is => 'ro', required => 1);
has 'expiration' => (is => 'ro', required => 1);

has 'redis' => (
    is => 'lazy',
    builder => sub {
        my $self = shift;
        my $redis;

        eval{
            $redis = Redis->new(
                server => $self->host . ':' . $self->port,
                reconnect => 60,
                every => 5000,
            );
        };

        if ($@) {
            error("Redis connection failed: $@");
            return { error => "Failed to connect to redis: $@" };
        }

        return $redis;
    }
);

Log::Log4perl->init('log4perl.conf');
my $logger = Log::Log4perl->get_logger();

sub info {
    my ($message) = @_;
    $logger->info("[COMPONENT=redis] $message");
}

sub get {
    my ($self, $key) = @_;

    info("Getting note with key=\'" . $key . "\'");

    return $self->redis->get($key);
}

sub set {
    my ($self, $key, $value) = @_;

    info("Setting note with key=\'" . $key . "\'");

    $self->redis->set($key, $value);
    $self->redis->expire($key, $self->expiration);
}

sub delete {
    my ($self, $key) = @_;

    info("Deleting note with key=\'" . $key . "\'");

    $self->redis->del($key);
}

1;
