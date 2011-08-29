package TestApp;

use strict;
use warnings;

use Catalyst qw/
    Static::Simple
    Static::SassToCss
/;
use Path::Class;

our $VERSION = '0.01';

__PACKAGE__->config(
    name                  => 'TestApp',
);

__PACKAGE__->setup;


