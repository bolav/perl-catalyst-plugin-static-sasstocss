use inc::Module::Install;

name 'Catalyst-Plugin-Static-SassToCss';
all_from 'lib/Catalyst/Plugin/Static/SassToCss.pm';

requires 'Catalyst'        => '5.7';
requires 'Text::Sass'      => 0;
requires 'Catalyst::Plugin::Static::Simple'     => 0;

test_requires 'Test::More';

auto_install;
resources repository => 'http://github.com/bolav/perl-catalyst-plugin-static-sasstocss';

WriteAll;
