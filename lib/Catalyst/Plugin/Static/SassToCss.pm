package Catalyst::Plugin::Static::SassToCss;

use Moose::Role;
use Text::Sass;
use File::Slurp;
use File::stat;

has '_sass'    => ( is => 'ro', isa => 'Text::Sass', default => sub { Text::Sass->new } );
has '_is_sass' => ( is => 'rw', );
has '_is_scss' => ( is => 'rw', );
 
before prepare_action => sub {
    my $c = shift;
    my $config = $c->config->{static};
    
    unless ($c->can('_locate_static_file')) {
        die "Needs Catalyst::Plugin::Static::Simple";
    }
    
    $c->_is_sass(0);
    $c->_is_scss(0);
    
    my $path = $c->req->path;
    
    if ($path =~ /^(.*)\.css$/) {
        my $filebase = $1;
        if (!$c->_locate_static_file($path)) {
            if ($c->_locate_static_file( $filebase . '.sass' )) {
                $c->_is_sass(1);
            }
            elsif ($c->_locate_static_file( $filebase . '.scss' )) {
                $c->_is_scss(1);
            }
        }
    }
};

around dispatch => sub {
    my $orig = shift;
    my $c = shift;
    
    return if ( $c->res->status != 200 );
    
    if ($c->_is_sass || $c->_is_scss) {
        $c->_serve_static_sass_to_css;
    }
    else {
        return $c->$orig(@_);        
    }

};

sub _serve_static_sass_to_css {
    my $c = shift;

    my $full_path = shift || $c->_static_file;
    my $type      = $c->_ext_to_type( $full_path . '.css' );
    my $stat      = stat $full_path;
    
    my $sass      = read_file($full_path);
    my $css;
    if ($c->_is_sass) {
      $css       = $c->_sass->sass2css($sass);
    }
    elsif ($c->_is_scss) {
      $css       = $c->_sass->scss2css($sass);      
    }

    $c->res->headers->content_type( $type );
    $c->res->headers->last_modified( $stat->mtime );
    $c->res->headers->content_length( length($css) );

    $c->res->body( $css );

    return 1;
}


1;
