#!/usr/bin/env perl
#===============================================================================
#
#         FILE: gd_clock.pl
#
#        USAGE: ./gd_clock.pl [TTF-FONT] [FONT-SIZE] [TIME-FORMAT]
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
                print "█";
            }
            else {
                print " ";
            }
        }

        print "\n";
    }
}

sub main {
    my $width  = 1024;
    my $height = 1024;

    my $font_name = $ARGV[0] // "/opt/local/fonts/lyshie/funfonts/RADIOLAN.ttf";
    my $ptsize    = $ARGV[1] // 20;
    my $time_format = $ARGV[2] // "%T";

    # create a new image
    my $im = new GD::Image( $width, $height );

    # allocate some colors
    my $white = $im->colorAllocate( 255, 255, 255 );
    my $black = $im->colorAllocate( 0,   0,   0 );

    # draw ttf text
    my @bounds = ();

    @bounds = $im->stringFT(
        $black, $font_name, $ptsize, 0, 0,
        $height / 2,
        strftime( $time_format, localtime() )
    );

    # convert bitmap graph to text
    graphToText( $im, \@bounds );
}

main;
