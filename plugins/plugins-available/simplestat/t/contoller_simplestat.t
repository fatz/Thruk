use strict;
use warnings;
use Test::More tests => 34;

BEGIN {
    use lib('t');
    require TestUtils;
    import TestUtils;
}

SKIP: {
    skip 'external tests', 1 if defined $ENV{'CATALYST_SERVER'};

    use_ok 'Thruk::Controller::simplestat';
};

my $pages = [
    '/thruk/cgi-bin/simplestat.cgi',
];

for my $url (@{$pages}) {
    TestUtils::test_page(
        'url'            => $url,
        'like'           => [ 'Simplestat Monitoring Status' ],
    );
}

