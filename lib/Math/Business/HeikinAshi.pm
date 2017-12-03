package Math::Business::HeikinAshi;

=head1 NAME

Math::Business::HeikinAshi v 0.1 - Heikin-Ashi Candlestick 

=cut

our $VERSION = '0.1';

use strict;
use warnings;
use List::Util qw(min max all);
use Carp;

sub new {
    my $class = shift;
    my $self  = bless {
        o => undef, # open
        h => undef, # high
        l => undef, # low
        c => undef, # close
    }, $class;
    
    return $self;
}

sub insert {
    my $self  = shift;
    my ( $o, $h, $l, $c ) = @_;
    croak "Insert takes 4 values: open, high, low, close" if not all { defined } $o, $h, $l, $c;
    
    if ( all { defined } $self->{o}, $self->{h}, $self->{l}, $self->{c} ) {
        $self->{o} = ($self->{o} + $self->{c}) / 2;
        $self->{c} = ($o + $h + $l + $c) / 4;  
        $self->{h} = max($h, $self->{o}, $self->{c});
        $self->{l} = min($l, $self->{o}, $self->{c});
    }
    else {
        $self->{o} = ($o + $c) / 2;
        $self->{c} = ($o + $h + $l + $c) / 4;
        $self->{h} = $h;
        $self->{l} = $l;
    }
    return $self->query;
}

sub query {
    my $self = shift;
    return ( $self->{o}, $self->{h}, $self->{l}, $self->{c} ) ; 
}

1;
__END__

=head1 SYNOPSIS

use Math::Business::HeikinAshi;

my $ha = Math::Business::HeikinAshi->new();

print join ( ' ', $ha->insert( 66.850, 80.000,  66.000, 76.392 ) )."\n";
print join ( ' ', $ha->insert( 76.330, 77.500,  70.212, 71.024 ) )."\n";
print join ( ' ', $ha->insert( 70.244, 102.202, 70.000, 92.830 ) )."\n";
print join ( ' ', $ha->insert( 90.024, 110.092, 82.900, 100.879 ) )."\n";

print join ( ' ', $ha->query )."\n";

=head1 FUNCTIONS

=head2 insert

Insert takes 4 values: OPEN, HIGH, LOW, CLOSE, 
returns Heikin-Ashi generated OPEN, HIGH, LOW, CLOSE.

=head2 query

Returns Heikin-Ashi generated OPEN, HIGH, LOW, CLOSE.

=head1 AUTHOR

TKPERL

My github: L<https://github.com/tkperl>

=head1 LICENSE

This is released under the Artistic License. See L<perlartistic>.

=head1 NOTE

Based on:

https://www.investopedia.com/articles/technical/04/092204.asp
https://quantiacs.com/Blog/Intro-to-Algorithmic-Trading-with-Heikin-Ashi.aspx

=cut
