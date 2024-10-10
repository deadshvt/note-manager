package NoteManager::Repository::Cache::Redis;

use strict;
use warnings;

use Moo;
with 'NoteManager::Repository::Cache';

use Redis;

use Logger;

my $log = Logger::get_logger('redis');

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
            $log->('error', "Redis connection failed: $@");

            return { error => "Failed to connect to redis: $@" };
        }

        return $redis;
    }
);

sub get {
    my ($self, $key) = @_;

    $log->('info', "Getting note with key=\'" . $key . "\'");

    return $self->redis->get($key);
}

sub set {
    my ($self, $key, $value) = @_;

    $log->('info', "Setting note with key=\'" . $key . "\'");

    $self->redis->set($key, $value);
    $self->redis->expire($key, $self->expiration);
}

sub delete {
    my ($self, $key) = @_;

    $log->('info', "Deleting note with key=\'" . $key . "\'");

    $self->redis->del($key);
}

1;
