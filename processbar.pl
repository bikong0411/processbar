#!/usr/bin/env perl
use strict;
use LWP::UserAgent;
$|++;
my $VERSION="1.0";
my $index = 0;
my @bar = qw#\ | /#;
my $len = scalar @bar;
die "[err] No URLs were passed for processing. \n" unless @ARGV;

my $final_data = undef;
foreach my $url(@ARGV) {
   print "Downloading URL at ". substr($url,0,40) . "... \n";
   my $ua = LWP::UserAgent->new;
   my $response = $ua->get($url, ':content_cb' => \&callback);
   print "\n";
}

sub callback {
   my($data, $response, $protocol) = @_;
   $final_data .= $data;
   if($index == $len) { $index = 0; }
   print $bar[$index];
   $index += 1;
   sleep 1;
}
