Get DC's
[DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().DomainControllers
([DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().DomainControllers).name

Search for object in AD
$Searcher = New-Object DirectoryServices.DirectorySearcher
$Searcher.Filter = '(&(objectCategory=person)(anr=gusev))'
$Searcher.SearchRoot = 'LDAP://OU=Laptops,OU=Computers,DC=contoso,DC=com'
$Searcher.FindAll()

