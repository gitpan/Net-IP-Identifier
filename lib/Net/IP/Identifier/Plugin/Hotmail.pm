#===============================================================================
#      PODNAME:  Net::IP::Identifier::Plugin::Hotmail
#     ABSTRACT:  identify Hotmail owned IP addresses
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Sun Oct 12 19:32:46 PDT 2014
#===============================================================================

use 5.008;
use strict;
use warnings;

package Net::IP::Identifier::Plugin::Hotmail;

use Role::Tiny::With;
with qw( Net::IP::Identifier_Role );

our $VERSION = '0.054'; # VERSION

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, (ref $class || $class);

    # List of known Hotmail IP blocks as of Oct 2014
    $self->ips(qw(
        65.54.51.64/26
        65.54.61.64/26
        65.54.190.0/24
        65.55.34.0/24
        65.55.90.0/24
        65.55.111.64/26
        65.55.111.128/26
        65.55.116.0/25
        157.55.0.192/26
        157.55.1.128/26
        157.55.2.0/25
        207.46.66.0/28
    ));
    return $self;
}

sub name {
    return 'Hotmail';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Plugin::Hotmail - identify Hotmail owned IP addresses

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier::Plugin::Hotmail;

=head1 DESCRIPTION

Net::IP::Identifier::Plugin::Hotmail identifies Hotmail host IPs.

=head2 Methods

=over

=item new

Creates a new Net::IP::Identifier::Plugin::Hotmail object.

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
