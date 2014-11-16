#===============================================================================
#      PODNAME:  Net::IP::Identifier::Plugin::Microsoft
#     ABSTRACT:  identify Microsoft (AS8075) owned IP addresses
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Sun Oct 12 19:32:46 PDT 2014
#===============================================================================

use 5.008;
use strict;
use warnings;

package Net::IP::Identifier::Plugin::Microsoft;

use Role::Tiny::With;
with qw( Net::IP::Identifier_Role );

our $VERSION = '0.054'; # VERSION

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, (ref $class || $class);

    # List of known Microsoft (AS8075) IP blocks as of Oct 2014
    $self->ips(qw(
        64.4.0.0/18
        65.52.0.0/14
        134.170.0.0/16
        157.54.0.0/15
        157.56.0.0/14
        157.60.0.0/16
        207.68.128.0/18
    ));
    return $self;
}

sub name {
    return 'Microsoft';
}

sub children {
    return qw( Hotmail );
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Plugin::Microsoft - identify Microsoft (AS8075) owned IP addresses

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier::Plugin::Microsoft;

=head1 DESCRIPTION

Net::IP::Identifier::Plugin::Microsoft identifies Microsoft (AS8075) host IPs.

=head2 Methods

=over

=item new

Creates a new Net::IP::Identifier::Plugin::Microsoft object.

=back

=head1 SEE ALSO

=over

=item IP::Net

=item IP::Net::Identifier

=item IP::Net::Identifier_Role

=back

=head1 AUTHOR

Reid Augustin <reid@hellosix.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Reid Augustin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
