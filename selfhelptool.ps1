Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Form = New-Object System.Windows.Forms.Form    
$Form.Size = New-Object System.Drawing.Size(625,0)  

#This Field is used to set the form display name, and registry path for scipts.
$global:MyCompanyName = "MY Company"

$global:Counter = 0
$global:BoxPosY = 1
$global:DefaultTextValue = ""
$global:ButtonScript = ""
$global:BoxName = ""
$global:ButtonName
$global:BoxHeight = 100
$global:FormHeight = 200
$global:ButtonPosY = ($global:BoxHeight -35)
$global:LabelPosY = 20
$global:ImagePosY = 15

$ButtonAdd.Add_Click{Add-Fields}

$global:outItems = New-Object System.Collections.Generic.List[System.Object]

Function Create-Button {
    param ( $ButtonPosY, $TextBoxPosY, $ButtonIcon)

    $ButtonClick = New-Object System.Windows.Forms.Button
    $ButtonClick.Location = New-Object System.Drawing.Point(1,$global:ButtonPosY)
    $ButtonClick.Size = New-Object System.Drawing.Size(50,30)
    $ButtonClick.Text = $global:ButtonName
    New-Variable -name ButtonClick$global:Counter -Value $ButtonClick -Scope Global -Force
    $Form.controls.Add($((Get-Variable -name ButtonClick$global:Counter).value))
    $ButtonClick.Name = $global:Counter

    $ButtonClick.Add_Click({
        [System.Object]$Sender = $args[0]
        $((Get-Variable -name ('TextBoxField' + [int]$Sender.Name)).value).Text = 'hello'
    })

    $TextBoxField = New-Object System.Windows.Forms.TextBox
    $TextBoxField.Location = New-Object System.Drawing.Point(82,$TextBoxPosY)
    $TextBoxField.Size = New-Object System.Drawing.Size(50,30)
    $TextBoxField.Text = "Run"
    New-Variable -name TextBoxField$global:Counter -Value $TextBoxField -Scope Global -Force
    $Form.controls.Add($((Get-Variable -name TextBoxField$global:Counter).value))

}

Function Create-Groupbox {
    param ( $ButtonPosY, $TextBoxPosY, $BoxName, $BoxDescription, $BoxDescription2, $ButtonScript)

    $Label1 = New-Object system.Windows.Forms.Label
    $Label1.text = $BoxDescription
    $Label1.AutoSize = $true
    $Label1.width = 25
    $Label1.height = 10
    $Label1.location = New-Object System.Drawing.Point(100,$global:LabelPosY)
    $form.Controls.Add($Label1)


    $Label2 = New-Object system.Windows.Forms.Label
    $Label2.text = $BoxDescription2
    $Label2.AutoSize = $false
    $Label2.width = 300
    $Label2.height = 10
    $Label2.location = New-Object System.Drawing.Point(100,($global:LabelPosY +25))
    $form.Controls.Add($Label2)


    $ButtonClick = New-Object System.Windows.Forms.Button
    $ButtonClick.Location = New-Object System.Drawing.Point(550,$global:ButtonPosY)
    $ButtonClick.Size = New-Object System.Drawing.Size(50,30)
    $ButtonClick.Text = "Run"
    
    New-Variable -name ButtonClick$global:Counter -Value $ButtonClick -Scope Global -Force
    $Form.controls.Add($((Get-Variable -name ButtonClick$global:Counter).value))
    $ButtonClick.Name = $global:Counter

    $ButtonClick.Add_Click({
        [System.Object]$Sender = $args[0]
        Start-Process -FilePath "powershell.exe" -ArgumentList "-EncodedCommand $((Get-Variable -name ('ButtonScript' + [int]$Sender.Name)).value)"
    })

    $bytes = [Convert]::FromBase64String($Item.Icon)

    $pictureBox = new-object Windows.Forms.PictureBox
    $pictureBox.Location = New-Object System.Drawing.Size(10,$global:ImagePosY)
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
    $pictureBox.Size = New-Object System.Drawing.Size(75,75)
    $pictureBox.Image = $bytes
    $Form.controls.add($pictureBox)

    $groupBox1 = New-Object System.Windows.Forms.GroupBox
    $groupBox1.Location = New-Object System.Drawing.Point(5,$global:BoxPosY)
    $groupBox1.size = New-Object System.Drawing.Size(600,$global:BoxHeight)
    $groupBox1.text = $BoxName
    $groupBox1.Visible = $true
    $form.Controls.Add($groupBox1) 

}

$Keys = Get-ChildItem HKLM:\SOFTWARE\$global:MyCompanyName\DIYTools -recurse
$Items = $Keys | Foreach-Object {Get-ItemProperty $_.PSPath }    

Foreach ($item in $Items) {
    if ($item.Enabled -eq 1) {
        $global:BoxName = $item.Name
        $global:ButtonScript = $item.Script
        $global:Counter = $global:Counter + 1

        New-Variable -name ButtonScript$global:Counter -Value $item.Script -Scope Global -Force

        Create-Groupbox -TextBoxPosY $global:ButtonPosY -ButtonPosY $global:ButtonPosY -BoxName $global:BoxName -BoxDescription $item.Description -BoxDescription2 $item.Description2

        $global:ButtonPosY = $global:ButtonPosY + $global:BoxHeight
        $global:FormHeight = $global:FormHeight + $global:BoxHeight
        $global:BoxPosY = $global:BoxPosY + $global:BoxHeight
        $global:LabelPosY = $global:LabelPosY + $global:BoxHeight
        $global:ImagePosY = $global:ImagePosY + $global:BoxHeight
    }
}

$global:outItems.ToArray()

$Form.AutoSize = $true
$Form.Name = "$global:MyCompanyName Self Help Tools"
$Form.Text = "$global:MyCompanyName Self Help Tools"
#$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$Form.Anchor = "Top,Bottom,Left,Right"
$Form.StartPosition = "CenterScreen"
$Form.MinimizeBox = $True
$Form.MaximizeBox = $False
$Form.WindowState = "Normal"
$Form.SizeGripStyle = "Auto"
$Form.AutoSizeMode = New-Object System.Windows.Forms.AutoSizeMode
$Form.SizeGripStyle = "Show"
#$Form.BackColor = "LightGray"
$Form.ShowDialog()
