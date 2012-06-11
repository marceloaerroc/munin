# -*- cperl -*-
# vim: ts=4 : sw=4 : et
use warnings;
use strict;

use Test::More tests => 5;

use_ok('Munin::Master::Config');

use Munin::Master::Config;
use Munin::Common::Defaults;

my $config = Munin::Master::Config->instance();
my $userconfig = $config->{config};

$userconfig->parse_config(\*DATA);

# Build the correct answer by hand.
my $fasit = {
    'root_instance' => 1,

    oldconfig => {
    	config_file => "$Munin::Common::Defaults::MUNIN_DBDIR/datafile"
    },

    config => {
        config_file     => "$Munin::Common::Defaults::MUNIN_CONFDIR/munin.conf",
        dbdir           => '/opt/munin/sandbox/var/opt/munin',
        debug           => 0,
        fork            => 1,
        graph_data_size => 'normal',
        groups          => {
            marvin => {
                hosts => {
                    marvin => {
                        use_node_name       => 1,
                        address             => '127.0.0.1',
                        port                => '4948',
                        'load1.graph_title' => 'Loads side by side',
                        'load1.graph_order' => 'fii=fii.foo.com:load.load fay=fay.foo.com:load.load',
                        host_name           => 'marvin',
                        update              => 1,
                    },
                },
                group      => undef,
                group_name => 'marvin',
            },
        },
        htmldir                => '/opt/munin/sandbox/www',
        local_address          => 0,
        logdir                 => '/opt/munin/sandbox/var/log/munin',
        max_processes          => 16, 
        rundir                 => '/opt/munin/sandbox/var/run/munin',
        timeout                => 180,
        tls                    => 'disabled',
        tls_ca_certificate     => '/opt/munin/common/t/tls/CA/ca_cert.pem',
        tls_certificate        => '/opt/munin/common/t/tls/master_cert.pem',
        tls_private_key        => '/opt/munin/common/t/tls/master_key.pem',
        tls_verify_certificate => 1,
        tls_verify_depth       => '5',
        tmpldir                => '/opt/munin/sandbox/etc/opt/munin/templates',
    },
};

$fasit->{config}{groups}{marvin}{hosts}{marvin}{group}
    = $fasit->{config}{groups}{marvin};

is_deeply($config, $fasit, 'Config hash contents');


### _final_char_is
ok(  Munin::Master::Config::_final_char_is('h', 'blah'), 'it was the last character');
ok(! Munin::Master::Config::_final_char_is('a', 'blah'), 'it was not the last character');
ok(! Munin::Master::Config::_final_char_is('z', 'blah'), 'it not in the string at all');


__DATA__

# Example configuration file for Munin, generated by 'make build'

# The next three variables specifies where the location of the RRD
# databases, the HTML output, and the logs, severally.  They all
# must be writable by the user running munin-cron.
dbdir	/opt/munin/sandbox/var/opt/munin
htmldir	/opt/munin/sandbox/www
logdir	/opt/munin/sandbox/var/log/munin
rundir  /opt/munin/sandbox/var/run/munin

# Where to look for the HTML templates
tmpldir	/opt/munin/sandbox/etc/opt/munin/templates

# Make graphs show values per minute instead of per second
#graph_period minute

# Graphics files are normally generated on-demand by a CGI process.
# See http://munin-monitoring.org/wiki/CgiHowto2 for more
# documentation.
#
#graph_strategy cgi

# Drop somejuser@fnord.comm and anotheruser@blibb.comm an email everytime
# something changes (OK -> WARNING, CRITICAL -> OK, etc)
#contact.someuser.command mail -s "Munin notification" somejuser@fnord.comm
#contact.anotheruser.command mail -s "Munin notification" anotheruser@blibb.comm
#
# For those with Nagios, the following might come in handy. In addition,
# the services must be defined in the Nagios server as well.
#contact.nagios.command /usr/bin/send_nsca nagios.host.comm -c /etc/nsca.conf

tls disabled
tls_private_key /opt/munin/common/t/tls/master_key.pem
tls_certificate /opt/munin/common/t/tls/master_cert.pem
tls_ca_certificate /opt/munin/common/t/tls/CA/ca_cert.pem
tls_verify_certificate yes
tls_verify_depth 5

# a simple host tree
[marvin]
    address 127.0.0.1
    port 4948
    use_node_name yes
    load1.graph_title Loads side by side
    load1.graph_order fii=fii.foo.com:load.load fay=fay.foo.com:load.load

# 
# A more complex example of a host tree
#
## First our "normal" host.
# [fii.foo.com]
#       address foo
#
## Then our other host...
# [fay.foo.com]
#       address fay
#
## Then we want totals...
# [foo.com;Totals] #Force it into the "foo.com"-domain...
#       update no   # Turn off data-fetching for this "host".
#
#   # The graph "load1". We want to see the loads of both machines... 
#   # "fii=fii.foo.com:load.load" means "label=machine:graph.field"
#       load1.graph_title Loads side by side
#       load1.graph_order fii=fii.foo.com:load.load fay=fay.foo.com:load.load
#
#   # The graph "load2". Now we want them stacked on top of each other.
#       load2.graph_title Loads on top of each other
#       load2.dummy_field.stack fii=fii.foo.com:load.load fay=fay.foo.com:load.load
#       load2.dummy_field.draw AREA # We want area instead the default LINE2.
#       load2.dummy_field.label dummy # This is needed. Silly, really.
#
#   # The graph "load3". Now we want them summarised into one field
#       load3.graph_title Loads summarised
#       load3.combined_loads.sum fii.foo.com:load.load fay.foo.com:load.load
#       load3.combined_loads.label Combined loads # Must be set, as this is
#                                                 # not a dummy field!
#
## ...and on a side note, I want them listen in another order (default is
## alphabetically)
#
# # Since [foo.com] would be interpreted as a host in the domain "com", we
# # specify that this is a domain by adding a semicolon.
# [foo.com;]
#       node_order Totals fii.foo.com fay.foo.com
#

