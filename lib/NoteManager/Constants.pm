package NoteManager::Constants;

use strict;
use warnings;

use Exporter 'import';

our @EXPORT_OK = qw(
    ERROR_MISSING_ID
    ERROR_INVALID_ID
    ERROR_INVALID_ORDER_BY
    ERROR_NOTE_NOT_FOUND
    ERROR_NOTE_ALREADY_EXISTS
);

use constant {
    ERROR_MISSING_ID => 'Missing ID',
    ERROR_INVALID_ID => 'Invalid ID',
    ERROR_INVALID_ORDER_BY => 'Invalid order_by',
    ERROR_NOTE_NOT_FOUND => 'Note not found',
    ERROR_NOTE_ALREADY_EXISTS => 'Note already exists',
};

1;
