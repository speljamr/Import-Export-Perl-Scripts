#!/usr/bin/perl -w

use DBI;
use strict;

require('exportSQL.pl');

print "Content-type:text/html\n\n";

##################################################################
#
# Export the mailing list of subscribers for Akron Bugle
# Created 1/9/2003               
# Version 1.0
#
# Modification History
#
# 1/9/2003 -  Initial creation of file - TJF
#
# 7/29/2003 - Modified for new placement of REG code -TJF
#
# 1/24/2003 - Export path modified for new hosting environment -TJF
#
##################################################################

#print "Starting Script.....<br>";

my $strDSN = "DBI:mysql:bugle_AkronBugle:localhost";
my $strUsername = "bugle";
my $strPassword = "pap3r";

my $intTotalSubscribers = 0;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst,$currentYear,$currentDay,$currentMonth,$currentDateTime,$strOOTFileName,$strRuralFileName,$strCityFileName,$strFileName,$strStars,$strPreSort,$strExpiration,$strExpirationMonth,$strExpirationYear,$strRecordNum,$strFirstName,$strLastName,$strCompany,$strTitle,$strStreetNumber,$strStreetName,$strCity,$strState,$strZip,$strFaxPhone,$strCarPhone,$intSubscriptionType,$strSubType,$strRegCode,$strOffice,$strZone,$strSort,$strSQL,$Row);

my $RuralFilePath = "/home/virtual/site119/fst/var/www/html/exports/";
my $CityFilePath = "/home/virtual/site119/fst/var/www/html/exports/";
my $OutOfTownFilePath = "/home/virtual/site119/fst/var/www/html/exports/";

my $RuralID = 1;
my $CityID = 2;
my $OutOfTownID = 3;

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;

$currentYear = $year + 1900;
$currentDay = $mday;
$currentMonth = $mon + 1;
$currentDateTime = $currentMonth.$currentDay.$currentYear.$hour.$min.$sec;

my $dbh = DBI->connect($strDSN,$strUsername,$strPassword,{ RaiseError => 1 });

# Export Rural Routes File

$strRuralFileName = "RuralRoutes_".$currentDateTime.".dat";
$strFileName = $RuralFilePath."RuralRoutes_".$currentDateTime.".dat";

open (RURALEXPORT, ">$strFileName") or &dieNice ("Can't Open Rural Routes port");

$strSQL = &ExportSQL($RuralID);
my $sth = $dbh->prepare($strSQL);
$sth->execute();

print RURALEXPORT "STARS,Pre-Sort rt,REGISTRATION NO,Record #,First Name,Last Name,Company,Title,ST #,Address,City,State,Zip Code,Country,Home Phone,Work Phone,Car Phone,Fax Phone\n";

my $intRuralCount = 0;

while ($Row = $sth->fetchrow_hashref()) {

	$strRecordNum = "";

	$strStars = $Row->{'Stars'};
	$strPreSort = $Row->{'PreSortRT'};
	
	$intSubscriptionType = $Row->{'SubscriptionTypeIdent'};
	
	if ($intSubscriptionType eq 2) {
		$strRecordNum = "EXCH";
	} elsif ($intSubscriptionType eq 3) {
		$strRecordNum = "COMP";
	} elsif ($intSubscriptionType eq 4) {
		$strSubType = "ADV";
	} elsif ($intSubscriptionType eq 5) {
		$strSubType = "S";
	} elsif ($intSubscriptionType eq 6) {
		$strSubType = "G";
	} else {
		$strSubType = "";
	}
	
	$strExpiration = $Row->{'ExpirationDate'};
	$strExpirationMonth = substr($strExpiration,5,2);
	$strExpirationYear = substr($strExpiration,2,2);
	if ($strRecordNum eq "") {
		if ($strExpiration eq "1900-01-01") {
			$strRecordNum = "0000".$strSubType;
		} else {
			$strRecordNum = $strExpirationMonth.$strExpirationYear.$strSubType;
		}
	}
	
	$strFirstName = $Row->{'FirstName'};
	if ($Row->{'Salutation'} != "") {
		$strFirstName = $Row->{'Salutation'}." ".$strFirstName;
	}
	if ($Row->{'MiddleInitial'} != "") {
		$strFirstName .= " ".$Row->{'MiddleInitial'};
	}
	$strFirstName = uc($strFirstName);
	$strLastName = uc($Row->{'LastName'});
	$strCompany = uc($Row->{'CompanyName'});
	$strTitle = uc($Row->{'Title'});
	$strStreetNumber = uc($Row->{'StreetNumber'});
	$strStreetName = uc($Row->{'StreetName'});
	$strCity = uc($Row->{'City'});
	$strState = uc($Row->{'State'});
	$strZip = $Row->{'ZipCode'};
	if ($Row->{'ZipCodePlus4'} != "") {
		$strZip .= "-".$Row->{'ZipCodePlus4'};
	}
	$strFaxPhone = $Row->{'AddressSequence'};
	$strCarPhone = $Row->{'GiftGiver'};
	$strRegCode = $Row->{'RegistrationCode'};
	
	print RURALEXPORT $strStars.",".$strPreSort.",".$strRegCode.",".$strRecordNum.",".$strFirstName.",".$strLastName.",".$strCompany.",".$strTitle.",".$strStreetNumber.",".$strStreetName.",".$strCity.",".$strState.",".$strZip.",,,,".$strCarPhone.",".$strFaxPhone."\n";
	
	$intTotalSubscribers++;
	$intRuralCount++;
	
}

close (RURALEXPORT);

# Export City Routes File

$strCityFileName = "CityRoutes_".$currentDateTime.".dat";
$strFileName = $CityFilePath."CityRoutes_".$currentDateTime.".dat";

open (CITYEXPORT, ">$strFileName") or &dieNice ("Can't Open Rural Routes port");

$strSQL = &ExportSQL($CityID);
my $sth = $dbh->prepare($strSQL);
$sth->execute();

print CITYEXPORT "STARS,Pre-Sort rt,REGISTRATION NO,Record #,First Name,Last Name,Company,Title,ST #,Address,City,State,Zip Code,Country,Home Phone,Work Phone,Car Phone,Fax Phone\n";

my $intCityCount = 0;

while ($Row = $sth->fetchrow_hashref()) {

	$strRecordNum = "";

	$strStars = $Row->{'Stars'};
	$strPreSort = $Row->{'PreSortRT'};
	
	$intSubscriptionType = $Row->{'SubscriptionTypeIdent'};
	
	if ($intSubscriptionType eq 2) {
		$strRecordNum = "EXCH";
	} elsif ($intSubscriptionType eq 3) {
		$strRecordNum = "COMP";
	} elsif ($intSubscriptionType eq 4) {
		$strSubType = "ADV";
	} elsif ($intSubscriptionType eq 5) {
		$strSubType = "S";
	} elsif ($intSubscriptionType eq 6) {
		$strSubType = "G";
	} else {
		$strSubType = "";
	}
	
	$strExpiration = $Row->{'ExpirationDate'};
	$strExpirationMonth = substr($strExpiration,5,2);
	$strExpirationYear = substr($strExpiration,2,2);
	if ($strRecordNum eq "") {
		if ($strExpiration eq "1900-01-01") {
			$strRecordNum = "0000".$strSubType;
		} else {
			$strRecordNum = $strExpirationMonth.$strExpirationYear.$strSubType;
		}
	}
	
	$strFirstName = $Row->{'FirstName'};
	if ($Row->{'Salutation'} != "") {
		$strFirstName = $Row->{'Salutation'}." ".$strFirstName;
	}
	if ($Row->{'MiddleInitial'} != "") {
		$strFirstName .= " ".$Row->{'MiddleInitial'};
	}
	$strFirstName = uc($strFirstName);
	$strLastName = uc($Row->{'LastName'});
	$strCompany = uc($Row->{'CompanyName'});
	$strTitle = uc($Row->{'Title'});
	$strStreetNumber = uc($Row->{'StreetNumber'});
	$strStreetName = uc($Row->{'StreetName'});
	$strCity = uc($Row->{'City'});
	$strState = uc($Row->{'State'});
	$strZip = $Row->{'ZipCode'};
	if ($Row->{'ZipCodePlus4'} != "") {
		$strZip .= "-".$Row->{'ZipCodePlus4'};
	}
	$strFaxPhone = $Row->{'AddressSequence'};
	$strCarPhone = $Row->{'GiftGiver'};
	$strRegCode = $Row->{'RegistrationCode'};
	
	print CITYEXPORT $strStars.",".$strPreSort.",".$strRegCode.",".$strRecordNum.",".$strFirstName.",".$strLastName.",".$strCompany.",".$strTitle.",".$strStreetNumber.",".$strStreetName.",".$strCity.",".$strState.",".$strZip.",,,,".$strCarPhone.",".$strFaxPhone."\n";
	
	$intTotalSubscribers++;
	$intCityCount++;
	
}

close (CITYEXPORT);

# Export Out Of Town Routes File

$strOOTFileName = "OutOfTownRoutes_".$currentDateTime.".dat";
$strFileName = $OutOfTownFilePath."OutOfTownRoutes_".$currentDateTime.".dat";

open (OUTOFTOWNIMPORT, ">$strFileName") or &dieNice ("Can't Open Rural Routes port");

$strSQL = &ExportSQL($OutOfTownID);
my $sth = $dbh->prepare($strSQL);
$sth->execute();

print OUTOFTOWNIMPORT "STARS,Pre-Sort rt,REGISTRATION NO,Record #,FIRST NAME,LAST NAME,COMPANY,OFFICE,ST#,ADDRESS,CITY,ST,ZIP CODE,Country,Home Phone,Work Phone,Car Phone,Fax Phone,ZONE,SORT\n";

my $intOutOfTownCount = 0;

while ($Row = $sth->fetchrow_hashref()) {

	$strRecordNum = "";

	$strStars = $Row->{'Stars'};
	$strPreSort = $Row->{'PreSortRT'};
	
	$intSubscriptionType = $Row->{'SubscriptionTypeIdent'};
	
	if ($intSubscriptionType eq 2) {
		$strRecordNum = "EXCH";
	} elsif ($intSubscriptionType eq 3) {
		$strRecordNum = "COMP";
	} elsif ($intSubscriptionType eq 4) {
		$strSubType = "ADV";
	} elsif ($intSubscriptionType eq 5) {
		$strSubType = "S";
	} elsif ($intSubscriptionType eq 6) {
		$strSubType = "G";
	} else {
		$strSubType = "";
	}
	
	$strExpiration = $Row->{'ExpirationDate'};
	$strExpirationMonth = substr($strExpiration,5,2);
	$strExpirationYear = substr($strExpiration,2,2);
	if ($strRecordNum eq "") {
		if ($strExpiration eq "1900-01-01") {
			$strRecordNum = "0000".$strSubType;
		} else {
			$strRecordNum = $strExpirationMonth.$strExpirationYear.$strSubType;
		}
	}
	
	$strFirstName = $Row->{'FirstName'};
	if ($Row->{'Salutation'} != "") {
		$strFirstName = $Row->{'Salutation'}." ".$strFirstName;
	}
	if ($Row->{'MiddleInitial'} != "") {
		$strFirstName .= " ".$Row->{'MiddleInitial'};
	}
	$strFirstName = uc($strFirstName);
	$strLastName = uc($Row->{'LastName'});
	$strCompany = uc($Row->{'CompanyName'});
	$strOffice = uc($Row->{'Office'});
	$strStreetNumber = uc($Row->{'StreetNumber'});
	$strStreetName = uc($Row->{'StreetName'});
	$strCity = uc($Row->{'City'});
	$strState = uc($Row->{'State'});
	$strZip = $Row->{'ZipCode'};
	if ($Row->{'ZipCodePlus4'} != "") {
		$strZip .= "-".$Row->{'ZipCodePlus4'};
	}
	$strCarPhone = $Row->{'GiftGiver'};
	$strRegCode = $Row->{'RegistrationCode'};
	$strZone = $Row->{'Zone'};
	$strSort = $Row->{'Sort'};
	
	print OUTOFTOWNIMPORT $strStars.",".$strPreSort.",".$strRegCode.",".$strRecordNum.",".$strFirstName.",".$strLastName.",".$strCompany.",".$strOffice.",".$strStreetNumber.",".$strStreetName.",".$strCity.",".$strState.",".$strZip.",,,,".$strCarPhone.",,".$strZone.",".$strSort."\n";
	
	$intTotalSubscribers++;
	$intOutOfTownCount++;
	
}

close (OUTOFTOWNIMPORT);

$dbh->disconnect();

#print "Ending Script.....<br>";
#print "Total Subscribers Exported: ".$intTotalSubscribers."<br>";

print "<p class=\"nonstory\">The following mailing lists have been exported from the Akron Bugle subscriber database:</p>\n";
print "<table cellpadding=\"4\" cellspacing=\"0\" class=\"data\">\n";
print "  <tr>\n";
print "    <th align=\"left\" valign=\"top\">Mail Route</th>\n";
print "    <th align=\"left\" valign=\"top\">Subscribers Exported</th>\n";
print "    <th align=\"left\" valign=\"top\">Download File</th>\n";
print "  </tr>\n";
print "  <tr>\n";
print "    <td align=\"left\" valign=\"middle\">Rural</td>\n";
print "    <td align=\"right\" valign=\"middle\">$intRuralCount</td>\n";
print "    <td align=\"left\" valign=\"middle\"><a href=\"/exports/$strRuralFileName\">$strRuralFileName</a></td>\n";
print "  </tr>\n";
print "  <tr>\n";
print "    <td align=\"left\" valign=\"middle\">City</td>\n";
print "    <td align=\"right\" valign=\"middle\">$intCityCount</td>\n";
print "    <td align=\"left\" valign=\"middle\"><a href=\"/exports/$strCityFileName\">$strCityFileName</a></td>\n";
print "  </tr>\n";
print "  <tr>\n";
print "    <td align=\"left\" valign=\"middle\">Out Of Town</td>\n";
print "    <td align=\"right\" valign=\"middle\">$intOutOfTownCount</td>\n";
print "    <td align=\"left\" valign=\"middle\"><a href=\"/exports/$strOOTFileName\">$strOOTFileName</a></td>\n";
print "  </tr>\n";
print "  <tr>\n";
print "    <th align=\"right\" valign=\"middle\" colspan=\"3\">Total Subscribers Exported:&nbsp;$intTotalSubscribers</th>\n";
print "  </tr>\n";
print "</table>\n";
print "<p class=\"nonstory\">To download the list simply right click on the file and choose 'Save File As' or 'Save Target As.' The exact wording may vary depending on your browser.</p>\n";





sub dieNice {
	my ($strError) = @_;
	print $strError."<br>";
	die;
}