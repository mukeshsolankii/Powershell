#Import-Module C:\ScriptingSpace\ShareDriveAccess\Form.ps1
Add-Type -AssemblyName PresentationFramework

# Link :  https://www.windows-noob.com/forums/topic/15055-script-radio-button-powershell-in-osd/
function Domain-Form{[void] [system.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [system.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
# Set the size of your form
$Form = New-Object System.Windows.Forms.Form
$Form.width = 500
$Form.height = 450
$Form.Text = ”Share Drive Access Tool"
# Set the font of the text to be used within the form
$Font = New-Object System.Drawing.Font("Corbel",12)
$Form.Font = $Font
# Create a group that will contain your Text Box (UNID).
$MyGroupBox1 = New-Object System.Windows.Forms.GroupBox
$MyGroupBox1.Location = '250,140'
$MyGroupBox1.size = '190,70'
$MyGroupBox1.text = "UNID:"
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = '10,30'
$textBox1.Size = '170,80'
$MyGroupBox1.Controls.Add($textBox1)
# Create a group that will contain your Text Box (Share drive).
$MyGroupBox2 = New-Object System.Windows.Forms.GroupBox
$MyGroupBox2.Location = '40,40'
$MyGroupBox2.size = '400,80'
$MyGroupBox2.text = "Enter Share Drive Path:"
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = '10,30'
$textBox2.Size = '380,80'
$MyGroupBox2.Controls.Add($textBox2)
# Create a group that will contain your Text Box (Task number).
$MyGroupBox3 = New-Object System.Windows.Forms.GroupBox
$MyGroupBox3.Location = '250,230'
$MyGroupBox3.size = '190,70'
$MyGroupBox3.text = "Enter Task Number:"
$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Location = '10,30'
$textBox3.Size = '170,80'
$MyGroupBox3.Controls.Add($textBox3)
# Create a group that will contain your radio buttons
$MyGroupBox = New-Object System.Windows.Forms.GroupBox
$MyGroupBox.Location = '40,140'
$MyGroupBox.size = '200,160'
$MyGroupBox.text = "Select Access Type:"
# Create the collection of radio buttons
$RadioButton1 = New-Object System.Windows.Forms.RadioButton
$RadioButton1.Location = '20,50'
$RadioButton1.size = '150,20'
$RadioButton1.Checked = $false
$RadioButton1.Text = "Full Access"
$RadioButton2 = New-Object System.Windows.Forms.RadioButton
$RadioButton2.Location = '20,80'
$RadioButton2.size = '150,20'
$RadioButton2.Checked = $true
$RadioButton2.Text = "Modify"
$RadioButton3 = New-Object System.Windows.Forms.RadioButton
$RadioButton3.Location = '20,110'
$RadioButton3.size = '150,20'
$RadioButton3.Checked = $false
$RadioButton3.Text = "Read Only"
# Add an OK button
# Thanks to J.Vierra for simplifing the use of buttons in forms
$OKButton = new-object System.Windows.Forms.Button
$OKButton.Location = '130,330'
$OKButton.Size = '100,40'
$OKButton.Text = 'OK'
$OKButton.BackColor = '#0095ff'
$OKButton.ForeColor = 'white'
$OKButton.DialogResult=[system.Windows.Forms.DialogResult]::OK
#Add a cancel button
$CancelButton = new-object System.Windows.Forms.Button
$CancelButton.Location = '255,330'
$CancelButton.Size = '100,40'
$CancelButton.Text = "Cancel"
$CancelButton.BackColor = '#ca2c2c'
$CancelButton.ForeColor = 'white'
$CancelButton.DialogResult=[system.Windows.Forms.DialogResult]::Cancel
# Add all the Form controls on one line
$form.Controls.AddRange(@($MyGroupBox,$OKButton,$CancelButton,$MyGroupBox1,$MyGroupBox2,$MyGroupBox3))
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
    $t3 = $textBox3.Text
# Check the current state of each radio button and respond accordingly
if ($RadioButton1.Checked){
    Write-Warning "FullControl"
    return "FullControl",$t1,$t2,$t3
    
}
elseif ($RadioButton2.Checked){
    Write-Warning "Modify"
    return "Modify",$t1,$t2,$t3
    
}
elseif ($RadioButton3.Checked){
    Write-Warning "ReadAndExecute"
    return "ReadAndExecute",$t1,$t2,$t3
}
$Form.Dispose()
}else { break; $Form.Dispose() } 
}

Function Grant-Access{
$Acl = (Get-Item $Path).GetAccessControl('Access')
$r = New-Object System.Security.AccessControl.FileSystemAccessRule ("CHEMTURA\$user",$type,"Allow")
Try{
    $acl.SetAccessRule($r)
    Set-Acl -Path $Path -AclObject $acl
    [System.Windows.MessageBox]::show("Success")
    # Create-Report
}Catch{[System.Windows.MessageBox]::show("Error! -> while Setting the access!",'SDA',"OK",'Error')
    # Create-Report
}

#Get-Acl -Path $path | select AccessToString | %{$_.AccessToString.split("`n")}
}

Function Create-Report{
    $outfile = "C:\ScriptingSpace\ShareDriveAccess\Reports\Reports.csv"

    if (($c = Test-Path $outfile) -eq $False){
        {} |Select "Task","UNID","Path","Status","Date" | Export-csv $outfile
    }


}




$arry = Domain-Form

# unid = "LVKST"
$user = $arry[1]
# path = "C:\ScriptingSpace"
$Path = $arry[2]
# Type can be ("FullControl","Modify","ReadAndExecute")
$type = $arry[0]
#Task 
$task = $arry[3]
if($user -eq "" -or $Path -eq "" -or $task -eq ""){
    [System.Windows.MessageBox]::show("UNID ,Path or Task is Blank!",'SDA',"OK",'Warning')
    Break
}
else{[System.Windows.MessageBox]::show("UNID: $user, Path: $Path, Type: $type")}

Grant-Access
