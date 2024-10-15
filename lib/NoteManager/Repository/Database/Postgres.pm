package NoteManager::Repository::Database::Postgres;

use strict;
use warnings;

use Moo;
with 'NoteManager::Repository::Database';

use DBI;

use Logger;

use aliased 'NoteManager::Constants' => 'Constants';
use aliased 'NoteManager::Entity::Note' => 'Note';

my $log = Logger::get_logger('postgres');

has 'dsn'      => (is => 'ro', required => 1);
has 'username' => (is => 'ro', required => 1);
has 'password' => (is => 'ro', required => 1);

has 'dbh' => (
    is => 'lazy',
    builder => sub {
        my $self = shift;
        my $dbh;

        eval {
            $dbh = DBI->connect($self->dsn, $self->username, $self->password, {
                RaiseError => 1,
                AutoCommit => 1,
            });
        };

        if ($@) {
            $log->('error', "Database connection failed: $@");

            return { error => "Failed to connect to database: $@" };
        }

        return $dbh;
    }
);

sub get_note_by_id {
    my ($self, $id) = @_;

    $log->('info', "Getting note with ID=\'" . $id . "\'");

    my $sth;
    eval {
        $sth = $self->dbh->prepare('SELECT id, text, created_at, updated_at FROM note WHERE id = ?');
        $sth->execute($id);
    };

    if ($@) {
        return { error => $@ };
    }

    my $row = $sth->fetchrow_hashref;
    if (!$row) {
        return { error => $Constants::ERROR_NOTE_NOT_FOUND };
    }

    return Note->new($row);
}

sub create_note {
    my ($self, $data) = @_;

    $log->('info', "Creating note with text=\'" . $data->{text} . "\'");

    my $sth;
    eval {
        $sth = $self->dbh->prepare('INSERT INTO note (text, created_at, updated_at) VALUES (?, NOW(), NOW()) RETURNING id, text, created_at, updated_at');
        $sth->execute($data->{text});
    };

    if ($@) {
        return { error => $@ };
    }

    return Note->new($sth->fetchrow_hashref);
}

sub update_note {
    my ($self, $id, $data) = @_;

    $log->('info', "Updating note with ID=\'" . $id . "\'");

    my $result;
    my $sth;
    eval {
        $sth = $self->dbh->prepare('UPDATE note SET text = ?, updated_at = NOW() WHERE id = ? RETURNING id, text, created_at, updated_at');
        $sth->execute($data->{text}, $id);

        if ($sth->rows == 0) {
            $result = { error => $Constants::ERROR_NOTE_NOT_FOUND };
        }
    };

    if ($@) {
        return { error => $@ };
    }

    return defined $result ? $result : Note->new($sth->fetchrow_hashref);
}

sub delete_note {
    my ($self, $id) = @_;

    $log->('info', "Deleting note with ID=\'" . $id . "\'");

    my $result;
    eval {
        my $sth = $self->dbh->prepare('DELETE FROM note WHERE id = ?');
        $sth->execute($id);

        if ($sth->rows == 0) {
            $result = { error => $Constants::ERROR_NOTE_NOT_FOUND };
        }
    };

    if ($@) {
        return { error => $@ };
    }

    return $result;
}

sub get_notes {
    my ($self, $order_by) = @_;

    $log->('info', "Getting notes by order_by=\'" . $order_by . "\'");

    my $sth;
    eval {
        $sth = $self->dbh->prepare("SELECT id, text, created_at, updated_at FROM note ORDER BY $order_by");
        $sth->execute();
    };

    if ($@) {
        return { error => $@ };
    }

    my @notes;
    while (my $row = $sth->fetchrow_hashref) {
        push @notes, Note->new($row);
    }

    return \@notes;
}

1;
