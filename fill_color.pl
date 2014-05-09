#!/usr/bin/env perl
#===============================================================================
#
#         FILE: fill_color.pl
#
#        USAGE: ./fill_color.pl
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
#      CREATED: 2014-05-09 09:13:25
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
no warnings "recursion";

use Encode qw(encode decode);
use Term::ANSIColor qw(:constants);

my @COLORS = ( RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN );

sub get_color {
    my $index = int( rand( scalar(@COLORS) ) );

    return $COLORS[$index];
}

sub fill {
    my ( $ref, $x, $y, $old, $new ) = @_;

    return unless ( defined( $ref->[$y] ) );

    return unless ( defined( $ref->[$y]->[$x] ) );

    if ( $ref->[$y]->[$x] eq $old ) {
        $ref->[$y]->[$x] = $new;

        # shadow
        if ( $ref->[ $y + 1 ]->[ $x + 1 ] eq " " ) {
            $ref->[ $y + 1 ]->[ $x + 1 ] = WHITE . "▇" . RESET;
        }

        # 4-way recursive
        fill( $ref, $x - 1, $y,     $old, $new );
        fill( $ref, $x,     $y - 1, $old, $new );
        fill( $ref, $x + 1, $y,     $old, $new );
        fill( $ref, $x,     $y + 1, $old, $new );
    }
}

sub colorize {
    my ($ref) = @_;

    # fill color
    for my $y ( 0 .. scalar(@$ref) - 1 ) {
        for my $x ( 0 .. scalar( @{ $ref->[$y] } ) - 1 ) {
            fill( $ref, $x, $y, "▇", get_color() . "▇" . RESET );
        }
    }

    # output
    for my $y ( 0 .. scalar(@$ref) - 1 ) {
        for my $x ( 0 .. scalar( @{ $ref->[$y] } ) - 1 ) {
            print $ref->[$y]->[$x];
        }
        print "\n";
    }
}

sub main {
    my @points = ();
    my $i      = 0;

    while ( my $line = <STDIN> ) {
        chomp($line);

        # deal with unicode symbol
        my @dots =
          map { encode( "utf-8", $_ ) } split( //, decode( "utf-8", $line ) );

        $points[ $i++ ] = \@dots;
    }

    colorize( \@points );
}

main;
