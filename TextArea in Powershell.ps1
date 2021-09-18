#$tsui = New-Object -COMObject Microsoft.SMS.TSProgressUI
#$tsui.closeprogressdialog()
# A function to create the form
[String]$t = "gfdgfd"
function Domain_Form{
[void] [system.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [system.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
# Set the size of your form
$Form = New-Object System.Windows.Forms.Form
$Form.width = 500
$Form.height = 300
$Form.Text = ”Share Drive Access"
# Set the font of the text to be used within the form
$Font = New-Object System.Drawing.Font("Consolas",12)
$Form.Font = $Font

#$form.Controls.Add($textBox)

# Create a group that will contain your Text Box.

$MyGroupBox2 = New-Object System.Windows.Forms.GroupBox
$MyGroupBox2.Location = '40,10'
$MyGroupBox2.size = '400,170'
$MyGroupBox2.text = "UNID (sAMAccountName):"
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(10,40) ### Location of the text box
$textBox2.Size = New-Object System.Drawing.Size(380,120) ### Size of the text box
$textBox2.Multiline = $true ### Allows multiple lines of data
$textBox2.AcceptsReturn = $true ### By hitting enter it creates a new line
$textBox2.ScrollBars = "Vertical" ### Allows for a vertical scroll bar if the list of text is too big for the window
$MyGroupBox2.Controls.Add($textBox2)


# Add an OK button
# Thanks to J.Vierra for simplifing the use of buttons in forms
$OKButton = new-object System.Windows.Forms.Button
$OKButton.Location = '130,200'
$OKButton.Size = '100,40'
$OKButton.Text = 'Create'
$OKButton.DialogResult=[system.Windows.Forms.DialogResult]::OK
#Add a cancel button
$CancelButton = new-object System.Windows.Forms.Button
$CancelButton.Location = '255,200'
$CancelButton.Size = '100,40'
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult=[system.Windows.Forms.DialogResult]::Cancel
# Add all the Form controls on one line
$form.Controls.AddRange(@($OKButton,$CancelButton,$MyGroupBox2))
# Add all the GroupBox controls on one line

# Assign the Accept and Cancel options in the form to the corresponding buttons
$form.AcceptButton = $OKButton
$form.CancelButton = $CancelButton
# Activate the form
$form.Add_Shown({$form.Activate()})
# Get the results from the button click
$dialogResult = $form.ShowDialog()
# If the OK button is selected
if ($dialogResult -eq "OK"){
# Check the current state of each radio button and respond accordingly

Write-Output($textBox2.Text)

}
}

# Call the function
Domain_Form
