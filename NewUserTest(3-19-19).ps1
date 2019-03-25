#start PSsession to allow script to run in active directory without having to install AD on each computer.
$s = New-Pssession -computerName 'ahdc01'
Invoke-Command -session $s -ScriptBlock{
    Import-module ActiveDirectory
}
Import-PSSession -session $s -Module ActiveDirectory -allowclobber

#may need to create AD login with admin credentials for the DC that we set this up for and put them in for the PS session

cls


$ErrorActionPreference = 'silentlycontinue'
#Disable this to see error messages


#Function for the plant selection menu

function plant-selection{ 
    param (
        [string]$Title='New User Plant Selection'
        )
    cls
    write-host "============$Title==============="
    Write-host "Please enter your plant"

    write-host "1: Press '1' for Auburn Hills"
    write-host "2. Press '2' for Austin"
    write-host "3. Press '3' for Delta"
    write-host "4. Press '4' for Delta - Tooling"
    write-host "5. Press '5' for Jackson"
    write-host "6. Press '6' for Kansas City"
    write-host "7. Press '7' for Merrill"
    write-host "8. Press '8' for Orion"
    write-host "9. Press '9' for Port Huron"
    write-host "10. Press '10' for Sterling Heights"
    write-host "11. Press '11' for Tech Center"
    write-host "12. Press '12' for Troy"
    write-host "13. Press '13' for Utica"
    write-host "14. Press '14' for Westland"
    write-host "15. Press 'U' for unknown"
    write-host "Q. Press 'Q' to quit without saving changes"
    }


function confirm-details-menu{
   
   write-host "1. Press '1' to change the name"
   write-host "2. Press '2' to change the password"
   write-host "3. Press '3' to change the need for email"
   write-host "4. Press '4' to change scannerID needs"
   write-host "5. Press '5' to change the assigned plant"
}

$nameconfirmation = "n"

While ($nameconfirmation -ne 'y'){
$first = Read-Host 'What is the first name'
$last = Read-Host 'What is the last name'
##confirm names! If not, redo.


$secondfirst = Read-Host 'Please re-enter the first name'
$secondlast = Read-Host 'Please re-enter the last name'
while ($secondfirst -ne $first){
    $first = read-host 'The first names do not match. Please re-enter the first name'
    $secondfirst = read-host 'Please retype the first name to reconfirm'
    }
while ($secondlast -ne $last){
    $last = read-host  'The last names do not match. Please re-enter the last name'
    $secondlast = read-host 'Please retype the last name to reconfirm'
    
    }

$fullname = "$first $last"


$nameconfirmation = Read-Host 'The name is '$fullname', correct? [y/n]'
if ($nameconfirmation -ne 'y') {
    write-host "Please re-enter the information"
}
}

$username = "$first.$last"


#test for duplicate usernames
$test = Get-ADuser -Identity $username | Select-Object -ExpandProperty samaccountname
## Will pop an error if it cannot find. Hence why we have silently continue at the beginning


$number=0
while ($test -ne $null) {
     if ($test -ne $null) {
    $number++
    }
    $updatedusername = read-host "It seems that there is already a username of '$username'. Would you like to try '$first.$last$number'? [y/n]"
   
   
    

    while (($updatedusername -ne 'y') -and ($updatedusername -ne 'n')) {
    $updatedusername = read-host "You entered an invalid character. Please enter y or n"
    }
    if ($updatedusername -eq 'y') {
        $username = "$first.$last$number"
        
        }
    if ($updatedusername -eq 'n') {
       $username = read-host "What would you like the username to be then?"

    }
 

    $test = Get-ADuser -Identity $username | Select-Object -ExpandProperty samaccountname
     $last = "$last$number"
    $fullname = "$first $last"
    
}


$passConfirm = "n"

While ($passConfirm -ne "y"){
$firstpass = Read-Host 'What would you like the password to be? It will still ask to be reset on its first entry'
#This can be disabled or we could come up with a default password that we change when we enable the account
$secondpass = Read-Host 'Please re-enter the password to confirm'


while ($firstpass -ne $secondpass){
$firstpass = Read-Host 'Your passwords typed do not match. Please re-type your password'
$secondpass = Read-Host 'Please type the password again to confirm'


}


$passConfirm = Read-host 'The password will be set to '$firstpass'. Is that correct?[y/n]'
while (($passConfirm -ne 'y') -and ($passConfirm -ne 'n')){
$passConfirm = Read-host 'You entered an invalid character. Please enter y or n'
}

}
cls


$emailconfirm = 'e'
$emailconfirm = Read-Host 'Does the user require an email account? [y/n]'
while (($emailconfirm -ne 'y') -and ($emailconfirm -ne 'n')) {
$emailconfirm = Read-Host 'You entered an invalid character. Please enter y or n'
}
if ($emailconfirm -eq 'y') {
  $email = "$username@usfarathane.com"
}





$department = Read-Host 'What department?'
$job = Read-Host 'What is the employees job?'

##scanner ID will hopefully populate in the ticket created to let us know to create it.
$scannerID = Read-Host 'Will the employee require a scannerID?'

$personaldrive = 'e'
$personaldrive = Read-Host 'Will the employee need an N: drive? [y/n]'
#check to make sure they entered y or n
while (($personaldrive -ne 'y') -and ($personaldrive -ne 'n')){
 $personaldrive = Read-Host 'You entered an invalid character. Please enter y or n'
}







plant-selection
$plantselect = Read-Host "Please make a selection"
switch ($plantselect) {
    '1' {
    $plant = "Auburn Hills"
    if ($personaldrive -eq 'y') {
       $profilepath = "\\ahfile\users$\$username"
        }
    }
    '2' {
    $plant = "Austin"
     if ($personaldrive -eq 'y') {
        $profilepath = "\\aufile\users$\$username"
        }
    }
    '3' {
    $plant = "Delta"
     if ($personaldrive -eq 'y') {
        $profilepath = "\\dtfile\users$\$username"
        }
    }
    '5'{
    $plant = "Jackson"
     if ($personaldrive -eq 'y') {
        $profilepath = "\\jafile\users$\$username"
        }
    }
    '6' {
    $plant = "Kansas City"
     if ($personaldrive -eq 'y') {
        $profilepath = "\\kcfile\users$\$username"
        }
    }
    '7' {
    $plant = "Merrill"
     if ($personaldrive -eq 'y') {
        $profilepath = "\\mpfile\users$\$username"
        }
    }
    '8' {
    $plant = "Orion"
     if ($personaldrive -eq 'y') {
        $profilepath = "\\alfile\users$\$username"
        }        
    }
    '9' {
    $plant = "Port Huron"
     if ($personaldrive -eq 'y') {
       # $profilepath = "\\phfile\users$\$username"
       write-host "Please manually create the home drive"
        }
    }
    '10' {
    $plant = "Sterling Heights"
         if ($personaldrive -eq 'y') {
            $profilepath = "\\shfile2\users$\$username"
            }
    }
    '11' {
    $plant = "Tech Center"
         if ($personaldrive -eq 'y') {
            $profilepath = "\\ahfile\users$\$username"
            }
    }
    '12' {
    $plant = "Troy"
         if ($personaldrive -eq 'y') {
            $profilepath = "\\mhfile\users$\$username"
            }
    }
    '13' {
    $plant = "Utica"
        if ($personaldrive -eq 'y') {
            $profilepath = "\\utfile\users$\$username"
            }
    }
    '14' {
    $plant = "Westland"
        if ($personaldrive -eq 'y') {
            $profilepath = "\\plfile\users$\$username"
            }
    }
    '4' {
    $plant = "Delta Tooling"
     if ($personaldrive -eq 'y') {
        $profilepath = "\\dtfile\users$\$username"
        }
    if ($emailconfirm -eq 'y') {
        $email = "$username@deltatechgroup.com"
    }
        

    }
    'U' {
    $plant = "Kiosk"
    #Will require more information from HR. Limits user until we place them
    #in correct OU
        if ($personaldrive -eq 'y') {
            write-host "In the notes, please include where the user will be spending the majority of their time"
            
            }
    }
    'Q' {
    remove-pssession -session $s
    exit
    }

}




##add a confirm details set here. Menu similar to the plant selection menu. If they choose to reset something, go back to that function

$confirmdetails = 'e'
while ($confirmdetails -ne 'y'){
cls
write-host "Please confirm this information. If any is incorrect, please select the correct option."
Write-host "Full name: '$fullname'"
Write-host "Username: '$username'"
Write-Host "Password: '$firstpass'"
Write-Host "Plant: '$plant'"
if ($emailconfirm -eq 'y') {
    Write-host "Email: '$email'"
    }
if ($emailconfirm -eq 'n'){
    write-output "No email required"
    }
Write-host "ScannerID info to IT(Does not create ScannerID): '$scannerID'"



$confirmdetails = read-host 'Are these details correct? Press 'y' for yes, 'n' for no, or 'q' to quit'

while (($confirmdetails -ne 'y') -and ($confirmdetails -ne 'n')-and ($confirmdetails -ne 'q')){
$confirmdetails = read-host 'You entered an invalid character. Please press 'y' to confirm or 'n' to change them.'
}

if ($confirmdetails -eq 'q'){
remove-pssession -session $s
exit
}

if ($confirmdetails -eq 'n'){


confirm-details-menu
$changeselect = read-host "Please make a selection"

switch($changeselect) {
    '1'{
     $nameconfirmation = "n"

     While ($nameconfirmation -ne 'y'){
     $first = Read-Host 'What is the first name'
     $last = Read-Host 'What is the last name'
                 ##confirm names! If not, redo.


                $secondfirst = Read-Host 'Please re-enter the first name'
                $secondlast = Read-Host 'Please re-enter the last name'
                while ($secondfirst -ne $first){
                    $first = read-host 'The first names do not match. Please re-enter the first name'
                    $secondfirst = read-host 'Please retype the first name to reconfirm'
                }
                while ($secondlast -ne $last){
                    $last = read-host  'The last names do not match. Please re-enter the last name'
                    $secondlast = read-host 'Please retype the last name to reconfirm'
                }

            $fullname = "$first $last"


            $nameconfirmation = Read-Host 'The name is '$fullname', correct? [y/n]'
            if ($nameconfirmation -ne 'y') {
                write-host "Please re-enter the information"
            }
           }

            $username = "$first.$last"
            #test for duplicate usernames
            $test = Get-ADuser -Identity $username | Select-Object -ExpandProperty samaccountname
            ## Will pop an error if it cannot find. Hence why we have silently continue at the beginning


            $number=0
            while ($test -ne $null) {
                if ($test -ne $null) {
                    $number++
                    }
            $updatedusername = read-host "It seems that there is already a username of '$username'. Would you like to try '$first.$last$number'? [y/n]"
  

            while (($updatedusername -ne 'y') -and ($updatedusername -ne 'n')) {
                $updatedusername = read-host "You entered an invalid character. Please enter y or n"
            }
            if ($updatedusername -eq 'y') {
                $username = "$first.$last$number"
        
            }
            if ($updatedusername -eq 'n') {
            $username = read-host "What would you like the username to be then?"

            }
 

            $test = Get-ADuser -Identity $username | Select-Object -ExpandProperty samaccountname
            $last = "$last$number"
            $fullname = "$first $last"
            if ($emailconfirm -eq 'y') {
                $email = "$username@usfarathane.com"
            }
            }
      }   
    '2'{
        $passConfirm = "n"

        While ($passConfirm -ne "y"){
        $firstpass = Read-Host 'What would you like the password to be? It will still ask to be reset on its first entry'
        #This can be disabled or we could come up with a default password that we change when we enable the account
        $secondpass = Read-Host 'Please re-enter the password to confirm'
        
        while ($firstpass -ne $secondpass){
        $firstpass = Read-Host 'Your passwords typed do not match. Please re-type your password'
        $secondpass = Read-Host 'Please type the password again to confirm'
        }
        
        $passConfirm = Read-host 'The password will be set to '$firstpass'. Is that correct?[y/n]'
        while (($passConfirm -ne 'y') -and ($passConfirm -ne 'n')){
        $passConfirm = Read-host 'You entered an invalid character. Please enter y or n'
        }
        }

    }
    '3'{
        $emailconfirm = 'e'
        $emailconfirm = Read-Host 'Does the user require an email account? [y/n]'
        while (($emailconfirm -ne 'y') -and ($emailconfirm -ne 'n')) {
           $emailconfirm = Read-Host 'You entered an invalid character. Please enter y or n'
        }
        if ($emailconfirm -eq 'y') {
            $email = "$username@usfarathane.com"
        }
    }
    '4'{
        $scannerID = Read-Host 'Will the employee require a scannerID?'
    }
    '5'{
        plant-selection
        $plantselect = Read-Host "Please make a selection"
        switch ($plantselect) {
            '1' {
            $plant = "Auburn Hills"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\ahfile\users$\$username"
            }
            }
            '2' {
            $plant = "Austin"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\aufile\users$\$username"
            }
            }
            '3' {
            $plant = "Delta"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\dtfile\users$\$username"
            }
            }
            '5'{
            $plant = "Jackson"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\jafile\users$\$username"
            }
            }
            '6' {
            $plant = "Kansas City"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\kcfile\users$\$username"
            }
            }
            '7' {
            $plant = "Merrill"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\mpfile\users$\$username"
            }
            }
            '8' {
            $plant = "Orion"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\alfile\users$\$username"
            }        
            }
            '9' {
            $plant = "Port Huron"
            if ($personaldrive -eq 'y') {
            # $profilepath = "\\phfile\users$\$username"
            write-host "Please manually create the home drive"
            }
            }
            '10' {
            $plant = "Sterling Heights"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\shfile2\users$\$username"
            }
            }
            '11' {
            $plant = "Tech Center"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\ahfile\users$\$username"
            }
            }
            '12' {
            $plant = "Troy"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\mhfile\users$\$username"
            }
            }
            '13' {
            $plant = "Utica"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\utfile\users$\$username"
            }
            }
            '14' {
            $plant = "Westland"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\plfile\users$\$username"
            }
            }
            '4' {
            $plant = "Delta Tooling"
            if ($personaldrive -eq 'y') {
            $profilepath = "\\dtfile\users$\$username"
            }
            if ($emailconfirm -eq 'y') {
            $email = "$username@deltatechgroup.com"
            }
            }
            'U' {
            $plant = "Kiosk"
            #Will require more information from HR. Limits user until we place them
            #in correct OU
            if ($personaldrive -eq 'y') {
            write-host "In the notes, please include where the user will be spending the majority of their time"
            pause
            }
            }
            'Q' {
            remove-pssession -session $s
            exit
            }

        }

    }
    'q'{
        remove-pssession -session $s
        exit
        }
}
}

}



New-ADUser -GivenName "$first" `
            -surname "$last" `
            -Name "$fullname" `
            -AccountPassword (ConvertTo-SecureString -string "$firstpass" -AsPlainText -Force) `
            -Department "$department" `
            -UserPrincipalName "$username@usfarathane.com" `
            -SamAccountName "$username" `
            -Title "$job" `
            -DisplayName "$last, $first" `
            -Description "$job" `
            -Office "$plant" `
           #-PassThru
           #-Path "OU=users, DC=usfarathane, DC=com" `
           #change the path for when we have a new OU for new users


Set-ADUser -Identity $username -ChangePasswordAtLogon $true

Add-ADGroupMember -Identity "PARTSUsers" -Members $username
if ($personaldrive = 'y') {
    set-aduser -identity $username -HomeDirectory $profilepath -homedrive N
    }

if ($emailconfirm -eq 'y'){
set-AdUser $username -replace @{
                mail=$email;
                targetAddress="smtp:$email";
                proxyAddresses="SMTP:$email";
                }
}
cls
write-host "Here is your new user information"
Write-host "Full name: '$fullname'"
Write-host "Username: '$username'"
Write-Host "Password: '$firstpass'"
Write-Host "Plant: '$plant'"
if ($emailconfirm -eq 'y') {
    Write-host "Email: '$email'"
    }
Write-host "ScannerID info to IT(Does not create ScannerID): '$scannerID'"
#Write-Output "Personal Drive: $personaldrive"
#Hopefully will autopopulate in ticket notes for us to create scannerID

$HRnotes = Read-Host 'Notes: Please provide someones access we should mirror, what accesses they should have, or any other pertinent notes to include with your ticket.'
#If we could get this to input a help ticket automatically, that would be fantastic.
#Hopefully will have the finall user information loaded in that ticket as well, so we have the notes on scannerID and user notes.
#The AD account will start out disabled anyways and will need to be added to the rest of the appropriate groups.

remove-pssession -session $s