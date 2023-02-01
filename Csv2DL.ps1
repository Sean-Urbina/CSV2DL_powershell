#This script connects to the clients Exchange Online and adds distribtuion list memembers from a csv for bulk jobs

#CSV FORMAT

#EmailAddress
#user1@domain.com
#user2@domain.com
#user3@domain.com

#Connect exchange with modern login
Connect-ExchangeOnline

#Get DL name, import CSV, create userlist
$DLName = Read-Host -Prompt "Enter name of distribution List: " 
$CSVFile = Read-Host -Prompt "Enter path to CSV file(be exact): " 
$UserList = Import-Csv $CSVFile

#Crawls the csv and adds each email to the DL
Foreach ($User in $UserList) {
  Write-Progress -Activity 'Adding $User.EmailAddress to group...'
  Add-DistributionGroupMember -Identity $DLName -Member $User.EmailAddress
  If($?)
  {
  Write-Host $User.EmailAddress Successfully added -ForegroundColor Green
  }
  Else
  {
  Write-Host $User.EmailAddress Error Occurred -ForegroundColor Red
  }
}

#Print members
Write-Host "Members of $DLName"
Get-DistributionGroupMember -Identity $DLName