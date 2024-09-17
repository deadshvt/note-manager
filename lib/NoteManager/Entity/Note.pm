package NoteManager::Entity::Note;

use strict;
use warnings;

use Moo;

has 'id' => (is => 'ro', required => 1);
has 'text' => (is => 'ro', required => 1);
has 'created_at' => (is => 'ro', required => 1);
has 'updated_at' => (is => 'ro', required => 1);

sub to_hash {
    my $self = shift;
    return {
        id         => $self->id,
        text       => $self->text,
        created_at => $self->created_at,
        updated_at => $self->updated_at,
    };
}

1;
