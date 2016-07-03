package MT::Plugin::PluginUpdater::Updater;
use strict;
use warnings;

use IO::Dir;

use MT;
use MT::Plugin::PluginUpdater::Directory;

sub new {
    my $class = shift;
    bless +{}, $class;
}

sub log {
    my $self = shift;
    $self->{log} ||= [];
    if (@_) {
        push @{ $self->{log} }, join( "\n", @_ );
    }
    else {
        join "\n", @{ $self->{log} };
    }
}

sub update {
    my $self = shift;
    for my $path ( MT->config->PluginPath ) {
        my $dir = MT::Plugin::PluginUpdater::Directory->new($path);
        while ( defined( $_ = $dir->child_dir ) ) {
            $self->_update_plugin($_);
        }
    }
}

sub _update_plugin {
    my ( $self, $dir ) = @_;
    my $command = "pushd $dir; git pull --rebase; popd";
    my @logs    = `$command`;
    $self->log(@logs);
}

sub is_updated {
    my $self = shift;
    $self->log =~ /Current branch master is up to date/im ? 0 : 1;
}

sub write_log {
    my $self = shift;
    MT->log(
        {   message  => 'Updated plugins',
            category => 'plugin_updater',
            metadata => $self->log,
        }
    );
}

1;

