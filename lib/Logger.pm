package Logger;

use strict;
use warnings;

use Log::Log4perl;

Log::Log4perl->init_once('config/log4perl.conf');

sub get_logger {
    my ($component) = @_;
    my $logger = Log::Log4perl->get_logger($component);

    return sub {
        my ($level, $message) = @_;
        $logger->$level("[COMPONENT=$component] $message");
    };
}

1;
