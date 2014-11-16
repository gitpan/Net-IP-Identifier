#===============================================================================
#      PODNAME:  Net::IP::Identifier::Plugin::Sagonet
#     ABSTRACT:  identify Sagonet (AS21840) owned IP addresses
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Sat Nov  8 15:59:36 PST 2014
#===============================================================================

use 5.008;
use strict;
use warnings;

package Net::IP::Identifier::Plugin::Sagonet;

use Role::Tiny::With;
with qw( Net::IP::Identifier_Role );

our $VERSION = '0.054'; # VERSION

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, (ref $class || $class);

    # List of known Sagonet (AS21840) IP blocks as of Nov 2014
    $self->ips(qw(
        64.16.192.0/19
        65.110.32.0/19
        66.118.128.0/18
        207.150.160.0/19
    ));
    return $self;
}

sub name {
    return 'Sagonet';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Plugin::Sagonet - identify Sagonet (AS21840) owned IP addresses

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier::Plugin::Sagonet;

=head1 DESCRIPTION

Net::IP::Identifier::Plugin::Sagonet identifies Sagonet (AS21840) host IPs.

=head2 Methods

=over

=item new

Creates a new Net::IP::Identifier::Plugin::Sagonet object.

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
