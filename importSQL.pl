#!/usr/bin/perl -w

sub ImportRuralSQL {

	my ($strStars,$strPreSort,$strExpirationDate,$strFirstName,$strLastName,$strCompany,$strTitle,$strStreetNumber,$strStreetName,$strCity,$strState,$strZip,$strZipPlus4,$strGiftGiver,$strAddressSequence,$strRegCode,$intSubscriptionType,$intMailRouteID) = @_;

	my $strSQL = qq|
INSERT INTO
	subscribers
	(FirstName,
	LastName,
	SignupDate,
	Active,
	CompanyName,
	City,
	State,
	ZipCode,
	RegistrationCode,
	ZipCodePlus4,
	PreSortRT,
	Stars,
	ExpirationDate,
	GiftGiver,
	AddressSequence,
	StreetNumber ,
	StreetName,
	SubscriptionTypeIdent,
	MailRouteIdent)
VALUES
	('$strFirstName',
	'$strLastName',
	NOW(),
	'N',
	'$strCompany',
	'$strCity',
	'$strState',
	'$strZip',
	'$strRegCode',
	'$strZipPlus4',
	'$strPreSort',
	'$strStars',
	'$strExpirationDate',
	'$strGiftGiver',
	'$strAddressSequence',
	'$strStreetNumber',
	'$strStreetName',
	$intSubscriptionType,
	$intMailRouteID)
	|;
	#print "<pre>$strSQL</pre>";
	return $strSQL;

}


sub ImportOutOfTownSQL {

	my ($strStars,$strPreSort,$strExpirationDate,$strFirstName,$strLastName,$strCompany,$strOffice,$strStreetNumber,$strStreetName,$strCity,$strState,$strZip,$strZipPlus4,$strGiftGiver,$strRegCode,$strZone,$strSort,$intSubscriptionType,$intMailRouteID) = @_;

	my $strSQL = qq|
INSERT INTO
	subscribers
	(FirstName,
	LastName,
	SignupDate,
	Active,
	CompanyName,
	City,
	State,
	ZipCode,
	RegistrationCode,
	ZipCodePlus4,
	PreSortRT,
	Stars,
	ExpirationDate,
	GiftGiver,
	Office,
	StreetNumber,
	StreetName,
	Zone,
	Sort,
	SubscriptionTypeIdent,
	MailRouteIdent)
VALUES
	('$strFirstName',
	'$strLastName',
	NOW(),
	'N',
	'$strCompany',
	'$strCity',
	'$strState',
	'$strZip',
	'$strRegCode',
	'$strZipPlus4',
	'$strPreSort',
	'$strStars',
	'$strExpirationDate',
	'$strGiftGiver',
	'$strOffice',
	'$strStreetNumber',
	'$strStreetName',
	'$strZone',
	'$strSort',
	$intSubscriptionType,
	$intMailRouteID)
	|;
	#print $enumGift.$enumAdvertiser.$enumSample."<br>";
	#print "<pre>$strSQL</pre>";
	return $strSQL;

}


sub CreateSessionSQL {

	my ($intUserIdent) = @_;
	
	$strSQL = qq|
INSERT INTO
	subscribersessions
	(InSession,
	UserID)
VALUES
	('N',
	$intUserIdent)
	|;

}

1;