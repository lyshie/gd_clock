#!/usr/bin/env perl
#===============================================================================
#
#         FILE: gd_clock.pl
#
#        USAGE: ./gd_clock.pl
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: SHIE, Li-Yi (lyshie), lyshie@mx.nthu.edu.tw
# ORGANIZATION:
#      VERSION: 1.0
#      CREATED: 2014-05-05 23:17:45
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use GD;
use POSIX qw(strftime);
use Getopt::Long;
use File::Basename;

my %OPTS = (
    width  => 1024,
    height => 1024,
    font   => '/opt/local/fonts/lyshie/funfonts/RADIOLAN.ttf',
    size   => 20,
    format => "%T",
    string => undef,
);

sub graphToText {
    my ( $im, $bounds ) = @_;

    my ( $top,  $bottom ) = ( $bounds->[7], $bounds->[3] );
    my ( $left, $right )  = ( $bounds->[6], $bounds->[2] );

    # center alignment
    my $indent = ( qx/tput cols/ - ( $right - $left ) ) / 2;

    for ( my $i = $top ; $i <= $bottom ; $i++ ) {
        print " " x $indent;

        for ( my $j = $left ; $j <= $right ; $j++ ) {
            my $index = $im->getPixel( $j, $i );

            if ($index) {
                print "▇";
            }
            else {
                print " ";
            }
        }

        print "\n";
    }
}

sub helpMessage {
    my $prog = basename($0);

    print STDERR qq{Usage: $prog
  -w, --width       Canvas width (default: 1024 pixels)
  -h, --height      Canvas height (default: 1024 pixels)
  -p, --size        Font size (default: 20pt)
  -n, --font        Font name
  -f, --format      Time format (default: %T)
  -s, --string      Customized string
  -h, --help        Help message}, "\n";

    exit(1);
}

sub getOptions {
    GetOptions( \%OPTS, "width|w=i", "height|h=i", "size|p=i", "font|n=s",
        "format|f=s", "string|s=s", "help|h" => \&helpMessage, )
      or helpMessage();
}

sub main {

    # parse command line options
    getOptions();

    # set default options
    my $width       = $OPTS{width};
    my $height      = $OPTS{height};
    my $font_name   = $OPTS{font};
    my $ptsize      = $OPTS{size};
    my $time_format = $OPTS{format};
    my $string      = $OPTS{string};

    # create a new image
    my $im = new GD::Image( $width, $height );

    # allocate some colors
    my $white = $im->colorAllocate( 255, 255, 255 );
    my $black = $im->colorAllocate( 0,   0,   0 );

    # draw ttf text
    my @bounds = ();

    @bounds = $im->stringFT(
        $black, $font_name, $ptsize, 0, 0,
        $ptsize * 2,
        $string ? $string : strftime( $time_format, localtime() )
    );

    # convert bitmap graph to text
    graphToText( $im, \@bounds );
}

main;
