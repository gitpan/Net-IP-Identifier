#===============================================================================
#      PODNAME:  Net::IP::Identifier::Plugin::Akamai
#     ABSTRACT:  identify Akamai owned IP addresses
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Thu Nov  6 11:03:41 PST 2014
#===============================================================================

use 5.008;
use strict;
use warnings;

package Net::IP::Identifier::Plugin::Akamai;

use Role::Tiny::With;
with qw( Net::IP::Identifier_Role );

our $VERSION = '0.054'; # VERSION

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, (ref $class || $class);

    # List of known Akamai IP blocks as of Nov 2014
    $self->ips(qw(
        23.3.68.0/24
        23.3.75.0/24
        23.3.108.0/23
        23.4.128.0/19
        23.7.64.0/20
        23.7.144.0/20
        23.14.132.0/22
        23.15.240.0/23
        23.32.30.0/24
        23.33.186.0/24
        23.48.156.0/22
        23.58.92.0/23
        23.193.164.0/23
        23.193.208.0/22
        23.193.224.0/20
        23.193.240.0/20
        23.205.126.0/23
        23.208.212.0/22
        23.208.224.0/20
        23.208.240.0/20
        23.210.5.0/24
        23.210.14.0/23
        23.210.48.0/20
        23.210.64.0/20
        23.210.80.0/22
        23.210.202.0/23
        23.210.204.0/22
        23.210.240.0/20
        23.211.0.0/20
        23.212.52.0/24
        23.212.59.0/24
        23.213.130.0/23
        23.213.134.0/23
        23.213.144.0/20
        23.213.160.0/20
        23.213.176.0/22
        72.246.45.0/24
        96.17.208.0/20
        104.66.192.0/20
        104.66.208.0/20
        184.25.157.0/24
        184.28.62.0/23
        184.28.112.0/24
        184.28.114.0/24
        184.28.118.0/24
        184.28.116.0/24
        184.51.48.0/22
        184.51.102.0/24
        ),

        # these blocks are 'Proxy-registered route objects',
        #    Internodes, and dummies
        qw(
        23.3.12.0/24
        23.7.128.0/20
        23.7.192.0/20
        23.40.176.0/20
        23.41.0.0/20
        23.49.56.0/24
        96.17.224.0/20
        173.222.176.0/22
        184.28.16.0/24
        184.28.68.0/23
        184.28.70.0/23
        184.28.72.0/23
        184.28.78.0/23
        184.51.68.0/22
        184.51.72.0/22
        184.51.159.0/24
        184.84.180.0/24
        184.84.183.0/24
        184.85.96.0/20
        184.86.112.0/22
    ));
    return $self;
}

sub name {
    return 'Akamai';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Plugin::Akamai - identify Akamai owned IP addresses

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier::Plugin::Akamai;

=head1 DESCRIPTION

Net::IP::Identifier::Plugin::Akamai identifies Akamai host IPs.

=head2 Methods

=over

=item new

Creates a new Net::IP::Identifier::Plugin::Akamai object.

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
