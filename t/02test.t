use strict;
use warnings;
use Test::More tests => 3;

use FindBin;
use lib "$FindBin::Bin/lib";

use_ok('Catalyst::Test', 'TestApp');

my $response;
ok(($response = request("/static/ex1.css"))->is_success, 'request ok');
is($response->content, ".content-navigation {\n  border-color: #3bbfce;\n  color: #2ba1af;\n}\n\n.border {\n  padding: 8px;\n  margin: 8px;\n  border-color: #3bbfce;\n}\n",'message ok');