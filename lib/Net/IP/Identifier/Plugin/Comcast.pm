#===============================================================================
#      PODNAME:  Net::IP::Identifier::Plugin::Comcast
#     ABSTRACT:  identify Comcast owned IP addresses
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Thu Nov  6 11:03:17 PST 2014
#===============================================================================

use 5.008;
use strict;
use warnings;

package Net::IP::Identifier::Plugin::Comcast;

use Role::Tiny::With;
with qw( Net::IP::Identifier_Role );

our $VERSION = '0.054'; # VERSION

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, (ref $class || $class);

    # List of known Comcast IP blocks as of Nov 2014
    $self->ips(qw(
        23.24.0.0/15
        23.30.0.0/15
        23.62.96.0/24
        23.62.97.0/24
        23.62.228.0/24
        23.67.48.0/24
        23.67.50.0/24
        23.67.52.0/24
        23.67.60.0/24
        23.67.61.0/24
        23.67.246.0/24
        23.67.247.0/24
        23.68.0.0/14
        24.0.0.0/12
        24.16.0.0/13
        24.30.0.0/17
        24.34.0.0/16
        24.40.0.0/18
        24.40.64.0/20
        24.60.0.0/14
        24.91.0.0/16
        24.98.0.0/15
        24.104.0.0/23
        24.104.6.0/23
        24.104.16.0/23
        24.104.32.0/19
        24.104.64.0/20
        24.104.80.0/22
        24.104.100.0/22
        24.104.112.0/20
        24.104.128.0/19
        24.118.0.0/16
        24.124.128.0/17
        24.125.0.0/16
        24.126.0.0/15
        24.128.0.0/16
        24.129.0.0/17
        24.130.0.0/15
        24.147.0.0/16
        24.153.64.0/19
        24.218.0.0/16
        24.245.0.0/18
        50.73.0.0/16
        50.76.0.0/14
        50.128.0.0/9
        64.139.64.0/19
        65.34.128.0/17
        65.96.0.0/16
        66.30.0.0/15
        66.41.0.0/16
        66.56.0.0/18
        66.176.0.0/15
        66.208.192.0/18
        66.229.0.0/16
        67.160.0.0/11
        68.32.0.0/11
        68.80.0.0/13
        69.136.0.0/13
        69.180.0.0/15
        69.240.0.0/12
        70.88.0.0/14
        71.24.0.0/14
        71.56.0.0/13
        71.192.0.0/12
        71.224.0.0/12
        72.246.41.0/24
        72.246.42.0/24
        72.246.66.0/23
        72.247.42.0/23
        73.0.0.0/8
        74.16.0.0/12
        74.92.0.0/14
        74.144.0.0/12
        75.64.0.0/13
        75.72.0.0/15
        75.74.0.0/16
        75.75.0.0/17
        75.75.128.0/18
        75.144.0.0/13
        76.16.0.0/12
        76.96.0.0/11
        76.128.0.0/11
        96.6.44.0/24
        96.16.104.0/21
        96.16.112.0/21
        96.17.68.0/24
        96.17.70.0/24
        96.17.71.0/24
        96.17.108.0/24
        96.17.110.0/24
        96.17.111.0/24
        96.17.145.0/24
        96.17.147.0/24
        96.17.148.0/24
        96.64.0.0/11
        96.96.0.0/12
        96.112.0.0/13
        96.120.0.0/14
        96.124.0.0/16
        96.128.0.0/10
        96.192.0.0/11
        98.32.0.0/11
        98.192.0.0/10
        107.0.0.0/15
        107.2.0.0/15
        107.4.0.0/15
        147.191.0.0/16
        162.17.0.0/16
        162.148.0.0/14
        165.137.0.0/16
        169.152.0.0/16
        172.244.0.0/16
        173.8.0.0/13
        173.160.0.0/13
        174.48.0.0/12
        174.160.0.0/11
        184.51.207.0/24
        184.84.222.0/24
        184.86.245.0/24
        184.86.246.0/24
        184.86.247.0/24
        184.86.248.0/24
        184.108.0.0/14
        184.112.0.0/12
        198.0.0.0/16
        198.178.8.0/21
        209.23.192.0/18
        216.45.136.0/21
        216.45.220.0/22
        216.45.240.0/21
    ));
    return $self;
}

sub name {
    return 'Comcast';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Plugin::Comcast - identify Comcast owned IP addresses

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier::Plugin::Comcast;

=head1 DESCRIPTION

Net::IP::Identifier::Plugin::Comcast identifies Comcast host IPs.

=head2 Methods

=over

=item new

Creates a new Net::IP::Identifier::Plugin::Comcast object.

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
