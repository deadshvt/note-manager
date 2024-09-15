package note_manager::repository::database::database;

use strict;
use warnings;

use Moo::Role;

requires 'get_note_by_id';
requires 'create_note';
requires 'update_note';
requires 'delete_note';
requires 'get_notes';

1;
