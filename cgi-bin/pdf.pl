#!/usr/bin/perl

use Modern::Perl;
use CGI qw ( -utf8 );
use C4::Auth;    # get_template_and_user
use C4::Output;
use HTML::HTMLDoc;
use Text::CSV;

my $input = new CGI;
my $dbh   = C4::Context->dbh;
my $htmldoc = new HTML::HTMLDoc();

print $input->header( -type => 'application/pdf',
					  -charset => 'UTF-8',
					  -attachment => 'print-table.pdf' );
					  
open my $fh, '>>', 'Output.csv' or die "Could not open file Output.csv: $!";
print $fh qq{cardnumber\tsurname\temail\tphone\n};
					  
my ($sth, $item);
my $sql = "SELECT cardnumber, surname, email, phone from borrowers";

$sth = $dbh->prepare($sql);
$sth->execute(); 

my @rows;
while($item = $sth->fetchrow_hashref){
        push @rows, $item;
        print $fh qq{$item->{'cardnumber'}\t$item->{'surname'}t$item->{'email'}t$item->{'phone'}\n};
}

$htmldoc->set_input_file('Output.csv');

my $pdf = $htmldoc->generate_pdf();
print $pdf->to_string();

close $fh;
