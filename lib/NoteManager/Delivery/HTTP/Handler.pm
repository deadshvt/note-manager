package NoteManager::Delivery::HTTP::Handler;

use strict;
use warnings;

use Moo;
use HTTP::Status qw(:constants);

use Logger;

use aliased 'NoteManager::Constants' => 'Constants';

has 'repository' => (is => 'ro', required => 1);

my $log = Logger::get_logger('handler');

my @order_by = (
    'id',
    'created_at',
    'updated_at'
);

sub register {
    my ($self, $app) = @_;

    $app->routes->get('/note/:id' => sub {
        my $c = shift;
        my $id = $c->param('id');

        $log->('info', "Getting note with ID=\'" . $id . "\'");

        unless (defined $id) {
            $log->('error', "Missing ID");

            return $c->render(json => { error => $Constants::ERROR_MISSING_ID }, status => HTTP_BAD_REQUEST);
        }

        unless ($id =~ /^\d+$/) {
            $log->('error', "Invalid ID=\'" . $id . "\'");

            return $c->render(json => { error => $Constants::ERROR_INVALID_ID }, status => HTTP_BAD_REQUEST);
        }

        my $result = $self->repository->get_note_by_id($id);
        my $error = $result->{error} if (ref $result eq 'HASH');
        if (defined $error) {
            $log->('error', "Failed to get note with ID=\'" . $id . "\': " . $error);
            my $status = $error eq $Constants::ERROR_NOTE_NOT_FOUND ? HTTP_NOT_FOUND : HTTP_INTERNAL_SERVER_ERROR;

            return $c->render(json => { error => $error }, status => $status);
        }

        $log->('info', "Got note with ID=\'" . $id . "\'");
        $c->render(json => $result->to_hash, status => HTTP_OK);
    });

    $app->routes->post('/note' => sub {
        my $c = shift;
        my $data = $c->req->json;

        $log->('info', "Creating note with text=\'" . $data->{text} . "\'");

        my $result = $self->repository->create_note($data);
        my $error = $result->{error} if (ref $result eq 'HASH');
        if (defined $error) {
            $log->('error', "Failed to create note: " . $error);

            return $c->render(json => { error => $error }, status => HTTP_INTERNAL_SERVER_ERROR);
        }

        $log->('info', "Created note with ID=\'" . $result->{id} . "\'");
        $c->render(json => $result->to_hash, status => HTTP_CREATED);
    });

    $app->routes->put('/note/:id' => sub {
        my $c = shift;
        my $id = $c->param('id');
        my $data = $c->req->json;

        $log->('info', "Updating note with ID=\'" . $id . "\'");

        unless (defined $id) {
            $log->('error', "Missing ID");

            return $c->render(json => { error => $Constants::ERROR_MISSING_ID }, status => HTTP_BAD_REQUEST);
        }

        unless ($id =~ /^\d+$/) {
            $log->('error', "Invalid ID=\'" . $id . "\'");

            return $c->render(json => { error => $Constants::ERROR_INVALID_ID }, status => HTTP_BAD_REQUEST);
        }

        my $result = $self->repository->update_note($id, $data);
        my $error = $result->{error} if (ref $result eq 'HASH');
        if (defined $error) {
            $log->('error', "Failed to update note: " . $error);
            my $status = $error eq $Constants::ERROR_NOTE_NOT_FOUND ? HTTP_NOT_FOUND : HTTP_INTERNAL_SERVER_ERROR;

            return $c->render(json => { error => $error }, status => $status);
        }

        $log->('info', "Updated note with ID=\'" . $id . "\'");
        $c->render(json => $result->to_hash, status => HTTP_OK);
    });

    $app->routes->delete('/note/:id' => sub {
        my $c = shift;
        my $id = $c->param('id');

        $log->('info', "Deleting note with ID=\'" . $id . "\'");

        unless (defined $id) {
            $log->('error', "Missing ID");

            return $c->render(json => { error => $Constants::ERROR_MISSING_ID }, status => HTTP_BAD_REQUEST);
        }

        unless ($id =~ /^\d+$/) {
            $log->('error', "Invalid ID=\'" . $id . "\'");

            return $c->render(json => { error => $Constants::ERROR_INVALID_ID }, status => HTTP_BAD_REQUEST);
        }

        my $result = $self->repository->delete_note($id);
        my $error = $result->{error} if (ref $result eq 'HASH');
        if (defined $error) {
            $log->('error', "Failed to delete note with id=\'" . $id . "\': " . $error);
            my $status = $error eq $Constants::ERROR_NOTE_NOT_FOUND ? HTTP_NOT_FOUND : HTTP_INTERNAL_SERVER_ERROR;

            return $c->render(json => { error => $error }, status => $status);
        }

        $log->('info', "Deleted note with ID=\'" . $id . "\'");
        return $c->rendered(HTTP_NO_CONTENT);
    });

    $app->routes->get('/note' => sub {
        my $c = shift;
        my $order_by = $c->param('order_by') || 'id';

        $log->('info', "Getting notes by order_by=\'" . $order_by . "\'");

        unless (check_order_by($order_by)) {
            $log->('error', "Invalid order_by=\'" . $order_by . "\'");

            return $c->render(json => { error => $Constants::ERROR_INVALID_ORDER_BY }, status => HTTP_BAD_REQUEST);
        }

        my $result = $self->repository->get_notes($order_by);
        my $error = $result->{error} if (ref $result eq 'HASH');
        if (defined $error) {
            $log->('error', "Failed to get notes: " . $error);

            return $c->render(json => { error => $error }, status => HTTP_INTERNAL_SERVER_ERROR);
        }

        my @notes = map { $_->to_hash } @$result;

        $log->('info', "Got notes by order_by=\'" . $order_by . "\'");
        $c->render(json => \@notes, status => HTTP_OK);
    });
}

sub check_order_by {
    my ($order_by) = @_;

    if (grep { $order_by eq $_ } @order_by) {
        return 1;
    }

    return 0;
}

1;
