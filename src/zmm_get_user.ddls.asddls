@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get User'
define root view entity ZMM_GET_USER as select from I_User
{
    key UserID,
    UserDescription,
    IsTechnicalUser
}
