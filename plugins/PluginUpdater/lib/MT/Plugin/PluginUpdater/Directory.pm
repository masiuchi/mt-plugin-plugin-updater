package MT::Plugin::PluginUpdater::Directory;
use strict;
use warnings;

use File::Spec;
use IO::Dir;

sub new {
    my ( $class, $base_dir ) = @_;
    my $self = bless +{}, $class;
    $self->_base_dir($base_dir);
    $self;
}

sub _base_dir {
    my $self = shift;
    if (@_) {
        $self->{_base_dir} = shift;
    }
    else {
        $self->{_base_dir};
    }
}

sub _io_dir {
    my $self = shift;
    $self->{_io_dir} ||= IO::Dir->new( $self->_base_dir );
}

sub child_dir {
    my $self = shift;
    my $path;
    do {
        $path = $self->_read_path;
        return unless defined $path;
    } until ( $self->_is_dir($path) );
    $self->_full_path($path);
}

sub _read_path {
    my $self = shift;
    $self->_io_dir->read;
}

sub _is_dir {
    my ( $self, $path ) = @_;
    return if $path eq '.' || $path eq '..';
    -d $self->_full_path($path);
}

sub _full_path {
    my ( $self, $path ) = @_;
    my $full_path = File::Spec->catdir( $self->_base_dir, $path );
    File::Spec->rel2abs($full_path);
}

1;

