#===============================================================================
#      PODNAME:  Net::IP::Identifier::Plugin::FDCServers
#     ABSTRACT:  identify FDCServers (AS30058) owned IP addresses
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Thu Nov  6 09:57:17 PST 2014
#===============================================================================

use 5.008;
use strict;
use warnings;

package Net::IP::Identifier::Plugin::FDCServers;

use Role::Tiny::With;
with qw( Net::IP::Identifier_Role );

our $VERSION = '0.054'; # VERSION

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, (ref $class || $class);

    # List of known FDCServers (AS30058) IP blocks as of Nov 2014
    $self->ips(qw(
        23.237.0.0/16
        38.88.52.0/30
        38.88.52.4/30
        38.104.181.236/30
        38.122.147.192/30
        50.7.0.0/16
        66.90.64.0/18
        67.159.0.0/18
        74.63.64.0/18
        76.73.0.0/17
        107.176.0.0/15
        108.179.64.0/18
        192.240.96.0/19
        198.16.64.0/18
        198.255.0.0/17
        204.45.0.0/16
        208.53.128.0/18
        216.227.128.0/18
    ));
    return $self;
}

sub name {
    return 'FDCServers';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Plugin::FDCServers - identify FDCServers (AS30058) owned IP addresses

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier::Plugin::FDCServers;

=head1 DESCRIPTION

Net::IP::Identifier::Plugin::FDCServers identifies FDCServers (AS30058) host IPs.

=head2 Methods

=over

=item new

Creates a new Net::IP::Identifier::Plugin::FDCServers object.

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
