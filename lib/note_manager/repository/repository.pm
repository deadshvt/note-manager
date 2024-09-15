package note_manager::repository::repository;

use strict;
use warnings;

use Moo;

has 'db' => (is => 'ro', required => 1);

Log::Log4perl->init('log4perl.conf');
my $logger = Log::Log4perl->get_logger();

sub info {
    my ($message) = @_;
    $logger->info("[COMPONENT=repository] $message");
}

sub get_note_by_id {
    my ($self, $id) = @_;

    info("Getting note with id=\'" . $id . "\'");

    return $self->db->get_note_by_id($id);
}

sub create_note {
    my ($self, $data) = @_;

    info("Creating note with text=\'" . $data->{text} . "\'");

    return $self->db->create_note($data);
}

sub update_note {
    my ($self, $id, $data) = @_;

    info("Updating note with id=\'" . $id . "\'");

    return $self->db->update_note($id, $data);
}

sub delete_note {
    my ($self, $id) = @_;

    info("Deleting note with id=\'" . $id . "\'");

    return $self->db->delete_note($id);
}

sub get_notes {
    my ($self, $order_by) = @_;

    info("Getting notes with order_by=\'" . $order_by . "\'");

    return $self->db->get_notes($order_by);
}

1;
