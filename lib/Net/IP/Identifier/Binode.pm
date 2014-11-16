#!/usr/bin/perl
#===============================================================================
#      PODNAME:  Net::IP::Identifier::Binode
#     ABSTRACT:  A node in the binary tree
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Mon Oct  6 10:20:33 PDT 2014
#===============================================================================

use 5.002;
use strict;
use warnings;

package Net::IP::Identifier::Binode;
use Moo;
use namespace::clean;

our $VERSION = '0.054'; # VERSION

has zero => (
    is => 'rw',
    isa => sub { die if ref $_[0] ne 'Net::IP::Identifier::Binode' },
);
has one => (
    is => 'rw',
    isa => sub { die if ref $_[0] ne 'Net::IP::Identifier::Binode' },
);
has payload => (
    is => 'rw',
);

sub bin_to_ip {
    my ($bin) = @_;

    my @results;
    my $max = length $bin;
    for (my $ii = 0; ; $ii++) {
        if ($ii % 8 == 0) {
            last if ($ii >= $max);
            push @results, 0;
        }
        my $b = $ii < $max ? substr($bin, $ii, 1) : 0;
        $results[-1] <<= 1;
        $results[-1] |= $b;
    }
    return join '.', @results;
}

# gather payloads of all children
sub children {
    my ($self) = @_;

    my (@payload, @zeros, @ones);
    push @payload, $self if ($self->payload);
    @zeros = $self->zero->children if ($self->zero);
    @ones = $self->one->children if ($self->one);
    return @payload, @zeros, @ones;
}

sub descend {
    my ($self, $path, $payload) = @_;

    return $self->_descend($path, 0, $payload);
}

sub _descend {
    my ($self, $path, $level, $payload) = @_;

    my @return;
    if ($level >= length $path) {    # end of the line
        push @return, $self if ($self->payload);
        my @children;
        if (defined $payload) {
            $self->payload($payload);
            @children = $self->children;
        }
        return @return, @children;
    }

    my $bit = substr($path, $level, 1); # next step
    if (defined $payload) { # when creating the tree, add branches as we go
        if ($bit) {
            $self->one($self->new) if (not $self->one);
        }
        else {
            $self->zero($self->new) if (not $self->zero);
        }
    }

    if ($bit) {
        @return = $self->one->_descend($path, $level + 1, $payload) if ($self->one);
    }
    else {
        @return = $self->zero->_descend($path, $level + 1, $payload) if ($self->zero);
    }

    unshift @return, $self if $self->payload; # collect all nodes with payloads

    return @return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Binode - A node in the binary tree

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier::Binode;

=head1 DESCRIPTION

Net::IP::Identifier::Binode represents a single node in a binary tree.  The branches off the
node are B<zero> and B<one>.  The node may also carry a B<$payload>.  Any of these may be set
via arguments to B<new> or through accessors.

=head2 Accessors (or arguments to B<new>)

=over

=item zero( [ $new ] )

Set or get the B<zero> branch.  If B<new> is defined, it must be a Net::IP::Identifier::Binode.

=item one( [ $new ] )

Set or get the B<one> branch.  If B<new> is defined, it must be a Net::IP::Identifier::Binode.

=item payload( [ $new ] )

Set or get the payload attached to this node.  B<new> can be anything.  It's a good idea to
create a Local::Payload object to hold the B<$payload>.

=back

=head2 Methods

=over

=item descend($path, [ $payload ] );

Descend the binary tree, following B<$path>.  B<$path> should be a string
where the length represents the number of levels to descend, false
characters ('0's and spaces) follow the B<zero> branch, and true characters
follow the B<one> branch.

To construct a branch of the tree, define B<$payload>.  New child nodes are
created as necessary, and when the end of B<$path> is reached,
B<$payload> is attached.  To create the branch with nothing attached at the
final node, pass undef as the B<$payload>:

    $root-node->descend($path, undef)

When not constructing a branch (no B<$payload> element is passed), the
return value is an array of each node along B<$path> that contained a
B<$payload>, including the B<$payload> of the final node.  Checking for
more than one node in the return array indicates which B<$payload>s have
'parent' B<$payload>s.

When constructing a branch (B<$payload> is passed), each child branch
below the final B<$path> node is explored and any child node that contains
a B<$payload> is added to the return array.  Checking for more than one
payload in the return array indicates which branches of the binary tree
have overlapping B<$payload>s.

=item children

Returns an array consisting of the current node (if this node has a B<$payload>), and
the nodes of all child branches that carry a B<$payload>.

=back

=head1 SEE ALSO

=over

=item Net::IP::Identifier

=back

=head1 AUTHOR

Reid Augustin <reid@hellosix.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Reid Augustin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
