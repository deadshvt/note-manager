package NoteManager::Repository;

use strict;
use warnings;

use Moo;
use JSON;

use Log::Log4perl;

use aliased 'NoteManager::Entity::Note' => 'Note';

has 'db' => (is => 'ro', required => 1);
has 'cache' => (is => 'ro', required => 1);

Log::Log4perl->init('log4perl.conf');
my $logger = Log::Log4perl->get_logger();

sub info {
    my ($message) = @_;
    $logger->info("[COMPONENT=repository] $message");
}

sub error {
    my ($message) = @_;
    $logger->error("[COMPONENT=repository] $message");
}

sub get_note_by_id {
    my ($self, $id) = @_;

    info("Getting note with id=\'" . $id . "\'");

    if (my $cached_note = $self->cache->get("note_$id")) {
        my $note;
        eval {
            $note = decode_json($cached_note);
        };

        unless ($@) {
            info("Got note with id=\'" . $id . "\' from cache");
            return Note->new($note);
        }

        error("Failed to decode cached note: $@");
    }

    my $result = $self->db->get_note_by_id($id);
    unless (exists $result->{error}) {
        $self->cache->set("note_$id", encode_json($result->to_hash));
    }

    return $result;
}

sub create_note {
    my ($self, $data) = @_;

    info("Creating note with text=\'" . $data->{text} . "\'");

    my $result = $self->db->create_note($data);
    unless (exists $result->{error}) {
        $self->cache->set("note_" . $result->{id}, encode_json($result->to_hash));
    }

    return $result;
}

sub update_note {
    my ($self, $id, $data) = @_;

    info("Updating note with id=\'" . $id . "\'");

    my $result = $self->db->update_note($id, $data);
    unless (exists $result->{error}) {
        $self->cache->set("note_$id", encode_json($result->to_hash));
    }

    return $result;
}

sub delete_note {
    my ($self, $id) = @_;

    info("Deleting note with id=\'" . $id . "\'");

    my $result = $self->db->delete_note($id);
    unless (exists $result->{error}) {
        $self->cache->delete("note_$id");
    }

    return $result;
}

sub get_notes {
    my ($self, $order_by) = @_;

    info("Getting notes with order_by=\'" . $order_by . "\'");

    return $self->db->get_notes($order_by);
}

1;
