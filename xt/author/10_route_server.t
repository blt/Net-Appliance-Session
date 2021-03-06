#!/usr/bin/perl

use strict; use warnings FATAL => 'all';
use Test::More 0.88;

BEGIN { use_ok( 'Net::Appliance::Session') }

my $s = new_ok( 'Net::Appliance::Session' => [{
    transport => "Telnet",
    ($^O eq 'MSWin32' ?
        (app => "$ENV{HOMEPATH}\\Desktop\\plink.exe") : () ),
    host => "route-server.bb.pipex.net",
    personality => "cisco",
    do_login => 0,
    do_paging => 0,
}]);

ok( $s->connect );

ok( $s->cmd('show ip bgp 163.1.0.0/16'), 'ran show ip bgp 163.1.0.0/16' );

like( $s->last_prompt, qr/\w+ ?>$/, 'command ran and last_prompt looks ok' );

my @out = $s->last_response;
cmp_ok( scalar @out, '==', 15, 'sensible number of lines in the command output');

done_testing;
