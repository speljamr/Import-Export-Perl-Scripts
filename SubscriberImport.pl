#!/usr/bin/perl -w

use DBI;
use strict;

#require('ab_constants.pl');
require('importSQL.pl');

print "Content-type:text/html\n\n";
print "Starting Script.....<br>";

##################################################################
#
# Import the existing mailing list of subscribers for Akron Bugle
# Created 1/3/2003               
# Version 1.0
#
# Modification History
#
# 1/3/2003  - Initial creation of file
# 1/9/2003  - Added insert to subscribersessions table
# 1/17/2003 - Fixed scope declaration in importSQL.pl
#
##################################################################

my ($sth,$strExpirationDate,$intCounter,$strFile,$strRegCode,$strStars,$strPreSort,$strExpirationMonth,$strExpirationYear,$strLastDay,$strFirstName,$strLastName,$strCompany,$strTitle,$strStreetNumber,$strStreetName,$strCity,$strState,$strZip,$strZipPlus4,$strGiftGiver,$strAddressSequence,$strSQL,$intRows,$strSubType,$intRegCounter,$strOffice,$strZone,$strSort,$intSubscriptionType,$intLastInsertID);

my (@ary,@arrRural,@arrLine,@arrZip,@arrCity);

my $strDSN = "DBI:mysql:AkronBugle:localhost";
my $strUsername = "web_admin";
my $strPassword = "admin";

my $intTotalSubscribers = 0;

my $RuralFilePath = "/usr/local/etc/httpd/htdocs/akronbuglecom/imports/AC-RuralRoutes.dat";
my $CityFilePath = "/usr/local/etc/httpd/htdocs/akronbuglecom/imports/AC-City.dat";
my $OutOfTownFilePath = "/usr/local/etc/httpd/htdocs/akronbuglecom/imports/AC-OutOfTown.dat";

my $intRuralID = 1;
my $intCityID = 2;
my $intOutOfTownID = 3;

my $dbh = DBI->connect($strDSN,$strUsername,$strPassword,{ RaiseError => 1 });

# Read Rural Routes File

open (RURALIMPORT, $RuralFilePath) or dieNice ("Can't Open Rural Routes Import");

$strFile = <RURALIMPORT>;
@arrRural = split(/\r/,$strFile);

close (RURALIMPORT);

$intRegCounter = 1000;
$intCounter = 0;

foreach my $strLine (@arrRural) {

	$intSubscriptionType = 7;
	$strExpirationDate = '1900-01-01';

	if ($intCounter > 0) {
	
		$strRegCode = "REG".$intRegCounter;
	
		chomp($strLine);
		@arrLine = split(/,/, $strLine);
		$strStars = $arrLine[0];
		$strPreSort = $arrLine[1];
		
		$strExpirationMonth = substr($arrLine[3],0,2);
		$strExpirationYear = substr($arrLine[3],2,2);
		if ($arrLine[3] != '0000' && $arrLine[3] != '????') {
			if (substr($strExpirationYear,0,1) == "0") {
				$strExpirationYear = "20".$strExpirationYear;
			} else {
				$strExpirationYear = "19".$strExpirationYear;
			}
			$strLastDay = GetLastDayOfMonth($strExpirationMonth);
			$strExpirationDate = $strExpirationYear."-".$strExpirationMonth."-".$strLastDay
		} else {
			$strExpirationDate = '1900-01-01';
		}
		
		if (length($arrLine[3]) > 4) {
			$strSubType = substr($arrLine[3],4);
			if ($strSubType eq "G") {
				$intSubscriptionType = 6;
			} elsif ($strSubType eq "ADV") {
				$intSubscriptionType = 4;
			} elsif ($strSubType eq "S") {
				$intSubscriptionType = 5;
			}
		}
		$strFirstName = $arrLine[4];
		$strLastName = $arrLine[5];
		$strCompany = $arrLine[6];
		$strTitle = $arrLine[7];
		$strStreetNumber = $arrLine[8];
		$strStreetName = $arrLine[9];
		$strCity = $arrLine[10];
		$strState = $arrLine[11];

		@arrZip = split(/-/, $arrLine[12]);
		$strZip = $arrZip[0];
		$strZipPlus4 = $arrZip[1];

		$strGiftGiver = $arrLine[16];
		$strAddressSequence = $arrLine[17];
		
		#Build Mechanisms to replace ' with''
		$strStars =~ s/'/''/g;
		$strPreSort =~ s/'/''/g;
		$strFirstName =~ s/'/''/g;
		$strLastName =~ s/'/''/g;
		$strCompany =~ s/'/''/g;
		$strTitle =~ s/'/''/g;
		$strStreetNumber =~ s/'/''/g;
		$strStreetName =~ s/'/''/g;
		$strCity =~ s/'/''/g;
		$strState =~ s/'/''/g;
		$strZip =~ s/'/''/g;
		$strZipPlus4 =~ s/'/''/g;
		$strGiftGiver =~ s/'/''/g;
		
		$strSQL = ImportRuralSQL($strStars,$strPreSort,$strExpirationDate,$strFirstName,$strLastName,$strCompany,$strTitle,$strStreetNumber,$strStreetName,$strCity,$strState,$strZip,$strZipPlus4,$strGiftGiver,$strAddressSequence,$strRegCode,$intSubscriptionType,$intRuralID);
		
		$intRows = $dbh->do($strSQL);
		$intLastInsertID = $dbh->{mysql_insertid};
		
		$strSQL = CreateSessionSQL($intLastInsertID);
		$dbh->do($strSQL);
		
		$intTotalSubscribers += $intRows;
	}
	$intCounter++;
	$intRegCounter++;
}


# Read City Routes File
#print "I get this far<br>";
open (CITYIMPORT, $CityFilePath) or dieNice ("Can't Open City Routes Import");

$strFile = <CITYIMPORT>;
@arrCity = split(/\r/,$strFile);

close (CITYIMPORT);

$intCounter = 0;

foreach my $strLine (@arrCity) {

	$intSubscriptionType = 7;
	$strExpirationDate = '1900-01-01';

	if ($intCounter > 0) {
	
		$strRegCode = "REG".$intRegCounter;
	
		chomp($strLine);
		@arrLine = split(/,/, $strLine);
		$strStars = $arrLine[0];
		$strPreSort = $arrLine[1];
		
		$strExpirationMonth = substr($arrLine[3],0,2);
		$strExpirationYear = substr($arrLine[3],2,2);
		if ($arrLine[3] != '0000' && $arrLine[3] != '????') {
			if (substr($strExpirationYear,0,1) == "0") {
				$strExpirationYear = "20".$strExpirationYear;
			} else {
				$strExpirationYear = "19".$strExpirationYear;
			}
			$strLastDay = GetLastDayOfMonth($strExpirationMonth);
			$strExpirationDate = $strExpirationYear."-".$strExpirationMonth."-".$strLastDay
		} else {
			$strExpirationDate = '1900-01-01';
		}
		
		if (length($arrLine[3]) > 4) {
			$strSubType = substr($arrLine[3],4);
			if ($strSubType eq "G") {
				$intSubscriptionType = 6;
			} elsif ($strSubType eq "ADV") {
				$intSubscriptionType = 4;
			} elsif ($strSubType eq "S") {
				$intSubscriptionType = 5;
			}
		}
		$strFirstName = $arrLine[4];
		$strLastName = $arrLine[5];
		$strCompany = $arrLine[6];
		$strTitle = $arrLine[7];
		$strStreetNumber = $arrLine[8];
		$strStreetName = $arrLine[9];
		$strCity = $arrLine[10];
		$strState = $arrLine[11];

		@arrZip = split(/-/, $arrLine[12]);
		$strZip = $arrZip[0];
		$strZipPlus4 = $arrZip[1];

		$strGiftGiver = $arrLine[16];
		$strAddressSequence = $arrLine[17];
		
		#Build Mechanisms to replace ' with''
		$strStars =~ s/'/''/g;
		$strPreSort =~ s/'/''/g;
		$strFirstName =~ s/'/''/g;
		$strLastName =~ s/'/''/g;
		$strCompany =~ s/'/''/g;
		$strTitle =~ s/'/''/g;
		$strStreetNumber =~ s/'/''/g;
		$strStreetName =~ s/'/''/g;
		$strCity =~ s/'/''/g;
		$strState =~ s/'/''/g;
		$strZip =~ s/'/''/g;
		$strZipPlus4 =~ s/'/''/g;
		$strGiftGiver =~ s/'/''/g;
		
		$strSQL = ImportRuralSQL($strStars,$strPreSort,$strExpirationDate,$strFirstName,$strLastName,$strCompany,$strTitle,$strStreetNumber,$strStreetName,$strCity,$strState,$strZip,$strZipPlus4,$strGiftGiver,$strAddressSequence,$strRegCode,$intSubscriptionType,$intCityID);
		
		$intRows = $dbh->do($strSQL);
		$intLastInsertID = $dbh->{mysql_insertid};
		
		$strSQL = CreateSessionSQL($intLastInsertID);
		$dbh->do($strSQL);
		
		$intTotalSubscribers += $intRows;
	}
	$intCounter++;
	$intRegCounter++;
}

# Read Out Of Town Routes File

open (OUTOFTOWNIMPORT, $OutOfTownFilePath) or dieNice ("Can't Open Out Of Town Routes Import");

$strFile = <OUTOFTOWNIMPORT>;
@arrCity = split(/\r/,$strFile);

close (OUTOFTOWNIMPORT);

$intCounter = 0;

foreach my $strLine (@arrCity) {

	$intSubscriptionType = 7;
	$strExpirationDate = '1900-01-01';

	if ($intCounter > 0) {
	
		$strRegCode = "REG".$intRegCounter;
		
		chomp($strLine);
		@arrLine = split(/,/, $strLine);
		$strStars = $arrLine[0];
		$strPreSort = $arrLine[1];
		
		if ($arrLine[3] =~ m/^[0-9]{4}/) {
		
			$strExpirationMonth = substr($arrLine[3],0,2);
			$strExpirationYear = substr($arrLine[3],2,2);
			if ($arrLine[3] != '0000' || $arrLine[3] != '9999') {
				if (substr($strExpirationYear,0,1) == "0") {
					$strExpirationYear = "20".$strExpirationYear;
				} else {
					$strExpirationYear = "19".$strExpirationYear;
				}
				$strLastDay = GetLastDayOfMonth($strExpirationMonth);
				$strExpirationDate = $strExpirationYear."-".$strExpirationMonth."-".$strLastDay
			}

			if (length($arrLine[3]) > 4) {
				$strSubType = substr($arrLine[3],4);
				if ($strSubType eq "G") {
					$intSubscriptionType = 6;
				} elsif ($strSubType eq "ADV") {
					$intSubscriptionType = 4;
				} elsif ($strSubType eq "S") {
					$intSubscriptionType = 5;
				}
			}
			
		} elsif ($arrLine[3] eq "EXCH") {
			$intSubscriptionType = 2;
		} elsif ($arrLine[3] eq "COMP") {
			$intSubscriptionType = 3;
		} elsif ($arrLine[3] eq "ADV" || $arrLine[2] eq "ADVR") {
			$intSubscriptionType = 4;
		}
		$strFirstName = $arrLine[4];
		$strLastName = $arrLine[5];
		$strCompany = $arrLine[6];
		$strOffice = $arrLine[7];
		$strStreetNumber = $arrLine[8];
		$strStreetName = $arrLine[9];
		$strCity = $arrLine[10];
		$strState = $arrLine[11];
		
		@arrZip = split(/-/, $arrLine[12]);
		$strZip = $arrZip[0];
		$strZipPlus4 = $arrZip[1];
		
		$strGiftGiver = $arrLine[16];
		$strZone = $arrLine[18];
		$strSort = $arrLine[19];
		
		#Build Mechanisms to replace ' with''
		$strStars =~ s/'/''/g;
		$strPreSort =~ s/'/''/g;
		$strFirstName =~ s/'/''/g;
		$strLastName =~ s/'/''/g;
		$strCompany =~ s/'/''/g;
		$strOffice =~ s/'/''/g;
		$strStreetNumber =~ s/'/''/g;
		$strStreetName =~ s/'/''/g;
		$strCity =~ s/'/''/g;
		$strState =~ s/'/''/g;
		$strZip =~ s/'/''/g;
		$strZipPlus4 =~ s/'/''/g;
		$strGiftGiver =~ s/'/''/g;
		$strZone =~ s/'/''/g;
		$strSort =~ s/'/''/g;
		
		$strSQL = ImportOutOfTownSQL($strStars,$strPreSort,$strExpirationDate,$strFirstName,$strLastName,$strCompany,$strOffice,$strStreetNumber,$strStreetName,$strCity,$strState,$strZip,$strZipPlus4,$strGiftGiver,$strRegCode,$strZone,$strSort,$intSubscriptionType,$intOutOfTownID);
		
		$intRows = $dbh->do($strSQL);
		$intLastInsertID = $dbh->{mysql_insertid};
		
		$strSQL = CreateSessionSQL($intLastInsertID);
		$dbh->do($strSQL);
		
		$intTotalSubscribers += $intRows;
	
	}
	$intCounter++;
	$intRegCounter++;

}

$dbh->disconnect();

print "Ending Script.....<br>";
print "Total Subscribers Imported: ".$intTotalSubscribers."<br>";









sub GetLastDayOfMonth {

	my ($strMonth) = @_;

	SWITCH: {
		if ($strMonth == '01') { return "31"; }
		if ($strMonth == '02') { return "28"; }
		if ($strMonth == '03') { return "31"; }
		if ($strMonth == '04') { return "30"; }
		if ($strMonth == '05') { return "31"; }
		if ($strMonth == '06') { return "30"; }
		if ($strMonth == '07') { return "31"; }
		if ($strMonth == '08') { return "31"; }
		if ($strMonth == '09') { return "30"; }
		if ($strMonth == '10') { return "31"; }
		if ($strMonth == '11') { return "30"; }
		if ($strMonth == '12') { return "31"; }
	}

}

sub dieNice {
	my ($strError) = @_;
	print $strError."<br>";
	die;
}