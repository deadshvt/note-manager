package NoteManager::Delivery::HTTP::Handler;

use strict;
use warnings;

use Moo;

use Logger;

has 'repository' => (is => 'ro', required => 1);

my $log = Logger::get_logger('handler');

sub register {
    my ($self, $app) = @_;

    $app->routes->get('/note/:id' => sub {
        my $c = shift;
        my $id = $c->param('id');

        $log->('info', "Getting note with id=\'" . $id . "\'");

        my $result = $self->repository->get_note_by_id($id);
        if (exists $result->{error}) {
            $log->('error', "Failed to get note with id=\'" . $id . "\': " . $result->{error});

            return $c->render(json => { error => $result->{error} }, status => 500);
        }

        $log->('info', "Got note with id=\'" . $id . "\'");
        $c->render(json => $result->to_hash, status => 200);
    });

    $app->routes->post('/note' => sub {
        my $c = shift;
        my $data = $c->req->json;

        $log->('info', "Creating note with text=\'" . $data->{text} . "\'");

        my $result = $self->repository->create_note($data);
        if (exists $result->{error}) {
            $log->('error', "Failed to create note: " . $result->{error});

            return $c->render(json => { error => $result->{error} }, status => 500);
        }

        $log->('info', "Created note with id=\'" . $result->{id} . "\'");
        $c->render(json => $result->to_hash, status => 201);
    });

    $app->routes->put('/note/:id' => sub {
        my $c = shift;
        my $id = $c->param('id');
        my $data = $c->req->json;

        $log->('info', "Updating note with id=\'" . $id . "\'");

        my $result = $self->repository->update_note($id, $data);
        if (exists $result->{error}) {
            $log->('error', "Failed to update note: " . $result->{error});

            return $c->render(json => { error => $result->{error} }, status => 500);
        }

        $log->('info', "Updated note with id=\'" . $id . "\'");
        $c->render(json => $result->to_hash, status => 200);
    });

    $app->routes->delete('/note/:id' => sub {
        my $c = shift;
        my $id = $c->param('id');

        $log->('info', "Deleting note with id=\'" . $id . "\'");

        my $result = $self->repository->delete_note($id);
        if (ref $result eq 'HASH' && exists $result->{error}) {
            $log->('error', "Failed to delete note with id=\'" . $id . "\': " . $result->{error});

            return $c->render(json => { error => $result->{error} }, status => 404);
        }

        $log->('info', "Deleted note with id=\'" . $id . "\'");
        return $c->rendered(204);
    });

    $app->routes->get('/note' => sub {
        my $c = shift;
        my $order_by = $c->param('order_by') || 'id';
        if ($order_by ne 'id' && $order_by ne 'created_at' && $order_by ne 'updated_at') {
            $log->('error', "Invalid order_by=\'" . $order_by . "\'");

            return $c->render(json => { error => "Invalid order_by" }, status => 400);
        }

        $log->('info', "Getting notes by order_by=\'" . $order_by . "\'");

        my $result = $self->repository->get_notes($order_by);
        if (ref $result eq 'HASH' && exists $result->{error}) {
            $log->('error', "Failed to get notes: " . $result->{error});

            return $c->render(json => { error => $result->{error} }, status => 500);
        }

        my @notes = map { $_->to_hash } @$result;

        $log->('info', "Got notes by order_by=\'" . $order_by . "\'");
        $c->render(json => \@notes, status => 200);
    });
}

1;
