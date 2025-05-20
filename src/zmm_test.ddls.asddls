
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'test'
define view entity ZMM_TEST as select from I_Address_2
{
      key AddressID,
  key AddressPersonID,
  key AddressRepresentationCode,
  _PhoneNumber.InternationalPhoneNumber,
  _FaxNumber.InternationalFaxNumber,
  OrganizationName1,
      OrganizationName2,
      OrganizationName3,
      OrganizationName4,
      StreetName,
      StreetPrefixName1,
      StreetPrefixName2,
      StreetSuffixName1,
      StreetSuffixName2,
      CityName
}
