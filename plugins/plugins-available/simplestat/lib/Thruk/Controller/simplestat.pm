package Thruk::Controller::simplestat;

use strict;
use warnings;
use Carp;
use Data::Dumper;
use parent 'Catalyst::Controller';

=head1 NAME

Thruk::Controller::simplestat - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

######################################

=head2 simplestat.cgi

=cut
sub index : Path('/thruk/cgi-bin/statuswml.cgi') {
    my ( $self, $c ) = @_;

    my $hostfilter = [ { 'state'=> { '>' => 0 } }, {'has_been_checked' => 1}, {'acknowledged' => 0}, {'scheduled_downtime_depth' => 0} ];
    my $servicefilter = [ { 'state'=> { '>' => 0 } }, {'has_been_checked' => 1}, {'acknowledged' => 0}, {'scheduled_downtime_depth' => 0}, {'host_state' => {'=' => 0}} ];
    my $services = $c->{'db'}->get_services(filter => [ $servicefilter ]);
    my $hosts = $c->{'db'}->get_hosts(filter => [ $hostfilter ]);
    $c->stash->{services}       = $services;
    $c->stash->{hosts}          = $hosts;
    $c->stash->{hoststats}      = $c->{'db'}->get_host_stats();
    $c->stash->{servicestats}   = $c->{'db'}->get_service_stats();
    $c->stash->{template}       = 'simplestat.tt';

    return 1;
}

=head1 AUTHOR


Jan Ulferts, 2012


=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
