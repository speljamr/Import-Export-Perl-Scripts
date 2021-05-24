#!/usr/bin/perl -w

sub ExportSQL {

	my ($intMailRoute) = @_;

	my $strSQL = qq|
SELECT
	s.FirstName,
	s.LastName,
	s.MiddleInitial,
	s.Salutation,
	s.CompanyName,
	s.City,
	s.State,
	s.ZipCode,
	s.RegistrationCode,
	s.ZipCodePlus4,
	s.PreSortRT,
	s.Stars,
	s.ExpirationDate,
	s.GiftGiver,
	s.AddressSequence,
	s.Office,
	s.StreetNumber,
	s.StreetName,
	s.Zone,
	s.Sort,
	s.SubscriptionTypeIdent,
	s.Title
FROM
	subscribers s
WHERE
	MailRouteIdent = $intMailRoute
	AND SubscriptionTypeIdent != 1
	AND SubscriptionTypeIdent != 8
	|;
	#print "<pre>$strSQL</pre>";
	return $strSQL;

}

1;