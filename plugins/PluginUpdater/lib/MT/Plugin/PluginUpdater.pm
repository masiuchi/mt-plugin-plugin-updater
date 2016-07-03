package MT::Plugin::PluginUpdater;
use strict;
use warnings;

use MT::Plugin::PluginUpdater::Updater;

sub code {
    my $updater = MT::Plugin::PluginUpdater::Updater->new;
    $updater->update;
    if ( $updater->is_updated ) {
        $updater->write_log;
    }
    1;
}

1;

