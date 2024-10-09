package NoteManager::Repository::Cache;

use strict;
use warnings;

use Moo::Role;

requires 'get';
requires 'set';
requires 'delete';

1;
