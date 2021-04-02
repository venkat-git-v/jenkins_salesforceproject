@RestResource(urlMapping='/showAccounts/*')

global class checkAccount
{
@HttpGet
global static LIST<Account> getAccount()
{
List<Account> lst;


try
{
lst=[select name,phone from Account limit 2];
return lst;
}
catch(Exception ex)
{
system.debug('Error' +ex.getMessage());
}
return lst;
}

}