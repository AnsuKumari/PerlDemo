#!/usr/bin/perl

use Modern::Perl;
use CGI qw ( -utf8 );
use C4::Auth;    # get_template_and_user
use C4::Output;
use HTML::HTMLDoc;

my $input = new CGI;
my $dbh   = C4::Context->dbh;
my $htmldoc = new HTML::HTMLDoc();

print $input->header( -type => 'application/pdf',
					  -charset => 'UTF-8',
					  -attachment => 'print-table.pdf' );

$htmldoc->set_input_file(qq~<html><body>The Table in PDF format</body></html>~);

my $pdf = $htmldoc->generate_pdf();
print $pdf->to_string();
