#Import-Module C:\ScriptingSpace\ShareDriveAccess\Form.ps1
Add-Type -AssemblyName PresentationFramework

# Link :  https://www.windows-noob.com/forums/topic/15055-script-radio-button-powershell-in-osd/
function Domain-Form{[void] [system.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [system.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
# Set the size of your form
$Form = New-Object System.Windows.Forms.Form
$Form.width = 500
$Form.height = 500
$Form.Text = ”Share Drive Access"
# Set the font of the text to be used within the form
$Font = New-Object System.Drawing.Font("Consolas",12)
$Form.Font = $Font
# Create a group that will contain your Text Box.
$MyGroupBox1 = New-Object System.Windows.Forms.GroupBox
$MyGroupBox1.Location = '40,10'
$MyGroupBox1.size = '400,80'
$MyGroupBox1.text = "UNID (sAMAccountName):"
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = '10,30'
$textBox1.Size = '380,80'
$MyGroupBox1.Controls.Add($textBox1)
# Create a group that will contain your Text Box.
$MyGroupBox2 = New-Object System.Windows.Forms.GroupBox
$MyGroupBox2.Location = '40,110'
$MyGroupBox2.size = '400,80'
$MyGroupBox2.text = "Type the Share Drive:"
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = '10,30'
$textBox2.Size = '380,80'
$MyGroupBox2.Controls.Add($textBox2)
# Create a group that will contain your radio buttons
$MyGroupBox = New-Object System.Windows.Forms.GroupBox
$MyGroupBox.Location = '40,210'
$MyGroupBox.size = '400,150'
$MyGroupBox.text = "Select Type of Access:"
# Create the collection of radio buttons
$RadioButton1 = New-Object System.Windows.Forms.RadioButton
$RadioButton1.Location = '20,40'
$RadioButton1.size = '350,20'
$RadioButton1.Checked = $false
$RadioButton1.Text = "FullControl"
$RadioButton2 = New-Object System.Windows.Forms.RadioButton
$RadioButton2.Location = '20,70'
$RadioButton2.size = '350,20'
$RadioButton2.Checked = $true
$RadioButton2.Text = "Modify"
$RadioButton3 = New-Object System.Windows.Forms.RadioButton
$RadioButton3.Location = '20,100'
$RadioButton3.size = '350,20'
$RadioButton3.Checked = $false
$RadioButton3.Text = "ReadAndExecute"
# Add an OK button
# Thanks to J.Vierra for simplifing the use of buttons in forms
$OKButton = new-object System.Windows.Forms.Button
$OKButton.Location = '130,400'
$OKButton.Size = '100,40'
$OKButton.Text = 'OK'
$OKButton.DialogResult=[system.Windows.Forms.DialogResult]::OK
#Add a cancel button
$CancelButton = new-object System.Windows.Forms.Button
$CancelButton.Location = '255,400'
$CancelButton.Size = '100,40'
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult=[system.Windows.Forms.DialogResult]::Cancel
# Add all the Form controls on one line
$form.Controls.AddRange(@($MyGroupBox,$OKButton,$CancelButton,$MyGroupBox1,$MyGroupBox2))
# Add all the GroupBox controls on one line
$MyGroupBox.Controls.AddRange(@($Radiobutton1,$RadioButton2,$RadioButton3))
# Assign the Accept and Cancel options in the form to the corresponding buttons
$form.AcceptButton = $OKButton
$form.CancelButton = $CancelButton
# Activate the form
$form.Add_Shown({$form.Activate()})
$Form.Topmost = $True
$Form.StartPosition = "CenterScreen"
# Get the results from the button click
$dialogResult = $form.ShowDialog()

    
# If the OK button is selected
if ($dialogResult -eq "OK"){
    $t1 = $textBox1.Text
    $t2 = $textBox2.Text
# Check the current state of each radio button and respond accordingly
if ($RadioButton1.Checked){
    Write-Warning "FullControl $t1 $t2"
    return "FullControl",$t1,$t2
    
}
elseif ($RadioButton2.Checked){
    Write-Warning "Modify"
    return "Modify",$t1,$t2
    
}
elseif ($RadioButton3.Checked){
    Write-Warning "ReadAndExecute"
    return "ReadAndExecute",$t1,$t2
}
$Form.Dispose()
}
}

Function Grant-Access{
$Acl = (Get-Item $Path).GetAccessControl('Access')
$r = New-Object System.Security.AccessControl.FileSystemAccessRule ("CHEMTURA\$user",$type,"Allow")
Try{
    $acl.SetAccessRule($r)
    Set-Acl -Path $Path -AclObject $acl
}Catch{Write-Warning "Error while Setting the access!"}

Get-Acl -Path $path | select AccessToString | %{$_.AccessToString.split("`n")}
}

Function Create-Report{
    

}




$arry = Domain-Form

# unid = "LVKST"
$user = $arry[1]
# path = "C:\ScriptingSpace"
$Path = $arry[2]
# Type can be ("FullControl","Modify","ReadAndExecute")
$type = $arry[0]
if($user -eq "" -or $Path -eq ""){[System.Windows.MessageBox]::show("UNID or Path is Blank!")}
else{[System.Windows.MessageBox]::show("UNID: $user, Path: $Path, Type: $type")}

#Grant-Access
