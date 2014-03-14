#! /usr/bin/env perl
use strict;
use warnings;
use Getopt::Long qw( :config posix_default bundling no_ignore_case );
use Irssi;

our $VERSION = '0.1';
our %IRSSI = (
  authors     => 'Christopher Tubbs',
  contact     => 'https://github.com/ctubbsii',
  name        => 'Irssi JIRA Bot',
  description => 'A small irssi script for recommending links to possible ' .
                  'JIRA issues discussed in IRC',
  license     => 'BSD',
);

my $jira = 'https://issues.apache.org/jira';
my $jira_proj = 'ACCUMULO';
my $response_prefix = 'Possible JIRA mentioned: ';
my $test_message;
my $test_channel = 'test';

sub irssi_jira_main {
  &parse_args();
  if ($test_message) {
    print 'Testing: ' . $test_message . "\n";
    &sig_message_public('dummy', $test_message, 'test_user', 'test_ip', '#' . $test_channel);
  } else {
    Irssi::signal_add('message public', 'sig_message_public');
  }
}

sub parse_args {
  GetOptions(
    't|test=s' => \$test_message,
    'c|channel=s' => \$test_channel,
  ) or die("Invalid test message\n");
}

sub respond_in_channel {
  my ($server, $channel, $response) = @_;
  my $line = 'msg ' . $channel . ' ' . $response;
  if ($test_message) {
    print $line . "\n";
  } else {
    $server->command($line);
  }
}

sub sig_message_public {
  my ($server, $msg, $nick, $nick_addr, $target) = @_;
  if ($target =~ /^#(?:accumulo|test)$/) { # only operate in these channels
    foreach my $w ($msg =~ /(\S+)/g) {
      if ($w =~ /^\d{3,5}$/) {
        &respond_in_channel($server, $target, "${response_prefix}$jira/browse/${jira_proj}-$w");
      } elsif ($w =~ /^ACCUMULO-\d{1,5}$/) {
        &respond_in_channel($server, $target, "${response_prefix}$jira/browse/$w");
      }
    }
  }
}

&irssi_jira_main();
