#!/usr/bin/env perl -w
use strict;
use LWP::UserAgent;
use LWP::ConnCache;

my $VERSION="1.0";
$|++;
die "[err] No URLS were passed for processing. \n" unless @ARGV;

my $final_data;
my $total_size;
my $ua = LWP::UserAgent->new;
$ua->conn_cache(LWP::ConnCache->new);

foreach my $url(@ARGV) {
   print "Downloading URL at ".substr($url,0,40). " ...\n";
   my $result = $ua->head($url);
   my $remote_headers = $result->headers;
   $total_size = $remote_headers->content_length;
   my $response = $ua->get($url, ':content_cb' => \&callback);
}

sub callback {
   my($data, $response, $protocol) = @_;
   $final_data .= $data;
   print progress_bar(length($final_data), $total_size, 25, '=');
}

sub progress_bar {
   my ($got, $total, $width, $char) = @_;
   $width ||= 25;
   $char ||= '=';
   my $num_width = length $total;
   sprintf "|%-${width}s| Got %${num_width}s bytes of %s (%0.2f%%)\r", $char x (($width-1)*$got/$total). '>',$got, $total,100 * $got/$total;
}
