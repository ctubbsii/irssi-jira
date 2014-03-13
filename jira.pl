#! /usr/bin/env perl
use strict;
use warnings;
use Irssi;

sub sig_message_public {
  my ($server, $msg, $nick, $nick_addr, $target) = @_;

  if ($target =~ /#(?:accumulo)/) { # only operate in these channels
    my @tickets = ();
    foreach my $w ($msg =~ /(\S+)/g) {
      push(@tickets, "https://issues.apache.org/jira/browse/ACCUMULO-$w") if ($w =~ /^\d+$/);
    }
    my $response = 'msg ' . $target . ' Possible JIRAs: ' . join(', ', @tickets);
    $server->command($response) if (scalar(@tickets) > 0);
  }
}

Irssi::signal_add('message public', 'sig_message_public');
