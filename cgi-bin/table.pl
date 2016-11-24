#!/usr/bin/perl

use Modern::Perl;
use CGI qw ( -utf8 );
use C4::Auth;    # get_template_and_user
use C4::Output;
use HTML::HTMLDoc;

my $input = new CGI;
my $dbh   = C4::Context->dbh;

my ( $template, $borrowernumber, $cookie ) = get_template_and_user(
    {
        template_name   => "table.tt",
        type            => "opac",
        query           => $input,
        authnotrequired => ( C4::Context->preference("OpacPublic") ? 1 : 0 ),
    }
);



my ($theme, $news_lang, $availablethemes) = C4::Templates::themelanguage(C4::Context->config('opachtdocs'),'table.tt','opac',$input);

my ($sth, $item);
my $sql = "SELECT cardnumber, surname, email, phone from borrowers";

$sth = $dbh->prepare($sql);
$sth->execute(); 

my @rows;
while($item = $sth->fetchrow_hashref){
        push @rows, $item;
}

$template->param(
		title => 'Table', 
        results => \@rows
);

output_html_with_http_headers $input, $cookie, $template->output;
