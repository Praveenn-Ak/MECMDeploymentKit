#region Script Settings
#<ScriptSettings >
#  <ScriptPackager>
#    <process>powershell.exe</process>
#    <arguments />
#    <extractdir>%TEMP%</extractdir>
#    <files />
#    <usedefaulticon>true</usedefaulticon>
#    <showinsystray>false</showinsystray>
#    <altcreds>false</altcreds>
#    <efs>true</efs>
#    <ntfs>true</ntfs>
#    <local>false</local>
#    <abortonfail>true</abortonfail>
#    <product />
#    <version>1.0.0.1</version>
#    <versionstring />
#    <comments />
#    <company />
#    <includeinterpreter>false</includeinterpreter>
#    <forcecomregistration>false</forcecomregistration>
#    <consolemode>false</consolemode>
#    <EnableChangelog>false</EnableChangelog>
#    <AutoBackup>false</AutoBackup>
#    <snapinforce>false</snapinforce>
#    <snapinshowprogress>false</snapinshowprogress>
#    <snapinautoadd>2</snapinautoadd>
#    <snapinpermanentpath />
#    <cpumode>1</cpumode>
#    <hidepsconsole>false</hidepsconsole>
#  </ScriptPackager>
#</ScriptSettings>
#endregion

# Define the path to the XML file using the current script directory
$ConfigFilesource = Join-Path -Path $PSScriptRoot -ChildPath 'ConfigFile.xml'

# Check if the XML file exists
if (Test-Path -Path $ConfigFilesource) {
    # Load the XML file if it exists
    [xml]$ConfigFile = Get-Content -Path $ConfigFilesource
    
} else {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show('XML Config file was not found, created new one. Please Check the Config File!')
        
    # Define the XML content to be created
    $ConfigValue = @"
<Settings>
    <MECMSettings>
        <MECMSITECODE>ABC</MECMSITECODE>
        <MECMSERVER>Cwypwd-100</MECMSERVER>
    </MECMSettings>
    <EmailSettings>
        <SMTPServer>App-mail.abc.corp.bce.ca</SMTPServer>
        <FromAddress>MECM_Automation@bac.com</FromAddress>
        <CCAddress>abc.SCCM.Ops.IN@bac.com</CCAddress>
        <BCCAddress></BCCAddress>
    </EmailSettings>
    <ToolSettings>
        <MailList>antony@ok.com;praveen@google.com;kumar@yahooo.com</MailList>
        <MailOptions>Yes</MailOptions>
    </ToolSettings>
</Settings>
"@

    # Convert the string to an XML object
    [xml]$ConfigFile = $ConfigValue

    # Save the XML content to the file
    $ConfigFile.Save($ConfigFilesource)
    
}

 
#****************************************************************************************
$SiteCode = $ConfigFile.Settings.MECMSettings.MECMSITECODE
$siteserver = $ConfigFile.Settings.MECMSettings.MECMSERVER
#****************************************************************************************
$SMTP = $ConfigFile.Settings.EmailSettings.SMTPServer
$FromAddress = $ConfigFile.Settings.EmailSettings.FromAddress
$ToAddress = $ConfigFile.Settings.EmailSettings.ToAddress
$CCAddress = $ConfigFile.Settings.EmailSettings.CCAddress
$BCCAddress = $ConfigFile.Settings.EmailSettings.BCCAddress
#****************************************************************************************  
$ApproveremailIDlist = $ConfigFile.Settings.ToolSettings.MailList -split ";"
$emailOptions = $ConfigFile.Settings.ToolSettings.MailOptions
#****************************************************************************************  

#region ScriptForm Designer

#region Constructor

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

#endregion

#region Post-Constructor Custom Code

#endregion

#region Form Creation
#Warning: It is recommended that changes inside this region be handled using the ScriptForm Designer.
#When working with the ScriptForm designer this region and any changes within may be overwritten.
#~~< Form1 >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Add-Type -AssemblyName System.Windows.Forms
$Form1 = New-Object System.Windows.Forms.Form
$Form1.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
$Form1.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::None
$Form1.ClientSize = New-Object System.Drawing.Size(1200, 751)
$Form1.Font = New-Object System.Drawing.Font("Tahoma", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Form1.HelpButton = $true
$Form1.Opacity = 0.969999988079071
$Form1.SizeGripStyle = [System.Windows.Forms.SizeGripStyle]::Show
$Form1.Text = "MECM Deployment Kit"
$Form1.TopMost = $true
#~~~~Menustrip~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$MenuStrip = New-Object System.Windows.Forms.MenuStrip
$FileMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$ExitMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$HelpMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$AboutMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$HelpLinkMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$FileMenu.Text = "File"
$ExitMenu.Text = "Exit"
$HelpMenu.Text = "Help"
$AboutMenu.Text = "About!"
$HelpLinkMenu.Text = "Help?"
$ExitMenu.Add_Click({exitmenuclicked($ExitMenu) })
$AboutMenu.Add_Click({aboutmenuclicked($AboutMenu)})
$HelpLinkMenu.Add_Click({helpmenuclicked($HelpLinkMenu)})

$FileMenu.DropDownItems.Add($ExitMenu) | Out-Null
$HelpMenu.DropDownItems.Add($AboutMenu) | Out-Null
$HelpMenu.DropDownItems.Add($HelpLinkMenu) | Out-Null
$MenuStrip.Items.Add($FileMenu) | Out-Null
$MenuStrip.Items.Add($HelpMenu) | Out-Null
#~~< Combo_Deploy_purpose >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Combo_Deploy_purpose = New-Object System.Windows.Forms.ComboBox
$Combo_Deploy_purpose.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Combo_Deploy_purpose.FormattingEnabled = $true
$Combo_Deploy_purpose.Location = New-Object System.Drawing.Point(265, 350)
$Combo_Deploy_purpose.Size = New-Object System.Drawing.Size(284, 23)
$Combo_Deploy_purpose.TabIndex = 8
$Combo_Deploy_purpose.Text = ""
$Combo_Deploy_purpose.Items.AddRange([System.Object[]](@("Available", "Required")))
$Combo_Deploy_purpose.SelectedIndex = -1
$Combo_Deploy_purpose.add_SelectedIndexChanged({Combo_Deploy_purposeSelectedIndexChanged($Combo_Deploy_purpose)})
#~~< LBL_Purpose >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_Purpose = New-Object System.Windows.Forms.Label
$LBL_Purpose.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_Purpose.Location = New-Object System.Drawing.Point(65, 350)
$LBL_Purpose.Size = New-Object System.Drawing.Size(155, 23)
$LBL_Purpose.TabIndex = 32
$LBL_Purpose.Text = "Deployment Purpose"
#~~< Comb_deploy_act >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Comb_deploy_act = New-Object System.Windows.Forms.ComboBox
$Comb_deploy_act.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Comb_deploy_act.FormattingEnabled = $true
$Comb_deploy_act.Location = New-Object System.Drawing.Point(265, 300)
$Comb_deploy_act.Size = New-Object System.Drawing.Size(284, 23)
$Comb_deploy_act.TabIndex = 7
$Comb_deploy_act.Text = ""
$Comb_deploy_act.Items.AddRange([System.Object[]](@("Install", "Uninstall")))
$Comb_deploy_act.SelectedIndex = -1
$Comb_deploy_act.add_SelectedIndexChanged({Comb_deploy_actSelectedIndexChanged($Comb_deploy_act)})
#~~< LBL_Deploy_action >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_Deploy_action = New-Object System.Windows.Forms.Label
$LBL_Deploy_action.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_Deploy_action.Location = New-Object System.Drawing.Point(65, 300)
$LBL_Deploy_action.Size = New-Object System.Drawing.Size(155, 23)
$LBL_Deploy_action.TabIndex = 30
$LBL_Deploy_action.Text = "Deployment Action"
#~~< Combo_Tech >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Combo_Tech = New-Object System.Windows.Forms.ComboBox
$Combo_Tech.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Combo_Tech.FormattingEnabled = $true
$Combo_Tech.Location = New-Object System.Drawing.Point(265, 150)
$Combo_Tech.Size = New-Object System.Drawing.Size(284, 23)
$Combo_Tech.TabIndex = 3
$Combo_Tech.Text = ""
$Combo_Tech.Items.AddRange([System.Object[]](@("Application", "Package", "Task Sequence")))
$Combo_Tech.SelectedIndex = -1
$Combo_Tech.add_SelectedIndexChanged({Combo_TechSelectedIndexChanged($Combo_Tech)})
#~~< CMBO_email >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$CMBO_email = New-Object System.Windows.Forms.ComboBox
$CMBO_email.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$CMBO_email.FormattingEnabled = $true
$CMBO_email.Location = New-Object System.Drawing.Point(265, 100)
$CMBO_email.Size = New-Object System.Drawing.Size(284, 23)
$CMBO_email.TabIndex = 2
$CMBO_email.Text = ""
foreach ($email in $ApproveremailIDlist) {$CMBO_email.Items.Add($email)}
$CMBO_email.SelectedIndex = -1
#~~< Exit >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Exit = New-Object System.Windows.Forms.Button
$Exit.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Exit.Location = New-Object System.Drawing.Point(1023, 672)
$Exit.Size = New-Object System.Drawing.Size(90, 23)
$Exit.TabIndex = 16
$Exit.Text = "Exit"
$Exit.UseVisualStyleBackColor = $true
$Exit.add_Click({ExitClick($Exit)})
#~~< Deploy >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Deploy = New-Object System.Windows.Forms.Button
$Deploy.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Deploy.Location = New-Object System.Drawing.Point(840, 672)
$Deploy.Size = New-Object System.Drawing.Size(90, 23)
$Deploy.TabIndex = 15
$Deploy.Text = "Deploy...!"
$Deploy.UseVisualStyleBackColor = $true
$Deploy.add_Click({DeployClick($Deploy)})
#~~< Validate >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Validate = New-Object System.Windows.Forms.Button
$Validate.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Validate.Location = New-Object System.Drawing.Point(654, 672)
$Validate.Size = New-Object System.Drawing.Size(90, 23)
$Validate.TabIndex = 14
$Validate.Text = "Validate..?"
$Validate.UseVisualStyleBackColor = $true
$Validate.add_Click({ValidateClick($Validate)})
#~~< Checkbx_MTW_Reboot >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Checkbx_MTW_Reboot = New-Object System.Windows.Forms.CheckBox
$Checkbx_MTW_Reboot.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Checkbx_MTW_Reboot.Location = New-Object System.Drawing.Point(265, 600)
$Checkbx_MTW_Reboot.Size = New-Object System.Drawing.Size(198, 23)
$Checkbx_MTW_Reboot.TabIndex = 13
$Checkbx_MTW_Reboot.Text = "Reboot...!"
$Checkbx_MTW_Reboot.UseVisualStyleBackColor = $true
#~~< CHKBX_MTW_SW_install >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$CHKBX_MTW_SW_install = New-Object System.Windows.Forms.CheckBox
$CHKBX_MTW_SW_install.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$CHKBX_MTW_SW_install.Location = New-Object System.Drawing.Point(265, 550)
$CHKBX_MTW_SW_install.Size = New-Object System.Drawing.Size(198, 23)
$CHKBX_MTW_SW_install.TabIndex = 12
$CHKBX_MTW_SW_install.Text = "Softtware Installation"
$CHKBX_MTW_SW_install.UseVisualStyleBackColor = $true
#~~< CheckBox_TS_Progress >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$CheckBox_TS_Progress = New-Object System.Windows.Forms.CheckBox
$CheckBox_TS_Progress.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$CheckBox_TS_Progress.Location = New-Object System.Drawing.Point(265, 700)
$CheckBox_TS_Progress.Size = New-Object System.Drawing.Size(284, 23)
$CheckBox_TS_Progress.TabIndex = 13
$CheckBox_TS_Progress.Text = "Show Task sequence Progress"
$CheckBox_TS_Progress.UseVisualStyleBackColor = $true
#~~< CheckBox_TS_software_install >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$CheckBox_TS_software_install = New-Object System.Windows.Forms.CheckBox
$CheckBox_TS_software_install.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$CheckBox_TS_software_install.Location = New-Object System.Drawing.Point(265, 640)
$CheckBox_TS_software_install.Size = New-Object System.Drawing.Size(284, 46)
$CheckBox_TS_software_install.TabIndex = 12
$CheckBox_TS_software_install.Text = "Allow Users to run Independently of Assignments"
$CheckBox_TS_software_install.UseVisualStyleBackColor = $true
#~~< LBL_Notification_settings >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_Notification_settings = New-Object System.Windows.Forms.Label
$LBL_Notification_settings.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_Notification_settings.Location = New-Object System.Drawing.Point(65, 680)
$LBL_Notification_settings.Size = New-Object System.Drawing.Size(155, 30)
$LBL_Notification_settings.TabIndex = 22
$LBL_Notification_settings.Text = "Notification Settings"
#~~< LBL_mtw >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_mtw = New-Object System.Windows.Forms.Label
$LBL_mtw.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_mtw.Location = New-Object System.Drawing.Point(65, 570)
$LBL_mtw.Size = New-Object System.Drawing.Size(155, 30)
$LBL_mtw.TabIndex = 22
$LBL_mtw.Text = "Outside Maintenance window"
#~~< checkBx_expryUTC >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$checkBx_expryUTC = New-Object System.Windows.Forms.CheckBox
$checkBx_expryUTC.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$checkBx_expryUTC.Location = New-Object System.Drawing.Point(486, 500)
$checkBx_expryUTC.Size = New-Object System.Drawing.Size(74, 23)
$checkBx_expryUTC.TabIndex = 21
$checkBx_expryUTC.Text = "UTC"
$checkBx_expryUTC.UseVisualStyleBackColor = $true
#~~< Checkbx_reqdUTC >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Checkbx_reqdUTC = New-Object System.Windows.Forms.CheckBox
$Checkbx_reqdUTC.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Checkbx_reqdUTC.Location = New-Object System.Drawing.Point(486, 450)
$Checkbx_reqdUTC.Size = New-Object System.Drawing.Size(74, 23)
$Checkbx_reqdUTC.TabIndex = 20
$Checkbx_reqdUTC.Text = "UTC"
$Checkbx_reqdUTC.UseVisualStyleBackColor = $true
#~~< Checkbox_availableUTC >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Checkbox_availableUTC = New-Object System.Windows.Forms.CheckBox
$Checkbox_availableUTC.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Checkbox_availableUTC.Location = New-Object System.Drawing.Point(486, 400)
$Checkbox_availableUTC.Size = New-Object System.Drawing.Size(74, 23)
$Checkbox_availableUTC.TabIndex = 19
$Checkbox_availableUTC.Text = "UTC"
$Checkbox_availableUTC.UseVisualStyleBackColor = $true
#~~< time_expiry >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$time_expiry = New-Object System.Windows.Forms.DateTimePicker
$time_expiry.AllowDrop = $true
$time_expiry.CustomFormat = "yyyy-MM-dd hh:mm tt"
$time_expiry.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$time_expiry.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$time_expiry.Location = New-Object System.Drawing.Point(265, 500)
$time_expiry.Size = New-Object System.Drawing.Size(185, 23)
$time_expiry.TabIndex = 11
#~~< LBL_exp_tme >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_exp_tme = New-Object System.Windows.Forms.Label
$LBL_exp_tme.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_exp_tme.Location = New-Object System.Drawing.Point(65, 500)
$LBL_exp_tme.Size = New-Object System.Drawing.Size(155, 23)
$LBL_exp_tme.TabIndex = 17
$LBL_exp_tme.Text = "Expiry Time"
#~~< Time_required >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Time_required = New-Object System.Windows.Forms.DateTimePicker
$Time_required.AllowDrop = $true
$Time_required.CustomFormat = "yyyy-MM-dd hh:mm tt"
$Time_required.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Time_required.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$Time_required.Location = New-Object System.Drawing.Point(265, 450)
$Time_required.Size = New-Object System.Drawing.Size(185, 23)
$Time_required.TabIndex = 10
#~~< LBL_req_tme >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_req_tme = New-Object System.Windows.Forms.Label
$LBL_req_tme.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_req_tme.Location = New-Object System.Drawing.Point(65, 450)
$LBL_req_tme.Size = New-Object System.Drawing.Size(155, 23)
$LBL_req_tme.TabIndex = 15
$LBL_req_tme.Text = "Required Time"
#~~< Time_available >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Time_available = New-Object System.Windows.Forms.DateTimePicker
$Time_available.AllowDrop = $true
$Time_available.CustomFormat = "yyyy-MM-dd hh:mm tt"
$Time_available.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Time_available.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$Time_available.Location = New-Object System.Drawing.Point(265, 400)
$Time_available.Size = New-Object System.Drawing.Size(185, 23)
$Time_available.TabIndex = 9
#~~< LBL_Avlbl_tme >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_Avlbl_tme = New-Object System.Windows.Forms.Label
$LBL_Avlbl_tme.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_Avlbl_tme.Location = New-Object System.Drawing.Point(65, 400)
$LBL_Avlbl_tme.Size = New-Object System.Drawing.Size(155, 23)
$LBL_Avlbl_tme.TabIndex = 13
$LBL_Avlbl_tme.Text = "Available Time"
#~~< TXT_collId >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$TXT_collId = New-Object System.Windows.Forms.TextBox
$TXT_collId.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$TXT_collId.Location = New-Object System.Drawing.Point(265, 250)
$TXT_collId.Size = New-Object System.Drawing.Size(185, 23)
$TXT_collId.TabIndex = 5
$TXT_collId.Text = ""
$TXT_collId.Add_TextChanged({Add_TextTXT_collId($TXT_collId)})
#~~< Checkbox_usercollection >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Checkbox_usercollection = New-Object System.Windows.Forms.CheckBox
$Checkbox_usercollection.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Checkbox_usercollection.Location = New-Object System.Drawing.Point(486, 250)
$Checkbox_usercollection.Size = New-Object System.Drawing.Size(74, 23)
$Checkbox_usercollection.TabIndex = 6
$Checkbox_usercollection.Text = "User"
$Checkbox_usercollection.UseVisualStyleBackColor = $true
#~~< LBL_CollID >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_CollID = New-Object System.Windows.Forms.Label
$LBL_CollID.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_CollID.Location = New-Object System.Drawing.Point(65, 250)
$LBL_CollID.Size = New-Object System.Drawing.Size(155, 23)
$LBL_CollID.TabIndex = 11
$LBL_CollID.Text = "Collection ID"
#~~< Txt_app_name >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Txt_app_name = New-Object System.Windows.Forms.TextBox
$Txt_app_name.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Txt_app_name.Location = New-Object System.Drawing.Point(265, 200)
$Txt_app_name.Size = New-Object System.Drawing.Size(284, 23)
$Txt_app_name.TabIndex = 4
$Txt_app_name.Text = ""
$Txt_app_name.Add_TextChanged({Add_TextChangedTxt_app_name($Txt_app_name)})
#~~< LBL_App_name >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_App_name = New-Object System.Windows.Forms.Label
$LBL_App_name.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_App_name.Location = New-Object System.Drawing.Point(65, 200)
$LBL_App_name.Size = New-Object System.Drawing.Size(155, 23)
$LBL_App_name.TabIndex = 7
$LBL_App_name.Text = "Application Name"
#~~< Displaylog >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Displaylog = New-Object System.Windows.Forms.RichTextBox
$Displaylog.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$Displaylog.Location = New-Object System.Drawing.Point(654, 45)
$Displaylog.ReadOnly = $true
$Displaylog.Size = New-Object System.Drawing.Size(480, 558)
$Displaylog.TabIndex = 20
$Displaylog.Text = ""
#~~< LBL_Tech >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_Tech = New-Object System.Windows.Forms.Label
$LBL_Tech.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_Tech.Location = New-Object System.Drawing.Point(65, 150)
$LBL_Tech.Size = New-Object System.Drawing.Size(155,23 )
$LBL_Tech.TabIndex = 4
$LBL_Tech.Text = "Technology"
#~~< LBL_EMAIL_LIST >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_EMAIL_LIST = New-Object System.Windows.Forms.Label
$LBL_EMAIL_LIST.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_EMAIL_LIST.Location = New-Object System.Drawing.Point(65, 100)
$LBL_EMAIL_LIST.Size = New-Object System.Drawing.Size(155, 23)
$LBL_EMAIL_LIST.TabIndex = 2
$LBL_EMAIL_LIST.Text = "Approver Email List"
#~~< TXT_CRQ >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$TXT_CRQ = New-Object System.Windows.Forms.TextBox
$TXT_CRQ.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$TXT_CRQ.Location = New-Object System.Drawing.Point(265, 50)
$TXT_CRQ.Size = New-Object System.Drawing.Size(284, 23)
$TXT_CRQ.TabIndex = 1
$TXT_CRQ.Text = ""
#~~< LBL_CRQ_NO >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LBL_CRQ_NO = New-Object System.Windows.Forms.Label
$LBL_CRQ_NO.Font = New-Object System.Drawing.Font("Verdana", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LBL_CRQ_NO.Location = New-Object System.Drawing.Point(65, 50)
$LBL_CRQ_NO.Size = New-Object System.Drawing.Size(155, 23)
$LBL_CRQ_NO.TabIndex = 0
$LBL_CRQ_NO.Text = "CRQ or REQ or WO No"

$Form1.Controls.Add($TXT_CRQ)
$Form1.Controls.Add($LBL_CRQ_NO)

$Form1.Controls.Add($CMBO_email)
$Form1.Controls.Add($LBL_EMAIL_LIST)

$Form1.Controls.Add($LBL_Tech)
$Form1.Controls.Add($Combo_Tech)


$Form1.Controls.Add($Exit)
$Form1.Controls.Add($Deploy)
$Form1.Controls.Add($Validate)

$Form1.Controls.Add($Displaylog)
$Form1.Controls.Add($MenuStrip)


$Form1.Cursor = [System.Windows.Forms.Cursors]::Hand
#region$Form1.Icon = ([System.Drawing.Icon](...)
$Form1.Icon = ([System.Drawing.Icon](New-Object System.Drawing.Icon((New-Object System.IO.MemoryStream(($$ = [System.Convert]::FromBase64String(
"AAABAAEAgIAAAAEAIAAoCAEAFgAAACgAAACAAAAAAAEAAAEAIAAAAAAAAAABAMMOAADDDgAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADo"+
                                "gEYA6X9IAOl/SADpf0gB6X9IA+mBRwDqgEkB6X9IOOl/SIXpf0i06X9IyOl/SMvpf0jL6X9Iy+l/"+
                                "SMvpf0jL6X9Iy+l/SMvpf0jL6X9Iy+l/SMvpf0jL6X9Iy+l/SMvpf0jL6X9Iy+l/SMvpf0jL6X9I"+
                                "y+l/SMvpf0jL6X9Iy+l/SMvpf0jL6X9Iy+l/SMvpf0jL6X9Iy+l/SMvpf0jL6X9Iy+l/SMvpf0jL"+
                                "6X9Iy+l/SMvpf0jL6X9Iy+l/SMvpf0jL6X9Iy+l/SMvpf0jL6X9Iy+l/SMvpf0jL6X9Iy+l/SMvp"+
                                "f0jL6X9Iy+l/SMvpf0jL6X9Iy+l/SMvpf0jI6X9ItOl/SITpf0g66X5GAut9RQDpf0gD6X9JAel/"+
                                "SQDpf0kA6oBKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/"+
                                "SADpf0gA6X9IAel/SAPpfkcA6X9IP+l/SMPpf0j96X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I"+
                                "/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/"+
                                "6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/p"+
                                "f0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/"+
                                "SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP7pf0jD6X9IP+l+SADpf0gD6X9I"+
                                "Ael/SADpf0gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0gA6X5I"+
                                "AOl/SADpfkgC53tHAOl/SIbpf0j/6X9I/+l/SP7pf0j86X9I/el/SP3pf0j96X9I/el/SP3pf0j9"+
                                "6X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3p"+
                                "f0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/"+
                                "SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I"+
                                "/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j86X9I/ul/SP/pf0j/6X9Ih+WBQgDpf0cC"+
                                "6X9JAOqARwDpgEgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SADqf0cA"+
                                "6X9IAul/SADpf0iU6X9I/+l/SPvpf0j86X9I/+mASv/pgUv/6YBK/+mASf/pgEn/6YBJ/+mASf/p"+
                                "gEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mA"+
                                "Sf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ"+
                                "/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/"+
                                "6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEr/6YFL/+mASv/pf0j/6X9I/Ol/SPvpf0j/6X9IlOl/SADp"+
                                "f0gC6YBJAOl+SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADogEgA7XpLAOl/SAPp"+
                                "f0gA6X9Iaul/SP/pf0j66X9I/ul/SP/pgEr/6Hk//+h3PP/oekH/6HpB/+h6Qf/oekH/6HpB/+h6"+
                                "Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB"+
                                "/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/"+
                                "6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/o"+
                                "ekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/odzz/6Hk//+mASv/pf0j/6X9I/ul/SPrpf0j/6X9Iaul/"+
                                "SADpf0gD8HxDAOiASQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SQDpf0gB6X9IAOl/"+
                                "SBvpf0js6X9I/+l/SP7pf0j/6X9I/+h4P//unXP/9s23//nf0f/64NL/+uDS//rg0v/64NL/+uDS"+
                                "//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/"+
                                "+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/6"+
                                "4NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg"+
                                "0v/64NL/+uDS//rg0v/64NL/+d/R//bNt//unXP/6Hg+/+l/SP/pf0j/6X9I/ul/SP/pf0js6X9I"+
                                "G+l/SADpf0gB64BHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6n9IAOl/SATpf0gA6X9I"+
                                "gel/SP/pf0j76X9I/+mASf/oekH/9cSq//////////7/////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "///////////////////////////////+///////1w6r/6HpB/+mASf/pf0j/6X9I++l/SP/pf0iA"+
                                "6X9IAOl/SATof0cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0gB6YFHAOmFRgHpf0jR"+
                                "6X9I/+l/SP3pgUv/6Hc9//K1lf////////38///9/P///v3///79///+/f///v3///79///+/f//"+
                                "/v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+"+
                                "/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79"+
                                "///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3/"+
                                "//79///+/f///v3///79///+/f///fz///38///////ytZX/6Hc9/+mBS//pf0j96X9I/+l/SNHi"+
                                "qVYA6IVKAOmASAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SALpf0gA6X9IIOl/SPfp"+
                                "f0j/6X9J/ul+Rv/qhFD//O/p/////////v3/////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "/////////////////////////////////v3///////zv6P/qhE//6X5G/+l/Sf7pf0j/6X9I9+l/"+
                                "SCDpf0gA6X9IAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X9IA+l/SADpf0g66X9I/+l/"+
                                "SP7pgEr/6HlA/+6bcP////////7+////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "/////////////////////////////////////v7//////+6ab//oeUD/6YBK/+l/SP7pf0j/6X9I"+
                                "Oel/SADpf0gDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpgEgD6YBIAOmASEDpf0j/6X9I"+
                                "/emBSv/oeD7/76F5/////////v3/////////////////////////////////////////////////"+
                                "/////////////v3///79///9/f///f3///39///9/f///f3///39///9/f///f3///39///9/f//"+
                                "/f3///39///9/f///f3///39///9/f///f3///39///9/f///f3///39///9/f///f3///39///9"+
                                "/f///f3///39///9/f///f3///39///9/f///f3///79///+/f//////////////////////////"+
                                "///////////////////////////////////+/f//////76F5/+h4Pv/pgUr/6X9I/el/SP/pgEhA"+
                                "6YBIAOmASAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOmASAPpgEgA6YBIQOl/SP/pf0j9"+
                                "6YFK/+h4Pv/vonn////////+/f/////////////////////////////////////////////+/v//"+
                                "/fz/////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "/////////////////////////////////////////////////////////fz///7+////////////"+
                                "//////////////////////////////////79///////vonn/6Hg+/+mBSv/pf0j96X9I/+mASEDp"+
                                "gEgA6YBIAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6YBIA+mASADpgEhA6X9I/+l/SP3p"+
                                "gUr/6Hg+/++iev////////79/////////////////////////////////////////v7///7+////"+
                                "///+/Pv/++rh//rf0v/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q"+
                                "//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/"+
                                "+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q//rf0v/76uH//vz7/////////v7///7+////////"+
                                "/////////////////////////////////v3//////++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmA"+
                                "SADpgEgDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpgEgD6YBIAOmASEDpf0j/6X9I/emB"+
                                "Sv/oeD7/76J6/////////v3///////////////////////////////////79///////++fb/9MCm"+
                                "/+yRYf/pf0n/6HpB/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/"+
                                "6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/o"+
                                "eUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HpB/+l/Sf/skWH/9MGm//749f////////79////"+
                                "///////////////////////////////+/f//////76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBI"+
                                "AOmASAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOmASAPpgEgA6YBIQOl/SP/pf0j96YFK"+
                                "/+h4Pv/vonr////////+/f/////////////////////////////+/f//////++ng/+ySY//ndTn/"+
                                "6HtC/+l/SP/pgEn/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/p"+
                                "gEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mA"+
                                "Sv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEn/6X9I/+h7Qv/ndTn/7JFi//vp4P////////79"+
                                "//////////////////////////////79///////vonr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA"+
                                "6YBIAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AADpf0gA6X9IAOl/SADpgEgB6X9IA+l/SALqekcA63xHAOl/SAAAAAAAAAAAAAAAAAAAAAAA6X9I"+
                                "AOt+SADrfkgA6X9IAumASAPpf0gB6X9IAOl/SADogEgA6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/"+
                                "6Hg+/++iev////////79/////////////////////////v7///////zv6P/riVb/6Hg+/+qCTP/p"+
                                "gEn/6YBJ/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mA"+
                                "Sv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK"+
                                "/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEn/6YBJ/+qCTP/oeD7/64lW//zv6P//////"+
                                "//7+/////////////////////////v3//////++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADp"+
                                "gEgD6YBIAOl/SADpf0gA6X9IAel/SAPpf0gC6X5IAOp+SADpf0gAAAAAAAAAAAAAAAAAAAAAAOl+"+
                                "SADrd0gA63VHAOl/SALpf0gD6X9IAep/SADpf0gA6X9IAAAAAAAAAAAAAAAAAAAAAAAAAAAA8XdA"+
                                "AOl/SADpf0gA6X9IAel/SAHpf0gA6oFNAOl/SALpf0gA6X9IAOl/SAAAAAAAAAAAAOl/SADpf0gA"+
                                "6X9IAOl/SALpd0IA6X9IAOl/SAHpf0gB6X9IAOl/SADpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/o"+
                                "eD7/76J6/////////v3////////////////////////+/v//////76N7/+h2PP/qgkz/6X9I/+mA"+
                                "Sf/pfkf/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB"+
                                "/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/"+
                                "6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+l+R//pgEn/6X9I/+qCTP/ndjv/76N8////////"+
                                "/v7////////////////////////+/f//////76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmA"+
                                "SAPpf0gA6X9IAOl/SAHpf0gB6X9IAO9+SQDpf0gC6H9IAOh/SADof0gAAAAAAAAAAADpf0gA6X5I"+
                                "AOl+SADpf0gC6oZIAOmASADpf0gB6X9IAel/SADpf0gA4n9NAAAAAAAAAAAAAAAAAAAAAADogUoA"+
                                "6IFKAOmASQHqf0gA6YBJC+mASD3pf0gl6IBHAOiARwHmgEUA6H9HAAAAAAAAAAAA54FJAOGITQDn"+
                                "gUkB6IBJAOl/SCbpgEg86X9IC+l/SQDpgEgB6IBIAOmASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4"+
                                "Pv/vonr////////+/f///////////////////v3///////rh1P/oe0L/6YBK/+l/SP/pgEn/6HxE"+
                                "/+qCTP/tlmr/7Zlt/+2YbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/"+
                                "7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2ZbP/t"+
                                "mWz/7Zls/+2ZbP/tmWz/7Zhs/+2Zbf/tlmr/6oJM/+h8RP/pgEn/6X9I/+mASv/oe0L/+uHU////"+
                                "/////v3///////////////////79///////vonr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBI"+
                                "A+iARwDpf0gB6X9JAOl/SAvpgEg86X9IJuiASADpgEcB6oJEAOqARwAAAAAAAAAAAOmARwDnhEUA"+
                                "6IFIAeiDSADpf0gl6X9IPep+SAvpfkkA6n9IAeuARwDrgEcAAAAAAAAAAAAAAAAAAAAAAAAAAADp"+
                                "f0gC6X9IAOl/SCDpf0jV6X9I/+l/SP/pf0h26X9IAOl/SALof0gAAAAAAAAAAADpf0gA6X9IAul/"+
                                "SADpf0h66X9I/+l/SP/pf0jS6X9IHel/SADpf0gC6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+"+
                                "/++iev////////79///////////////////9/P//////87ud/+d2O//pgUv/6YBJ/+l9RP/rilj/"+
                                "9865//rh1P/64NP/+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg0//6"+
                                "4NP/+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg"+
                                "0//64NP/+uDT//rg0//64NP/+uDT//rh1P/3zrn/64pY/+l9Rf/pgEn/6YFL/+d2O//zu57/////"+
                                "///9/P///////////////////v3//////++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgD"+
                                "6X9IAul+SADpfkgd6X9I0+l/SP/pf0j/6X9Ieel/SADpf0gC6X9IAAAAAAAAAAAA6X5IAOl/SALp"+
                                "f0gA6X9Id+l/SP/pf0j/6X9I1el/SR/pf0kA6X9IAgAAAAAAAAAAAAAAAAAAAAAAAAAA6X9IAOl/"+
                                "SAPpf0gA6X9Imel/SP/pf0j56X9I/+l/SPfpgEgi6X9IAOl/SAIAAAAAAAAAAOl/SALpf0gA6X9I"+
                                "Jel/SPnpf0j/6X9I+el/SP/pf0iV6X9IAOl/SAPpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/"+
                                "76J6/////////v3///////////////////79///////wpoD/6Hg+/+mBSv/pgEr/6HlA//O6nP/7"+
                                "5dr/+drK//nbzP/528z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM//nb"+
                                "zP/528z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM"+
                                "//nbzP/528z/+dvM//nbzP/528z/+drK//vl2v/zupz/6HlA/+mASv/pgUr/6Hg+//CmgP//////"+
                                "//79///////////////////+/f//////76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAPp"+
                                "f0gD6X9IAOl/SJXpf0j/6X9I+el/SP/pf0j56X9IJel/SADpf0gCAAAAAAAAAADpf0gC6X9IAOl/"+
                                "SCPpf0j36X9I/+l/SPnpf0j/6X9Imel/SADpf0gD6X9IAAAAAAAAAAAAAAAAAAAAAADpf0gA6X9I"+
                                "Aul/SADpf0i96X9I/+l/SPzpf0j86X9I/+l/SD/pf0gA6X9IAwAAAAAAAAAA6YBIA+mASADpgEhB"+
                                "6X9I/+l/SPzpf0j86X9I/+l/SLrpfkgA6X5IAumASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/v"+
                                "onr////////+/f///////////////////v3//////++iev/oeD7/6YFK/+mASf/oe0L/9cWs//rg"+
                                "0//52cn/+dvL//nby//528v/+dvL//nby//528v/+dvL//nby//528v/+dvL//nby//528v/+dvL"+
                                "//nby//528v/+dvL//nby//528v/+dvL//nby//528v/+dvL//nby//528v/+dvL//nby//528v/"+
                                "+dvL//nby//528v/+dvL//nby//52cn/+uDT//XFrP/oe0L/6YBJ/+mBSv/oeD7/76J6////////"+
                                "/v3///////////////////79///////vonr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIA+l+"+
                                "SALpfkgA6X9Iuul/SP/pf0j86X9I/Ol/SP/pgEhB6YBIAOmASAMAAAAAAAAAAOmASAPpgEgA6YBI"+
                                "P+l/SP/pf0j86X9I/Ol/SP/pf0i96X9IAOmASALpfkgAAAAAAAAAAAAAAAAAAAAAAOl/SADpf0gC"+
                                "6X9IAOl/SLzpf0j/6X9I/Ol/SP3pf0j/6X9IPul/SADpf0gDAAAAAAAAAADpgEgD6YBIAOmASEDp"+
                                "f0j/6X9I/el/SPzpf0j/6X9Iuel+SADpfkgD6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++i"+
                                "ev////////79///////////////////9/f//////8a6M/+h3PP/pgUv/6YBK/+h6QP/vo3v/+uXZ"+
                                "//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/64dT/"+
                                "+uHU//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/6"+
                                "4dT/+uHU//rh1P/64dT/+uHU//rh1P/75Nn/76N7/+h6QP/pgEr/6YFL/+h3PP/xr4z////////9"+
                                "/f///////////////////v3//////++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgD6X5I"+
                                "A+l+SADpf0i56X9I/+l/SPzpf0j96X9I/+mASEDpgEgA6YBIAwAAAAAAAAAA6YBIA+mASADpgEg9"+
                                "6X9I/+l/SP3pf0j86X9I/+l/SL3pgEgA6YBIAul+SAAAAAAAAAAAAAAAAAAAAAAA6X9IAOl/SALp"+
                                "f0gA6X9Ivel/SP/pf0j86X9I/el/SP/pf0g+6X9IAOl/SAPodEYA5oBNAOmASAPpgEgA6YBIQel/"+
                                "SP/pf0j96X9I/Ol/SP/pf0i56X5IAOl+SAPpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6"+
                                "/////////v3///////////////////38///////2zbf/6HY8/+mBS//pf0j/6X9I/+l8RP/vo3v/"+
                                "9cOq//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XEq//1"+
                                "xKv/9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XE"+
                                "q//1xKv/9cSr//XEq//1xKv/9cOq/++je//pfET/6X9I/+l/SP/pgUv/6HY8//bNt/////////38"+
                                "///////////////////+/f//////76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAPpfkgD"+
                                "6X5IAOl/SLnpf0j/6X9I/Ol/SP3pf0j/6YBIQemASADpgEgD5HlDAOh0RgDpgEgD6YBIAOmASD7p"+
                                "f0j/6X9I/el/SPzpf0j/6X9IvemASADpgEgC6X5IAAAAAAAAAAAAAAAAAAAAAADpf0gA6X9IAul/"+
                                "SADpf0i96X9I/+l/SPzpf0j96X9I/+l/SD/pf0gA6X9IA+l+RwDqfkgA6YBIA+mASADpgEhC6X9I"+
                                "/+l/SP3pf0j86X9I/+l/SLrpfkgA6X5IA+mASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/vonr/"+
                                "///////+/f///////////////////v7///////318f/riFX/6X1F/+mASv/pf0j/6X9I/+h6QP/o"+
                                "ekH/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7"+
                                "Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC"+
                                "/+h7Qv/oe0L/6HtC/+h7Qv/oekH/6HpA/+l/SP/pf0j/6YBK/+l9Rf/riFX//fXx/////////v7/"+
                                "//////////////////79///////vonr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIA+l+SAPp"+
                                "fkgA6X9Iuul/SP/pf0j86X9I/el/SP/pgEhC6YBIAOmASAPofkcA6IBJAOmASAPpgEgA6YBIP+l/"+
                                "SP/pf0j96X9I/Ol/SP/pf0i+6YBIAOmASALpfkgAAAAAAAAAAAAAAAAAAAAAAOmASADpf0gD6X9I"+
                                "AOl/SLjpf0j/6X9I/Ol/SPzpf0j/6X9ISel/SADpf0gD6n9IAN6KSgDpf0gD6X9IAOl/SE3pf0j/"+
                                "6X9I/Ol/SPzpf0j/6X9ItOl/SADpf0gD6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev//"+
                                "//////79/////////////////////////f3///////bLtf/ndTr/6YFL/+mASv/pf0j/6YBK/+mA"+
                                "Sf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ"+
                                "/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/"+
                                "6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEr/6X9I/+mASv/pgUv/53U5//bLtf////////39////////"+
                                "/////////////////v3//////++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgD6X9IA+l/"+
                                "SADpf0i06X9I/+l/SPzpf0j86X9I/+l/SE3pf0gA6X9IA+SFTADpgksA6X9IA+l/SADpf0hK6X9I"+
                                "/+l/SPzpf0j86X9I/+l/SLjpf0gA6X9IA+l/SAAAAAAAAAAAAAAAAAAAAAAA6X9HAOl/SATpf0gA"+
                                "6X9Imel/SP/pf0j76X9I++l/SP/pf0iS6X9IAOl/SAbpf0gD6X9IA+l/SAbpf0gA6X9Ilul/SP/p"+
                                "f0j76X9I++l/SP/pf0iV6X9IAOl/SATpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6////"+
                                "/////v3//////////////////////////////v7///////O5m//ndTn/6X1E/+mBS//pgUv/6YFK"+
                                "/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/"+
                                "6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/p"+
                                "gUr/6YFK/+mBSv/pgUr/6YFK/+mBS//pgUv/6XxE/+d1Of/zuZv////////+/v//////////////"+
                                "///////////////+/f//////76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAPpf0gE6X9I"+
                                "AOl/SJbpf0j/6X9I++l/SPvpf0j/6X9Ilul/SADpf0gG6X9IA+l/SAPpf0gG6X9IAOl/SJLpf0j/"+
                                "6X9I++l/SPvpf0j/6X9Imel/SADpf0gE6n9IAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X9IBOl/SADp"+
                                "f0hg6X9I/+l/SPvpf0j+6X9I/+l/SPrpf0hJ6X9IAOl/SALpf0gC6X9IAOl/SEzpf0j86X9I/+l/"+
                                "SP7pf0j86X9I/+l/SF3pf0gA6X9IBOmASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/vonr/////"+
                                "///+/f///////////////////////////////////v3///////bNt//riVb/6HY8/+h3PP/oeD7/"+
                                "6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/o"+
                                "eD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4"+
                                "Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hc8/+h3PP/riFX/9s23/////////v3/////////////////////"+
                                "//////////////79///////vonr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIA+l/SATpf0gA"+
                                "6X9IXel/SP/pf0j86X9I/ul/SP/pf0j86X9ITOl/SADpf0gC6X9IAul/SADpf0hI6X9I+ul/SP/p"+
                                "f0j+6X9I++l/SP/pf0hg6X9IAOl/SAQAAAAAAAAAAAAAAAAAAAAAAAAAAOuFSgDpf0gB6X9IAOmA"+
                                "SBbpf0jp6X9I/+l/SP7pf0j+6X9I/+l/SPjpf0iT6X9IR+l/SEjpf0iV6X9I+el/SP/pf0j+6X9I"+
                                "/ul/SP/pf0jn6X9IFOl/SADpf0gB6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev//////"+
                                "//79/////////////////////////////////////////v3///////328v/3zrn/8a+N/++jfP/v"+
                                "onr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++i"+
                                "ev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6"+
                                "/++iev/vonr/76J6/++jfP/xr43/9865//328v////////79////////////////////////////"+
                                "/////////////v3//////++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgD6X9IAel/SADp"+
                                "f0gU6X9I5+l/SP/pf0j+6X9I/ul/SP/pf0j56X9Ilel/SEjpf0hH6X9Ik+l/SPjpf0j/6X9I/ul/"+
                                "SP7pf0j/6X9I6emASBbpgEgA6X9IAeeASQAAAAAAAAAAAAAAAAAAAAAA6HtGAOl/SADpf0gD6X9I"+
                                "AOl/SHrpf0j/6X9I+ul/SP/pf0j+6X9I/el/SP/pf0j/6X9I/+l/SP/pf0j96X9I/ul/SP/pf0j6"+
                                "6X9I/+l/SHfpf0gA6X9IA+p/SADpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6////////"+
                                "/v3//////////////////////////////////////////////f3/////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "///////////////////////////////////////9/f//////////////////////////////////"+
                                "///////////+/f//////76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAPqf0gA6X9IA+l/"+
                                "SADpf0h36X9I/+l/SPrpf0j/6X9I/ul/SP3pf0j/6X9I/+l/SP/pf0j/6X9I/el/SP7pf0j/6X9I"+
                                "+ul/SP/pf0h76X9IAOl/SAPpf0gA64BHAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X9HAOl/SAHweUsA"+
                                "631IA+l/SLrpf0j/6X9I+el/SP7pf0j+6X9I++l/SPzpf0j86X9I++l/SP7pf0j+6X9I+el/SP/p"+
                                "f0i36H5JAu2ERwDpf0gB6X9IAOmASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/vonr////////+"+
                                "/f///////////////////////////////////////////////////v7///38///9/P///v3///79"+
                                "///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3/"+
                                "//79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f//"+
                                "/v3///79///+/f///v3///38///9/P///v7/////////////////////////////////////////"+
                                "//////////79///////vonr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIA+l/SADpf0kB6HMe"+
                                "AOmBTQLpf0i36X9I/+l/SPnpf0j+6X9I/ul/SPvpf0j86X9I/Ol/SPvpf0j+6X9I/ul/SPnpf0j/"+
                                "6X9Iuuh/SAPje0cA6X9IAemASAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpgEkA6oBJAOl/SAHq"+
                                "fkkA6X9ID+l/SLvpf0j/6X9I/el/SP7pf0j/6X9I/+l/SP/pf0j/6X9I/ul/SP3pf0j/6X9IueqA"+
                                "SA7sgEgA6n9IAel/SADogEgA6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev////////79"+
                                "//////////////////////////////////////////////////////////////79///9/f///f3/"+
                                "//39///9/f///f3///39///9/f///f3///39///9/f///f3///39///9/f///f3///39///9/f//"+
                                "/f3///39///9/f///f3///39///9/f///f3///39///9/f///f3///39///9/f///f3///39///9"+
                                "/f///f3///39///9/f///v3/////////////////////////////////////////////////////"+
                                "/////////v3//////++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgD6X9IAOp/SQDpf0gB"+
                                "6H9JAOl/SA7pf0i46X9I/+l/SP3pf0j+6X9I/+l/SP/pf0j/6X9I/+l/SP7pf0j96X9I/+l/SLzp"+
                                "f0gP6oBHAOl/SAHpfkcA6X5IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0gA6X9IAOl/"+
                                "SAHrf0gB539IBOl/SHfpf0ju6X9I/+l/SP7pf0j/6X9I/+l/SP7pf0j/6X9I7el/SHfpf0cE6oBJ"+
                                "Ael/SAHpf0gA6X9IAAAAAADpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6/////////v3/"+
                                "/////////////////////////////////////////////v7///38////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "//////////////////////////////38///+/v//////////////////////////////////////"+
                                "///////+/f//////76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAMAAAAA6X9IAOl/SADp"+
                                "f0gB6X1GAemBSQPpf0h16X9I7Ol/SP/pf0j+6X9I/+l/SP/pf0j+6X9I/+l/SO7pf0h56X9HBel+"+
                                "SgHpf0gB6X9IAOl/SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAO17RQDpf0gA6X9I"+
                                "AOl/SAHpf0gD7H5KAOqASAnpf0im6X9I/+l/SPzpf0j86X9I/+l/SKPof0gI5npJAOl/SAPqf0gB"+
                                "6n9IAOqASADlekgAAAAAAOmASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/vonr////////+/f//"+
                                "//////////////////////////////////////7+///+/v///////vz7//vq4f/639L/+d7Q//ne"+
                                "0P/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q"+
                                "//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/+d7Q//ne0P/53tD/"+
                                "+d7Q//ne0P/639L/++rh//78+/////////7+///+/v//////////////////////////////////"+
                                "//////79///////vonr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIAwAAAADkgEwA6X9IAOl/"+
                                "SADpf0gB6X9IA+R/QgDpf0gI6X9Io+l/SP/pf0j86X9I/Ol/SP/pf0im6X5JCet+TADpf0gD6X9I"+
                                "Ael/SADpf0gA6YBEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOt9RwDpf0gA"+
                                "6X9IAOl/SAHpf0gI6X9IAOl/SH/pf0j/6X9I++l/SPvpf0j/6X9Ie+l/SADpf0gI6X9IAel/SADp"+
                                "f0gA5npMAAAAAAAAAAAA6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev////////79////"+
                                "///////////////////////////////+/f///////vn2//TBpv/skWL/6X9J/+h6Qf/oeUD/6HlA"+
                                "/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/"+
                                "6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/oeUD/6HlA/+h5QP/o"+
                                "eUD/6HlA/+h6Qf/pf0n/7JFi//TBpv/++PX////////+/f//////////////////////////////"+
                                "/////v3//////++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgDAAAAAAAAAADmdkcA6YBI"+
                                "AOmASADpf0gB6X9ICOl/SADpf0h76X9I/+l/SPvpf0j76X9I/+l/SH/pf0gA6X9ICOl/SAHpf0gA"+
                                "6X9IAOt5RQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADp"+
                                "gEgA6n9JAOl/SATpf0gA6X9Igel/SP/pf0j76X9I++l/SP/pf0h96X9IAOl/SATpf0gA6X9IAAAA"+
                                "AAAAAAAAAAAAAAAAAADpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6/////////v3/////"+
                                "/////////////////////////v3///////vp4P/skmP/53U5/+h7Qv/pf0j/6YBJ/+mASv/pgEr/"+
                                "6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/p"+
                                "gEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mA"+
                                "Sv/pgEr/6YBJ/+l/SP/oe0L/53U5/+ySY//76uD////////+/f//////////////////////////"+
                                "///+/f//////76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAMAAAAAAAAAAAAAAAAAAAAA"+
                                "6oBIAOh/RwDpf0gE6X9IAOl/SH3pf0j/6X9I++l/SPvpf0j/6X9Igel/SADpf0gE6oBIAOl+SAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAA6X9IBOl/SADpf0h/6X9I/+l/SPvpf0j76X9I/+l/SHvpf0gA6X9IBAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAOmASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/vonr////////+/f//////"+
                                "//////////////////7+///////87+j/64lW/+h4Pv/qgkz/6YBJ/+mASf/pgEr/6YBK/+mASv/p"+
                                "gEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mA"+
                                "Sv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK/+mASv/pgEr/6YBK"+
                                "/+mASv/pgEr/6YBJ/+mASf/qgkz/6Hg+/+uJVv/87+j////////+/v//////////////////////"+
                                "//79///////vonr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIAwAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAOl/SATpf0gA6X9Ie+l/SP/pf0j76X9I++l/SP/pf0h/6X9IAOl/SAQAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAADpf0gE6X9IAOl/SH/pf0j/6X9I++l/SPvpf0j/6X9Ie+l/SADpf0gEAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAA6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev////////79////////"+
                                "/////////////////v7//////++je//odjv/6oJM/+l/SP/pgEn/6X5H/+h6Qf/oekH/6HpB/+h6"+
                                "Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB"+
                                "/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/"+
                                "6HpB/+h6Qf/pfkf/6YBJ/+l/SP/qgkz/53Y7/++jfP////////7+////////////////////////"+
                                "/v3//////++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgDAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAA6X9IBOl/SADpf0h76X9I/+l/SPvpf0j76X9I/+l/SH/pf0gA6X9IBAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAOl/SATpf0gA6X9If+l/SP/pf0j76X9I++l/SP/pf0h76X9IAOl/SAQAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAADpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6/////////v3/////////"+
                                "//////////79///////64dT/6HtC/+mASv/pf0j/6YBJ/+h8RP/qgkz/7ZZp/+2Zbf/tmGz/7Zls"+
                                "/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/"+
                                "7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2ZbP/tmWz/7Zls/+2YbP/t"+
                                "mW3/7ZZp/+qCTP/ofET/6YBJ/+l/SP/pgEr/6HtC//rh1P////////79///////////////////+"+
                                "/f//////76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAMAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAADpf0gE6X9IAOl/SHvpf0j/6X9I++l/SPvpf0j/6X9If+l/SADpf0gEAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAA6X9IBOl/SADpf0h/6X9I/+l/SPvpf0j76X9I/+l/SHvpf0gA6X9IBAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAOmASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/vonr////////+/f//////////"+
                                "/////////fz///////O7nf/ndjv/6YFL/+mASf/pfUT/64pY//fOuf/64dT/+uDT//rg0//64NP/"+
                                "+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg0//6"+
                                "4NP/+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg0//64NP/+uDT//rg"+
                                "0//64dT/9865/+uKWP/pfUX/6YBJ/+mBS//ndjv/87ue/////////fz///////////////////79"+
                                "///////vonr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIAwAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAOl/SATpf0gA6X9Ie+l/SP/pf0j76X9I++l/SP/pf0h/6X9IAOl/SAQAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AADpf0gE6X9IAOl/SH/pf0j/6X9I++l/SPvpf0j/6X9Ie+l/SADpf0gEAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAA6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev////////79////////////"+
                                "///////+/f//////8KaA/+h4Pv/pgUr/6YBK/+h5QP/zupz/++Xa//nayv/528z/+dvM//nbzP/5"+
                                "28z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM//nb"+
                                "zP/528z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM//nbzP/528z/+dvM"+
                                "//nayv/75dr/87qc/+h5QP/pgEr/6YFK/+h4Pv/wpoD////////+/f///////////////////v3/"+
                                "/////++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgDAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAA6X9IBOl/SADpf0h76X9I/+l/SPvpf0j76X9I/+l/SH/pf0gA6X9IBAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AOl/SATpf0gA6X9If+l/SP/pf0j76X9I++l/SP/pf0h76X9IAOl/SAQAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAADpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6/////////v3/////////////"+
                                "//////79///////vonr/6Hg+/+mBSv/pgEn/6HtC//XFrP/64NP/+dnJ//nby//528v/+dvL//nb"+
                                "y//528v/+dvL//nby//528v/+dvL//nby//528v/+dvL//nby//528v/+dvL//nby//528v/+dvL"+
                                "//nby//528v/+dvL//nby//528v/+dvL//nby//528v/+dvL//nby//528v/+dvL//nby//528v/"+
                                "+dnJ//rg0//1xaz/6HtC/+mASf/pgUr/6Hg+/++iev////////79///////////////////+/f//"+
                                "////76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AADpf0gE6X9IAOl/SHvpf0j/6X9I++l/SPvpf0j/6X9If+l/SADpf0gEAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "6X9IBOl/SADpf0h/6X9I/+l/SPvpf0j76X9I/+l/SHvpf0gA6X9IBAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAOmASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/vonr////////+/f//////////////"+
                                "/////f3///////Gui//odzz/6YFL/+mASv/oekD/76N7//rl2f/64dT/+uHU//rh1P/64dT/+uHU"+
                                "//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/64dT/"+
                                "+uHU//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/64dT/+uHU//rh1P/6"+
                                "4dT/+uXZ/++je//oekD/6YBK/+mBS//odzz/8a+M/////////f3///////////////////79////"+
                                "///vonr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AOl/SATpf0gA6X9Ie+l/SP/pf0j76X9I++l/SP/pf0h/6X9IAOl/SAQAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADp"+
                                "f0gE6X9IAOl/SH/pf0j/6X9I++l/SPvpf0j/6X9Ie+l/SADpf0gEAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAA6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev////////79////////////////"+
                                "///9/P//////9sy3/+h2PP/pgUv/6X9I/+l/SP/ofET/76N8//XEqv/1xKv/9cSr//XEq//1xKv/"+
                                "9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XEq//1"+
                                "xKv/9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XEq//1xKv/9cSr//XD"+
                                "qv/vo3v/6XxE/+l/SP/pf0j/6YFL/+h2PP/2zbf////////9/P///////////////////v3/////"+
                                "/++iev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "6X9IBOl/SADpf0h76X9I/+l/SPvpf0j76X9I/+l/SH/pf0gA6X9IBAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/"+
                                "SATpf0gA6X9If+l/SP/pf0j76X9I++l/SP/pf0h76X9IAOl/SAQAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAADpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6/////////v3/////////////////"+
                                "//7+///////99fH/64hV/+l9Rf/pgEn/6X9I/+l/SP/oekD/6HpB/+h7Qv/oe0L/6HtC/+h7Qv/o"+
                                "e0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7"+
                                "Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HtC/+h7Qv/oe0L/6HpB"+
                                "/+h6QP/pf0j/6X9I/+mASv/pfUX/64hV//318f////////7+///////////////////+/f//////"+
                                "76J6/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADp"+
                                "f0gE6X9IAOl/SHvpf0j/6X9I++l/SPvpf0j/6X9If+l/SADpf0gEAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X9I"+
                                "BOl/SADpf0h/6X9I/+l/SPvpf0j76X9I/+l/SHvpf0gA6X9IBAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAOmASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/vonr////////+/f//////////////////"+
                                "//////39///////2y7T/53U5/+mBS//pgEr/6X9I/+mASv/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mA"+
                                "Sf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ"+
                                "/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/"+
                                "6YBK/+l/SP/pgEr/6YFL/+d1Ov/2y7X////////9/f////////////////////////79///////v"+
                                "onr/6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/"+
                                "SATpf0gA6X9Ie+l/SP/pf0j76X9I++l/SP/pf0h/6X9IAOl/SAQAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0gE"+
                                "6X9IAOl/SH/pf0j/6X9I++l/SPvpf0j/6X9Ie+l/SADpf0gEAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAA6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev////////79////////////////////"+
                                "//////////7+///////zuZv/53U5/+l9RP/pgUv/6YFL/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK"+
                                "/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/"+
                                "6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/p"+
                                "gUv/6YFL/+l9RP/ndTn/87mb/////////v7//////////////////////////////v3//////++i"+
                                "ev/oeD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X9I"+
                                "BOl/SADpf0h76X9I/+l/SPvpf0j76X9I/+l/SH/pf0gA6X9IBAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6HtHAOl/SATp"+
                                "f0gA6X9If+l/SP/pf0j76X9I++l/SP/pf0h76X9IAOl/SATlgEUAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AADpgEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6/////////v3/////////////////////"+
                                "//////////////79///////2zLf/64hV/+h2PP/odzz/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/"+
                                "6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/o"+
                                "eD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h3"+
                                "PP/odzz/64hV//bMtv////////79///////////////////////////////////+/f//////76J6"+
                                "/+h4Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAMAAAAAAAAAAAAAAAAAAAAAAAAAAOV/RADpf0gE"+
                                "6X9IAOl/SHvpf0j/6X9I++l/SPvpf0j/6X9If+l/SADpf0gE539KAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X1FAOl+SADpfkgA6X9IBel/"+
                                "SADpf0iB6X9I/+l/SPvpf0j76X9I/+l/SH3pf0gA6X9IBOl+RwDpf0cA6IBKAAAAAAAAAAAAAAAA"+
                                "AOmASAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/vonr////////+/f//////////////////////"+
                                "//////////////////79///////99vL/9s24//GvjP/vo3v/76J6/++iev/vonr/76J6/++iev/v"+
                                "onr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++i"+
                                "ev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vo3v/8a+M"+
                                "//fOuP/99vL////////+/f////////////////////////////////////////79///////vonr/"+
                                "6Hg+/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIAwAAAAAAAAAAAAAAAOx8SQDpgEgA6oBIAOl/SATp"+
                                "f0gA6X9Ifel/SP/pf0j76X9I++l/SP/pf0iB6X9IAOl/SAXqfUcA6X5HAOl9RQAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl+RwDpgEgA6X9IAOl/SALpf0gG6X9I"+
                                "AOl/SH/pf0j/6X9I++l/SPvpf0j/6X9Ie+l/SADpf0gG6X9IAul/SADpgEcA6H1KAAAAAAAAAAAA"+
                                "6YBIA+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev////////79////////////////////////"+
                                "//////////////////////39////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "/////////////f3//////////////////////////////////////////////v3//////++iev/o"+
                                "eD7/6YFK/+l/SP3pf0j/6YBIQOmASADpgEgDAAAAAAAAAADofEgA6YBIAOmASADpf0gC6X9IBul/"+
                                "SADpf0h76X9I/+l/SPvpf0j76X9I/+l/SH/pf0gA6X9IB+l/SALpf0gA6X9IAOl9SQAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADrfUYA6YBIAOmASADpf0gC6YBIAel8SAHpf0g8"+
                                "6X9Ix+l/SP/pf0j96X9I/el/SP/pf0jF6X9IO+l9RwHqgEgB6X9IAumASADpgEgA6n9KAAAAAADp"+
                                "gEgD6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6/////////v3/////////////////////////"+
                                "//////////////////////////7+///9/P///f3///79///+/f///v3///79///+/f///v3///79"+
                                "///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3/"+
                                "//79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///9/f//"+
                                "/fz///7+///////////////////////////////////////////////////+/f//////76J6/+h4"+
                                "Pv/pgUr/6X9I/el/SP/pgEhA6YBIAOmASAMAAAAA6X9LAOl/SADpf0gA6X9IAul+SAHuhkgB6X9I"+
                                "Oul/SMXpf0j/6X9I/el/SP3pf0j/6X9Ix+l/SDzreUIC6IFJAel/SALpf0gA6X9IAOuARwAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6oBKAOl/SADpf0gA6X9IA+mASADpgEge6X9IuOl/SP/p"+
                                "f0j+6X9I/+l/SP/pf0j/6X9I/+l/SP7pf0j/6X9It+mASB7pf0gA6X9IA+l/SADpf0gA54BHAOmA"+
                                "SAPpgEgA6YBIQOl/SP/pf0j96YFK/+h4Pv/vonr////////+/f//////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "//////////////////////////////////////////////////////////79///////vonr/6Hg+"+
                                "/+mBSv/pf0j96X9I/+mASEDpgEgA6YBIA+t9RgDpf0gA6X9IAOl/SAPqf0kA6X9IHOl/SLXpf0j/"+
                                "6X9I/ul/SP/pf0j/6X9I/+l/SP/pf0j+6X9I/+l/SLjpf0gf6X9IAOl/SAPpf0gA6X9IAOd+RwAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0gA6X9IAOl/SALpgEgA6YBIMOl/SOfpf0j/6X9I++l/"+
                                "SP3pf0j/6YBJ/+l/Sf/pf0j/6X9I/el/SPvpf0j/6X9I5ul/SC7pf0gA6X9IAul/SADpf0gA6YBI"+
                                "A+mASADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev////////79////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "/////////////////////////////////////////////////////////v3//////++iev/oeD7/"+
                                "6YFK/+l/SP3pf0j/6YBIQOmASADpgEgD6X9IAOl/SADpf0gC6X9IAOl/SC7pf0jl6X9I/+l/SPzp"+
                                "f0j96X9I/+l/Sf/pgEn/6X9I/+l/SP3pf0j76X9I/+l/SOjof0gw6H9IAOl/SALpfkgA6X5IAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAOmASQDpf0gB6X9IAOl/SBjpf0jf6X9I/+l/SPrpf0j/6YBJ"+
                                "/+mASv/pfUX/6X1F/+mASv/pgEn/6X9I/+l/SPrpf0j/6X9I3Ol+SBXqfkgA6X9IAemASADpgEgD"+
                                "6YBIAOmASEDpf0j/6X9I/emBSv/oeD7/76J6/////////v3/////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "///////////////////////////////////////////////////////+/f//////76J6/+h4Pv/p"+
                                "gUr/6X9I/el/SP/pgEhA6YBIAOmASAPpgEgA6X9IAel/SADqf0gW6X9I3el/SP/pf0j66X9I/+mA"+
                                "Sf/pgEr/6X1F/+l9Rf/pgEr/6YBJ/+l/SP/pf0j66X9I/+l/SN/pf0gY6X9IAOl/SAHpf0gAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAADof0kA6X9IAOl/SALpf0gA6X9Inul/SP/pf0j66X9I/+mASv/oe0P/"+
                                "6Hk//+qGUv/qhlL/6Hg//+h7Q//pgEr/6X9I/+l/SPrpf0j/6X9Imul/SADpf0gF6X5IA+l/SAbp"+
                                "gEgA6YBIQul/SP/pf0j96YFK/+h4Pv/voXn////////8+////v3///79///+/f///v3///79///+"+
                                "/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79"+
                                "///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3/"+
                                "//79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f//"+
                                "/v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///z7///////voXn/6Hg+/+mB"+
                                "Sv/pf0j96X9I/+mASELpgEgA6X9IBul+SAPpf0gF6X9IAOl/SJrpf0j/6X9I+ul/SP/pgEr/6HxD"+
                                "/+h5P//qhlL/6oZS/+h5P//oe0P/6YBK/+l/SP/pf0j66X9I/+l/SJ3pf0gA6X9IAuh+SADqf0gA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAADpf0gC6X9IAOl/SCbpf0j46X9I/+l/SP7pgEr/6HpB/+yOXf/4"+
                                "1sX//fXw//318P/41cP/641c/+h6Qv/pgEr/6X9I/ul/SP/pf0j26X9II+l/SADpf0gC6YBIA+mA"+
                                "SADpgEhA6X9I/+l/SP3pgUr/6Hg+/++iev////////79////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "/////////////////////////////////////////////////////v3//////++iev/oeD7/6YFK"+
                                "/+l/SP3pf0j/6YBIQOmASADpgEgD6X9IAul/SADpgEgk6X9I9ul/SP/pf0j+6YBK/+h7Qv/rjVz/"+
                                "+NXD//318P/99fD/+NbE/+uOXf/oekH/6YBK/+l/SP7pf0j/6X9I9+l/SCbpf0gA6X9IAgAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAA6HxJAOl/SATpf0gA6X9IcOl/SP/pf0j76YBJ/+l8RP/rilf//O/p////"+
                                "/////v7///7+///////87uf/64lW/+l9RP/pgEn/6X9I/ul/SP/pf0jQ6X9Itel/SLrpf0i66X9I"+
                                "tul/SMvpf0j/6X9I/ul/Sf/pfUX/64hW/++kfP/vonn/76J6/++iev/vonr/76J6/++iev/vonr/"+
                                "76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/v"+
                                "oXn/76B3/++ief/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++i"+
                                "ev/voXn/76B3/++hef/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6"+
                                "/++iev/vonr/76J6/++iev/vonr/76J6/++iev/vonr/76J6/++ief/vpHz/64hW/+l9Rf/pf0n/"+
                                "6X9I/ul/SP/pf0jL6X9Itul/SLrpf0i66X9Itel/SNDpf0j/6X9I/umASf/pfET/64lW//zu5///"+
                                "//////7+///+/v///////PDp/+uKV//pfET/6YBJ/+l/SPvpf0j/6X9Ib+l/SADpf0gE7X5HAAAA"+
                                "AAAAAAAAAAAAAAAAAADpgEgA6X9IA+l/SADpf0ij6X9I/+l/SPzpgUv/6Hc8//XDqf///////vv6"+
                                "///+/v///v7//vv6///////0wKX/6Hc8/+mBS//pf0j/6X9I/ul/SP7pf0j/6X9I/+l/SP/pf0j/"+
                                "6X9I/+l/SP/pf0j/6X9I/+l/Sf/pfUX/6Hg9/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/o"+
                                "eD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4"+
                                "Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+"+
                                "/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/"+
                                "6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pf/pfUX/6X9J/+l/SP/p"+
                                "f0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/ul/SP7pf0j/6YFL/+h3PP/0wab///////77"+
                                "+v///v7///7+//77+v//////9MKo/+h3PP/pgUv/6X9I/Ol/SP/pf0ii6X9IAOl/SAPpf0gAAAAA"+
                                "AAAAAAAAAAAAAAAAAOmASADpfkgC6X9IAOl/SLvpf0j/6X9I/OmASv/oekD/+d7Q/////////v3/"+
                                "/////////////v3///////ndzv/oeUD/6YBK/+l/SP/pf0j/6X9I/el/SPvpf0j86X9I/Ol/SPzp"+
                                "f0j86X9I/+l/SP/pf0j/6X9I/+l/Sf/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mB"+
                                "Sv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK"+
                                "/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/"+
                                "6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/p"+
                                "gUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+l/Sf/pf0j/6X9I/+l/"+
                                "SP/pf0j/6X9I/Ol/SPzpf0j86X9I/Ol/SPvpf0j96X9I/+l/SP/pgEr/6HlA//ndzv////////79"+
                                "//////////////79///////53tD/6HpA/+mASv/pf0j86X9I/+l/SLrpf0gA6X9IAumASAAAAAAA"+
                                "AAAAAAAAAAAAAAAA6YBIAOl/SAPpf0gA6X9ItOl/SP/pf0j86YBK/+h4Pv/41cP////////9/P//"+
                                "///////////9/P//////99PA/+h4Pv/pgUr/6X9I/+l/SP/pf0j96X9I/el/SP3pf0j96X9I/el/"+
                                "SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I"+
                                "/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP/pf0j/"+
                                "6X9I/+l/SP/pf0j/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+l/SP/p"+
                                "f0j/6X9I/+l/SP/pf0j/6X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/"+
                                "SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j96X9I"+
                                "/el/SP3pf0j96X9I/el/SP3pf0j96X9I/el/SP3pf0j/6X9I/+mBSv/oeD7/+NPB/////////fz/"+
                                "/////////////fz///////jVw//oeD7/6YBK/+l/SPzpf0j/6X9Is+l/SADpf0gD6YBIAAAAAAAA"+
                                "AAAAAAAAAAAAAADpf0kA6X9IBOl/SADpf0iP6X9I/+l/SPvpgUr/6Hg+//Cngv////////39///9"+
                                "/P///fz///79///////wpX//6Hg+/+mBSv/pf0j/6X9I/ul/SP/pf0j/6X9I/+l/SP/pf0j/6X9I"+
                                "/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/"+
                                "6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/p"+
                                "f0j/6X9I/+l/R//oe0H/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oe0H/6X9H/+l/"+
                                "SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I"+
                                "/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/"+
                                "6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP7pf0j/6YFK/+h4Pv/wpn/////////+/f//"+
                                "/fz///38///9/f//////8KeB/+h4Pv/pgUr/6X9I++l/SP/pf0iO6X9IAOl/SATqf0gAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAADpf0gD6X9IAOl/SE7pf0j/6X9I/Ol/SP/pgEn/6HpA//TApf////////7+"+
                                "///+/v//////9L+j/+h5QP/pgEn/6X9I/+l/SP3pf0j/6X9IbumASDXpgEhA6YBIPumASD7pgEg+"+
                                "6YBIPumASEDpgEhB6YBIPumASD7pgEg+6YBIPumASD7pgEg+6YBIPumASD7pgEg+6YBIPumASD7p"+
                                "gEg+6YBIPumASD7pgEg+6YBIPumASD7pgEg+6YBIPumASD7pgEg/6YBIO+mASErpf0jx6X9I/+l/"+
                                "Sf7pfUX/6oZS//nayv/64dX/+eDS//rg0v/64NL/+uDS//rg0v/54NL/+uHV//nayv/qhlL/6X1F"+
                                "/+l/Sf7pf0j/6X9I8emASErpgEg76YBIP+mASD7pgEg+6YBIPumASD7pgEg+6YBIPumASD7pgEg+"+
                                "6YBIPumASD7pgEg+6YBIPumASD7pgEg+6YBIPumASD7pgEg+6YBIPumASD7pgEg+6YBIQemASEDp"+
                                "gEg+6YBIPumASD7pgEg+6YBIQOmASDTpf0hv6X9I/+l/SP3pf0j/6YBJ/+h6QP/0vqP////////+"+
                                "/v///v7///////TApf/oekD/6YBJ/+l/SP/pf0j86X9I/+l/SE3pf0gA6X9IAwAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAA6oJKAOl/SAHqgEgA6oBJB+l/SNbpf0j/6X9I/el/SP/pf0j/6Hk//+2Zbf/0vaD/"+
                                "87yf/+2YbP/oeT//6X9I/+l/SP/pf0j96X9I/+l/SNLpgEgF6YBIAOl/SAEAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOmASAHpgUgA6YFID+l/SO3pf0j/6YBJ"+
                                "/ul9Rf/riFX//vf0/////////v7////////////////////////+/v///////vf0/+uIVf/pfUX/"+
                                "6YBJ/ul/SP/pf0jt6YFID+mBSADpgEgBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAADpf0gB6H9IAOh/SQXpf0jT6X9I/+l/SP3pf0j/6X9I/+h4P//tmGz/87yg"+
                                "//S8oP/tmW3/6Hk//+l/SP/pf0j/6X9I/el/SP/pf0jV6YBJB+mASQDpf0gB6X9JAAAAAAAAAAAA"+
                                "AAAAAAAAAADraDsA6n9IAOl/SAPpf0gA6X9IWOl/SP/pf0j76X9I/ul/SP/pgEr/6HpA/+d1Ov/n"+
                                "dTr/6HpB/+mASv/pf0j/6X9I/ul/SPvpf0j/6X9IVOl/SADpf0gG6YBIA+mASAPpgEgD6YBIA+mA"+
                                "SAPpgEgD6YBIA+l/SAPpgEgD6YBIA+mASAPpgEgD6YBIA+mASAPpgEgD6YBIA+mASAPpgEgD6YBI"+
                                "A+mASAPpgEgD6YBIA+mASAPpgEgD6YBIA+mASAPpgEgD6YBIBOmDSADpgUgS6X9I7el/SP/pgEn+"+
                                "6X1F/+uIVf/99vL////////9/P///f3///39///9/f///f3///38///////99vL/64hV/+l9Rf/p"+
                                "gEn+6X9I/+l/SO3pgUgS6YNIAOmASATpgEgD6YBIA+mASAPpgEgD6YBIA+mASAPpgEgD6YBIA+mA"+
                                "SAPpgEgD6YBIA+mASAPpgEgD6YBIA+mASAPpgEgD6YBIA+mASAPpgEgD6X9IA+mASAPpgEgD6YBI"+
                                "A+mASAPpgEgD6YBIA+mASAPpf0gG6X9IAOl/SFTpf0j/6X9I++l/SP7pf0j/6YBK/+h6Qf/ndTr/"+
                                "53U6/+h6Qf/pgEr/6X9I/+l/SP7pf0j76X9I/+l/SFjpf0gA6X9IA+mASADsgEYAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAADpf0cA631IAOmASALpgEgA6X9Ijul/SP/pf0j76X9I/Ol/SP7pgEr/6YFL/+mB"+
                                "S//pgEr/6X9I/ul/SPzpf0j76X9I/+l/SIrpfkgA6X9IAuiBSADpf0gAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOd6TQDpgEkA"+
                                "6oRMAOiBSgDpf0gC6X9IBOl/SAPpf0gD6X5IA+l+SAPpf0gE6YRIAOmASBLpf0jt6X9I/+mASf7p"+
                                "fUX/64hV//328v////////38///+/f///v3///79///+/f///fz///////328v/riFX/6X1F/+mA"+
                                "Sf7pf0j/6X9I7emASBLphEgA6X9IBOl+SAPpfkgD6X9IA+l/SAPpf0gE6X9IAud/SwDnfU0A6H9J"+
                                "AOZ/RQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAA6X9JAOp/SADpf0gC6X9HAOl/SIvpf0j/6X9I++l/SPzpf0j+6YBK/+mBS//p"+
                                "gUv/6YBK/+l/SP7pf0j86X9I++l/SP/pf0iN6IBIAOiASALrfEgA6X9IAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAOt/SgDlgEgA6X9IAOl/SALrf0gA6X9IhOl/SP/pf0j/6X9I/ul/SPzpf0j76X9I"+
                                "++l/SPzpf0j+6X9I/+l/SP/pf0iD6oJHAOl/RwLpf0gA6n1HAOh/SAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADof0cA6X9IAOl/SADp"+
                                "f0gC6X9IA+l/SADof0gA6n9HAAAAAAAAAAAAAAAAAOmASAHpgUgA6YFID+l/SO3pf0j/6YBJ/ul9"+
                                "Rf/riFX//vf0/////////v7////////////////////////+/v///////vf0/+uIVf/pfUX/6YBJ"+
                                "/ul/SP/pf0jt6YFID+mBSADpgEgBAAAAAAAAAAAAAAAA635HAOiASADogEgA6X9IA+l/SALpgEgA"+
                                "6YBIAOl+SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAADqf0gA54FHAOp/SADpgEgC6X9IAOl/SIHpf0j/6X9I/+l/SP7pf0j86X9I++l/"+
                                "SPvpf0j86X9I/ul/SP/pf0j/6X9Ihu2BRwDqgEgC6H9IAOp+SADqgEoAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAOl/SADpf0gA6X9IAOl/SAPpfkgA6X9IPul/SL7pf0j76X9I/+l/SP/pf0j/"+
                                "6X9I/+l/SPvpf0i96X9IPel+RwDpf0gD6YBIAOmASADpgEgAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X5IAOp8SADqekgA6X9IA+l/"+
                                "SAHofUcA6X9IIul/SGzpf0ie6X9Itul/SLrpf0i56X9Iuul/SLjpf0i+6X9I+ul/SP/pf0j/6X5H"+
                                "/+mCTP/voHf/76N7/++iev/vonr/76J6/++iev/vonr/76J6/++je//voHf/6YJM/+l+R//pf0j/"+
                                "6X9I/+l/SPrpf0i+6X9IuOl/SLrpf0i56X9Iuul/SLbpf0ie6X9IbOl/SCTof0cA6IBHAel/SAPo"+
                                "fEoA6H1JAOl/SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAADpf0gA6X9IAOp/SADpgEgD6YFIAOl/SDzpf0i86X9I++l/SP/pf0j/6X9I"+
                                "/+l/SP/pf0j76X9Iv+l/SD/pgEkA6X9IA+l+SADpfkgA6X5IAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAA63ZOAOl/SADpf0gA6X9IAel/SAP8ZK4A6o0cAOl/SCbpf0hc6X9IeOl/SHjp"+
                                "f0hb6YBIJfVmZwDudVgA6X9IA+l/SAHpf0gA6X9IAN+AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOh+SADne0gA53tIAOl/SAPpf0gA6X9I"+
                                "I+l/SKnpf0j66X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/"+
                                "6X5H/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/pfkf/6X9I/+l/SP/p"+
                                "f0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I+ul/SKnpf0gk6YBIAOl/"+
                                "SAPngUsA54FLAOh/SQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAONxVQDpf0gA6X9IAOl/SAHpf0gD5ntBAM1+LADpf0gl6X9IW+l/SHjpf0h4"+
                                "6X9IXOl/SCb8TUIA3qBLAOl/SAPof0gB6H9IAOh/SADqgEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAOmASADnk0EA6XtKAOl/SAPpf0gC6X9IAOl/SADugksA6X1MAOl/"+
                                "SADpf0gA6X9IAul/SAPqfkgA145HAOl/SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADogEgA6X9IAOmARgDpf0gD6X9HAOl/SFfpf0j0"+
                                "6X9I/+l/SP7pf0j76X9I++l/SPzpf0j86X9I/Ol/SPzpf0j86X9I/Ol/SP/pf0j/6X9I/+l/SP/p"+
                                "f0j/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+l/SP/pf0j/6X9I/+l/"+
                                "SP/pf0j/6X9I/Ol/SPzpf0j86X9I/Ol/SPzpf0j86X9I++l/SPvpf0j+6X9I/+l/SPTpf0hY6X9I"+
                                "AOl/SAPqgUcA6X9IAOmARwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAADpf0gA64lEAOqARwDpf0gD6X9IAul/SADpfkgA6YNGAO59SADo"+
                                "f0gA6X9IAOl/SALpf0gD54FKAOx7QgDpf0gA/2YzAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAOh+SQDpf0cA6X9HAOh/RwDpf0gC6X9IBOl/SATpf0gE6X9I"+
                                "BOl/SALpgEcA6IBGAOmARwDofkkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SADrgUgA6X9IA+l/SADpf0hg6X9I/+l/SP3p"+
                                "f0j76X9I/umASf/pgUv/6YBK/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEr/6YBJ/+mA"+
                                "Sf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEr/6YBJ"+
                                "/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASv/pgUv/6YBJ/+l/SP7pf0j76X9I/el/SP/pf0hg"+
                                "6X9IAOl/SAPqfUcA6X5IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAADqgEgA6X9IAOp+SQDqf0kA6X9IAul/SATpf0gE6X9IBOl/"+
                                "SATpf0gC6X9IAOl+SADpf0gA6YBJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAADnf0sA6H9HAOl/SALpf0gA6X9INul/SPnpf0j+6X9I/el/"+
                                "SP/pgUr/6HtC/+d2O//oeT//6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h5QP/oekH/6HpB"+
                                "/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h5QP/oekH/"+
                                "6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6Hk//+d2O//oe0P/6YFK/+l/SP/pf0j96X9I/ul/SPnp"+
                                "f0g26X9IAOl/SALpgEcA5X9FAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAOmASADpf0gA63xHAet8SADpf0jB6X9I/+l/SPzpf0j/6YBK"+
                                "/+h4Pv/skGD/9cOq//nczf/64NP/+uDS//rg0v/64NL/+uDS//rg0v/539L/+d7Q//nf0v/64NL/"+
                                "+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/539L/+d7Q//nf0v/6"+
                                "4NL/+uDS//rg0v/64NL/+uDS//rg0//53M3/9cOq/+yQYP/oeD7/6YBK/+l/SP/pf0j86X9I/+l/"+
                                "SMDsgUkA7IFKAeh+SADof0gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAA6oBGAOl/SAPpf0gA6X9IR+l/SP/pf0j96X9I/+mBSv/oeD7/"+
                                "8KuG//77+v/////////+////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "/////////////////////////////////v///////vv6//Crhv/oeD7/6YFK/+l/SP/pf0j96X9I"+
                                "/+l/SEbpf0gA6X9IA+yARwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAADpf0gA6X9IA+l/SADpf0ia6X9I/+l/SPvpgEr/6HlA/+6abv//"+
                                "/f3////////9/P///f3///79///+/f///v3///79///+/f///v3///79///9/f///v3///79///+"+
                                "/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///9/f///v3///79"+
                                "///+/f///v3///79///+/f///v3///39///9/P////////39/+6abv/oeUD/6YBK/+l/SPvpf0j/"+
                                "6X9Imel/SADpf0gE6X9IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAOl/SADtfEoA6n5JAOl/SM3pf0j/6X9I/emASv/oeT//+NbE////"+
                                "/////fz/////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "///////////////////////////////////////9/P//////+NbE/+h5P//pgEr/6X9I/el/SP/p"+
                                "f0jN6n1MAOx7UQDpf0cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOt+SADpf0gA6H9JAOl/"+
                                "SADpf0gD6X9IBOl/SATpf0gE6X9IBel9RwHpgEgQ6X9I5+l/SP/pf0n+6X1G/+qFUP/98ev/////"+
                                "///+/v//////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "//////////////////////////////////////7+///////98ev/6oRQ/+l+Rv/pf0n+6X9I/+l/"+
                                "SObpgEgQ6X1IAel/SAXpf0gE6X9IBOl/SATpf0gD6X9IAOl/SADpf0gA6X1IAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADqgEsA6X9IAOl/SADpf0gC6X9I"+
                                "Aul/SADpf0gAAAAAAAAAAADpgEgB6YBIAOmASBDpf0jt6X9I/+mASf7pfUX/64hV//738///////"+
                                "//7+/////////////////////////////////////////////////////v///v3///79///+/f//"+
                                "/v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79/////v//////////////"+
                                "/////////////////////////////////////v7///////738//riFX/6X1F/+mASf7pf0j/6X9I"+
                                "7emBSBDpgEgA6YBIAQAAAAAAAAAA6X9IAOl/SADpf0gC6X9IAul/SADpf0gA6YBLAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6IBGAOl/SADpf0gA6X9IAux+QgDogEkE"+
                                "6X9IQul/SHbpf0h86X9Ie+l/SHzpf0h56YBIg+l/SPbpf0j/6YBJ/ul9Rf/riVb//vf0////////"+
                                "/v7//////////////////////////////////////////////v7///7+////////////////////"+
                                "//////////////////////////////////////////////////////////7+///+/v//////////"+
                                "///////////////////////////////////+/v///////vf0/+uJVv/pfUX/6YBJ/ul/SP/pf0j2"+
                                "6YBIg+l/SHnpf0h86X9Ie+mASHzpf0h26X9IQeqASATnfUgA6X9IAul/SADpf0gA6IBGAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADqfkcA6n5HAOl/SALpf0gA6X9IJel/SMjp"+
                                "f0j/6X9I/ul/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pgEn/6X1F/+uJVv/+9/T////////+"+
                                "/v/////////////////////////////////////////////////++vf/+uPW//nf0v/64NP/+uDS"+
                                "//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NP/+d/S//rj1v/++vf/////////////////"+
                                "//////////////////////////////////7+///////+9/T/64lW/+l9Rf/pgEn/6X9I/+l/SP/p"+
                                "f0j/6X9I/+l/SP/pf0j/6X9I/+l/SP7pf0j/6X9Ix+l/SCTpf0gA6X9IAup+RwDpfkcAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOeETADpf0gB6X9IAOl/SBbpf0jd6X9I/+l/"+
                                "SPvpf0j76X9I++l/SPvpf0j76X9I++l/SPvpf0j/6X9I/+mASf/pfUX/64hU//739P////////7+"+
                                "///////////////////////////////////+/v///////PDq/+2WaP/oekD/6HtC/+h6Qf/oekH/"+
                                "6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oe0L/6HpA/+2WaP/88Or////////+/v//"+
                                "/////////////////////////////////v7///////739P/qiFT/6X1F/+mASf/pf0j/6X9I/+l/"+
                                "SPvpf0j76X9I++l/SPvpf0j76X9I++l/SPzpf0j/6X9I3el/SBbpf0gA6X9IAemDSwAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X9IAOl/SAPpf0gA6X9Ijel/SP/pf0j56X9I"+
                                "/+l/SP/pgEr/6YFK/+mBSv/pgUr/6YBK/+l/SP/pf0j/6YBJ/+l9Rf/riFT//vf0/////////v7/"+
                                "//////////////////////////////////38///////ysZD/53I2/+mCTP/pgEn/6YBJ/+mASf/p"+
                                "gEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgkz/53I2//KxkP////////38////"+
                                "///////////////////////////////+/v///////vf0/+uIVf/pfUX/6YBJ/+l/SP/pf0j/6YBK"+
                                "/+mBSv/pgUr/6YFK/+mASv/pf0j/6X9I/+l/SPnpf0j/6X9Ijel/SADpf0gD6X9IAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0gB6n9HAOt/RgPpf0jW6X9I/+l/SP3pf0j/"+
                                "6X5H/+h4P//oeD7/6Hg+/+h4Pv/oeD//6X9H/+l/SP/pgEn/6X1F/+uJVv/++PT////////+/v//"+
                                "/////////////////////////////////v3//////++hef/oeUD/6oNN/+mBSv/pgUr/6YFK/+mB"+
                                "Sv/pgUr/6YFK/+mBSv/pgUr/6YFK/+mBSv/pgUr/6YFK/+qDTf/oeUD/76J5/////////v3/////"+
                                "//////////////////////////////7+///////+9/T/64hW/+l9Rf/pgEn/6X9I/+l/R//oeD//"+
                                "6Hg+/+h4Pv/oeD7/6Hg//+l/R//pf0j/6X9I/el/SP/pf0jW6IJMA+iBSgDpf0kBAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOmASAHpgEgA6YBIEOl/SO3pf0j/6X9I/ul+R//q"+
                                "g03/8auH//GujP/xrYr/8a6M//Grhv/qgk3/6X5H/+mASf/pfUX/64lW//739P////////7+////"+
                                "///////////////////////////////9/f//////99C7/+d0OP/oeD7/6Hg//+h4Pv/oeD7/6Hg+"+
                                "/+h4Pv/oeD7/6Hg+/+h4Pv/oeD7/6Hg+/+h4Pv/oeD//6Hg+/+d0OP/30Lz////////9/f//////"+
                                "/////////////////////////////v7///////739P/riVb/6X1F/+mASf/pfkf/6oJN//Grhv/x"+
                                "roz/8a2K//GujP/wq4b/6oJN/+l+R//pf0j+6X9I/+l/SO3pgEgQ6YBIAOmASAEAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6YBIAemBSADpgUgQ6X9I7el/SP/pf0n+6X1F/+qH"+
                                "U//53c//+uXZ//ri1v/65dn/+d3O/+qGUv/pfUX/6YBK/+l9Rf/riVb//vf0/////////v7/////"+
                                "////////////////////////////////////////////98+7/++iev/voHf/76B3/++gd//voHf/"+
                                "76B3/++gd//voHf/76B3/++gd//voHf/76B3/++gd//vonr/98+7////////////////////////"+
                                "///////////////////////////+/v///////vf0/+uJVv/pfUX/6YBK/+l9Rf/qhlL/+d3O//rl"+
                                "2f/64tb/+uXZ//ndzv/qhlL/6X1F/+l/Sf7pf0j/6X9I7emBSBDpgUgA6YBIAQAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpgEgB6YFIAOmBSBDpf0jt6X9I/+l/Sf7pfUb/6oZS"+
                                "//jVw//53M3/+drK//nczf/41cP/6oVR/+l9Rv/pgEn/6X1F/+uJVv/+9/T////////+/v//////"+
                                "///////////////////////////////////////+/v//////////////////////////////////"+
                                "//////////////////////////////////////////////////////7+////////////////////"+
                                "//////////////////////////7+///////+9/T/64lW/+l9Rf/pgEn/6X1G/+qFUf/41cP/+dzN"+
                                "//nayv/53M3/+NXD/+qFUf/pfUb/6X9J/ul/SP/pf0jt6YFIEOmBSADpgEgBAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOmASAHpgUgA6YFIEOl/SO7pf0j/6X9J/ul9Rf/qhlL/"+
                                "+NbF//ndz//528z/+d7P//jWxf/qhlH/6X1G/+mASf/pfUX/64lW//739P////////7+////////"+
                                "///////////////////////////////////////////9/f///v3///79///+/f///v3///79///+"+
                                "/f///v3///79///+/f///v3///79///+/f///v3///79///9/f//////////////////////////"+
                                "/////////////////////////v7///////739P/riVb/6X1F/+mASf/pfUb/6oZR//jWxf/53s//"+
                                "+dvM//nez//41sX/6oZR/+l9Rv/pf0n+6X9I/+l/SO7pgUgQ6YFIAOmASAEAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6YBIAemBSADpgUgQ6X9I7ul/SP/pf0n+6X1F/+qGUv/4"+
                                "1sX/+d3P//nbzP/53s//+NbF/+qGUf/pfUb/6YBJ/+l9Rf/riVb//vf0/////////v7/////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "///////////////////////+/v///////vf0/+uJVv/pfUX/6YBJ/+l9Rv/qhlH/+NbF//nez//5"+
                                "28z/+d3P//jWxf/qhlH/6X1G/+l/Sf7pf0j/6X9I7umBSBDpgUgA6YBIAQAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpgEgB6YFIAOmBSBDpf0ju6X9I/+l/Sf7pfUb/6oZS//jW"+
                                "xf/53c//+dvM//nez//41sX/6oZR/+l9Rv/pgEn/6X1F/+uJVv/+9/T////////+/v//////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "//////////////////////7+///////+9/T/64lW/+l9Rf/pgEn/6X1G/+qGUf/41sX/+d7P//nb"+
                                "zP/53c//+NbF/+qGUf/pfUb/6X9J/ul/SP/pf0ju6YFIEOmBSADpgEgBAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAOmASAHpgUgA6YFIEOl/SO7pf0j/6X9J/ul9Rv/qhlH/+NbF"+
                                "//ndz//528z/+d7P//jWxf/qhlH/6X1G/+mASf/pfUX/64lW//739P////////7+////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "/////////////////////v7///////739P/riVb/6X1F/+mASf/pfUb/6oZR//jWxf/53s//+dvM"+
                                "//ndz//41sX/6oZS/+l9Rv/pf0n+6X9I/+l/SO7pgUgQ6YFIAOmASAEAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAA6YBIAemBSADpgUgQ6X9I7ul/SP/pf0n+6X1G/+qGUf/41sX/"+
                                "+d3P//nbzP/53s//+NbF/+qGUf/pfUb/6YBJ/+l9Rf/riVb//vf0/////////v7/////////////"+
                                "/////////////////v3///39///9/f///v3/////////////////////////////////////////"+
                                "///////////////////////////////////////////////+/f///f3///39///+/f//////////"+
                                "///////////////////+/v///////vf0/+uJVv/pfUX/6YBJ/+l9Rv/qhlH/+NbF//nez//528z/"+
                                "+d3P//jWxf/qhlL/6X1G/+l/Sf7pf0j/6X9I7umBSBDpgUgA6YBIAQAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAADpgEgB6YFIAOmBSBDpf0jt6X9I/+l/Sf7pfUb/6oVR//jVw//5"+
                                "3M3/+drK//nczf/41cP/6oVR/+l9Rv/pgEn/6X1F/+uJVv/+9/T////////+/v//////////////"+
                                "///////////+//////////////////////////7/////////////////////////////////////"+
                                "//////////////////////////////////////////7//////////////////////////v//////"+
                                "//////////////////7+///////+9/T/64lW/+l9Rf/pgEn/6X1G/+qFUf/41cP/+dzN//nayv/5"+
                                "3M3/+NXD/+qGUv/pfUb/6X9J/ul/SP/pf0jt6YFIEOmBSADpgEgBAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAOmASAHpgUgA6YFIEOl/SO3pf0j/6X9J/ul9Rf/qhlL/+d3O//rk"+
                                "2f/64tb/+uTZ//ndzv/qhlL/6X1F/+mASv/pfUX/64lW//739P////////7+////////////////"+
                                "///+/v//////+uLV//Cog//wqIP/+uLW/////////v7/////////////////////////////////"+
                                "//////////////////////////////////7+///////64tX/8KiD//Cog//64tX////////+/v//"+
                                "/////////////////v7///////739P/riVb/6X1F/+mASv/pfUX/6oZS//ndzv/65Nn/+uLW//rl"+
                                "2f/53c7/6odT/+l9Rf/pf0n+6X9I/+l/SO3pgUgQ6YFIAOmASAEAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAA6YBIAemBSADpgUgQ6X9I7el/SP/pf0j+6X5H/+qCTf/xrIj/8bCO"+
                                "//GvjP/xsI7/8ayI/+qCTf/pfkf/6YBJ/+l9Rf/riVb//vf0/////////v7//////////////v7/"+
                                "//////zr4v/pgEr/53Y7/+d2O//pgUr//Ovj/////////v7/////////////////////////////"+
                                "///////////////////////////+/v///////Ovj/+mBSv/ndjv/53Y7/+mASv/86+P////////+"+
                                "/v/////////////+/v///////vf0/+uJVv/pfUX/6YBJ/+l+R//qgk3/8ayJ//Gwjv/xrYr/8a6M"+
                                "//Grh//qgk3/6X5H/+l/SP7pf0j/6X9I7emASBDpgEgA6YBIAQAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAADpf0gB6YBJAOiASgPpf0jW6X9I/+l/SP3pf0j/6X9H/+h5P//oeD7/"+
                                "6Hg+/+h4Pv/oeT//6X9H/+l/SP/pgEn/6X1F/+uJVv/+9/T////////+/v/////////////9/P//"+
                                "////9MGn/+d2O//qg07/6oNO/+d2O//0wqj////////9/P//////////////////////////////"+
                                "//////////////////////////38///////0wqf/53Y7/+qDTv/qg07/53Y7//TCp/////////38"+
                                "//////////////7+///////++PT/64lW/+l9Rf/pgEn/6X9I/+l/R//oeT//6Hg+/+h4Pv/oeD7/"+
                                "6Hg//+l+R//pf0j/6X9I/el/SP/pf0jW6YBHA+l/RwDpf0gBAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAOl/SQDpf0gD6X9IAOl/SI7pf0j/6X9I+el/SP/pf0j/6YBK/+mBSv/p"+
                                "gUr/6YFK/+mASv/pf0j/6X9I/+mASf/pfUX/6ohU//739P////////7+//////////////38////"+
                                "///30b3/53M3/+mBSv/pgUr/53M3//fRvv////////38////////////////////////////////"+
                                "/////////////////////////fz///////fRvf/nczf/6YFK/+mBSv/nczf/99G9/////////fz/"+
                                "/////////////v7///////739P/qiFT/6X1F/+mASf/pf0j/6X9I/+mASv/pgUr/6YFK/+mBSv/p"+
                                "gEr/6X9I/+l/SP/pf0j56X9I/+l/SI7pf0gA6X9IA+mARwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAA5IFDAOl/SAHpf0gA6X9IF+l/SN/pf0j/6X9I++l/SPvpf0j76X9I++l/"+
                                "SPvpf0j76X9I++l/SP/pf0j/6YBJ/+l9Rf/riFT//vf0/////////v7/////////////////////"+
                                "///9/P/wqoX/6HpB/+h6Qf/xqob///39////////////////////////////////////////////"+
                                "//////////////////////////////////39//Cqhv/oekH/6HpB//Cqhv///fz/////////////"+
                                "///////////+/v///////vf0/+uIVP/pfUX/6YBJ/+l/SP/pf0j/6X9I++l/SPvpf0j76X9I++l/"+
                                "SPvpf0j76X9I++l/SP/pf0je6n9JF+l/SQDpf0gB54hKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAADqf0oA6n9KAOl/SALpf0gA6X9IJul/SMrpf0j/6X9I/ul/SP/pf0j/6X9I"+
                                "/+l/SP/pf0j/6X9I/+l/SP/pgEn/6X1F/+uIVv/+9/T////////+/v//////////////////////"+
                                "///////+/f/75dr/++bb///+/f//////////////////////////////////////////////////"+
                                "//////////////////////////////////////79//vm2//75tv///79////////////////////"+
                                "//////////7+///////+9/T/64hW/+l9Rf/pgEn/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I"+
                                "/+l/SP7pf0j/6X9Iyul/SCbpf0gA6X9IAul+SADpfUcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAOqASgDpf0gA6X9IAOl/SALcbk0A6oJIBel/SETpf0h46X9IgOl/SH/pf0iA"+
                                "6X9Ifel/SIfpf0j26X9I/+mASf7pfUX/64lW//739P////////7+////////////////////////"+
                                "//7///7+//////////////7+/////v//////////////////////////////////////////////"+
                                "/////////////////////////////////v///v7//////////////v7////+////////////////"+
                                "/////////v7///////739P/riVb/6X1F/+mASf7pf0j/6X9I9ul/SIfpf0h96X9IgOl/SH/pf0iA"+
                                "6X9IeOl/SETpfkgE44RGAOl/SALpf0gA6X9IAOuARQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAOqARwDpf0gA6X9IAOl/SALpf0gC6X9IAOl/SAAAAAAAAAAAAOmASAHp"+
                                "gUgA6YFIEOl/SO3pf0j/6YBJ/ul9Rf/riFX//vf0/////////v7/////////////////////////"+
                                "//////////79///+/f//////////////////////////////////////////////////////////"+
                                "/////////////////////////////////////////v3///79////////////////////////////"+
                                "///////+/v///////vfz/+uIVf/pfUX/6YBJ/ul/SP/pf0jt6YFIEOmASADpgEgBAAAAAAAAAADp"+
                                "f0gA6X9IAOl/SALpf0gC6X9IAOl/SADqfUgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAOl/SADpgEgA6oBIAOmASAHpf0gD6X9IBOl/SATpf0gE6X9IBel8"+
                                "RwHpgEgQ6X9I5+l/SP/pf0n+6X1G/+qFUP/98ez////////+/v//////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "//////7+///////98ev/6oVQ/+l9Rv/pf0n+6X9I/+l/SObpgEgQ6XxHAel/SAXpf0gE6X9IBOl/"+
                                "SATpf0gD6X9IAel/SADpf0gA6n9IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0cA5XhT"+
                                "AOh9SwDpf0jN6X9I/+l/SP3pgEr/6HlA//jWxf////////38////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "/////fz///////jWxf/oeUD/6YBK/+l/SP3pf0j/6X9Izex9RwDxekUA6X9IAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SADpf0gD"+
                                "6X9IAOl/SJvpf0j/6X9I++mASv/oeUD/7ptw///+/f////////38///9/f///v3///39///+/f//"+
                                "/v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///79///+"+
                                "/f///v3///79///+/f///v3///79///+/f///v3///79///+/f///v3///39///+/f///f3///38"+
                                "/////////v3/7ptv/+h5QP/pgEr/6X9I++l/SP/pf0ia6X9IAOl/SAPpgEgAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6oFKAOl/SAPp"+
                                "f0gA6X9IR+l/SP/pf0j96X9I/+mBSv/oeD7/8ayI//78+v/////////+////////////////////"+
                                "////////////////////////////////////////////////////////////////////////////"+
                                "/////////////////////////////////////////////////////////////////////v//////"+
                                "/vz6//GsiP/oeD7/6YFK/+l/SP/pf0j96X9I/+l/SEfpf0gA6X9IA+qARgAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpgEgA6X9IAOZ/"+
                                "RgDmfkYA6X9Iwul/SP/pf0j86X9I/+mASv/oeD7/7JFh//XFrP/53c//+d/S//ne0P/64NL/+uDS"+
                                "//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/"+
                                "+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//rg0v/64NL/+uDS//ne0P/539L/+d3P//XFq//s"+
                                "kWH/6Hg+/+mASv/pf0j/6X9I/Ol/SP/pf0jB6YBIAOmASADpf0gA6X9JAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOh6RwDpf0cA6X9I"+
                                "Aul/SADpf0g36X9I+ul/SP7pf0j96X9I/+mBSv/oe0L/53Y7/+h5QP/oekH/6HlA/+h6Qf/oekH/"+
                                "6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/o"+
                                "ekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HpB/+h6Qf/oekH/6HlA/+h6Qf/oeUD/53Y7/+h7"+
                                "Qv/pgUr/6X9I/+l/SP3pf0j+6X9I+ul/SDfpf0gA6X9IAuh/RwDngEoAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SADpgEcA"+
                                "6X9IA+mASADpf0hi6X9I/+l/SP3pf0j76X9I/umASf/pgUv/6YBK/+mASv/pgEr/6YBJ/+mASf/p"+
                                "gEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mA"+
                                "Sf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEn/6YBJ/+mASf/pgEr/6YBK/+mASv/pgUv/6YBJ"+
                                "/+l/SP7pf0j76X9I/el/SP/pf0hi6X9IAOl/SAPqgEcA6X9IAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6oBIAOl/SADq"+
                                "fkgA6X9IA+l/SADpf0hZ6X9I9el/SP/pf0j+6X9I++l/SPzpf0j/6X9I/+l/SP/pf0j/6X9I/ul/"+
                                "SPzpf0j86X9I/Ol/SPzpf0j86X9I/Ol/SPzpf0j86X9I/Ol/SPzpf0j86X9I/Ol/SPzpf0j86X9I"+
                                "/Ol/SPzpf0j86X9I/Ol/SPzpf0j86X9I/Ol/SPzpf0j+6X9I/+l/SP/pf0j/6X9I/+l/SPzpf0j7"+
                                "6X9I/ul/SP/pf0j16X9IW+l/SADpf0gD6YBIAOl/SADpfUgAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X5JAOZ8"+
                                "SgDmfEoA6X9IA+l+SADpf0gl6X9IrOl/SPrpf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I"+
                                "/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/"+
                                "6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/+l/SP/p"+
                                "f0j76X9IrOl/SCbpf0gA6X9IA+d+RwDnfkcA6X9IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6H9I"+
                                "AOd/RwDmf0YA6X9IA+p/SAHrf0gA6X9IJel/SGrpf0i16X9I/+l/SP7pf0j+6X9I/+l/SO3pf0i7"+
                                "6X9Ivul/SL7pf0i+6X9Ivul/SL7pf0i+6X9Ivul/SL7pf0i+6X9Ivul/SL7pf0i+6X9Ivul/SL7p"+
                                "f0i+6X9Ivul/SL7pf0i+6X9Ivul/SL7pf0i76X9I7el/SP/pf0j+6X9I/ul/SP/pf0i16X9Iaul/"+
                                "SCfnfkYA6H5IAel/SAPogEcA6H9HAOl/SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "6X9HAOl/SQDpf0kA6X9IAul/SAPpf0gD6X9IAOl/SEDpf0j/6X9I/el/SPzpf0j/6X9Iu+l/SADp"+
                                "f0gD6X9IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAADpf0gA6X9IA+l/SADpf0i76X9I/+l/SPzpf0j96X9I/+l/SEDpf0gA6X9I"+
                                "A+l/SAPpf0gC6X9IAOl/SADpgEgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAA6n9FAOh/SADmgEoA6H9JAOl/SAXpf0gA6X9IQ+l/SP/pf0j96X9I/Ol/SP/pf0i76X9IAOl/"+
                                "SAXpf0gD6X9IAul/SALpf0gC6X9IAul/SALpf0gC6X9IAul/SALpf0gC6X9IAul/SALpf0gC6X9I"+
                                "Aul/SALpf0gC6X9IAul/SAPpf0gF6X9IAOl/SLvpf0j/6X9I/Ol/SP3pf0j/6X9IQ+l/SADpf0gF"+
                                "6oBKAOuASwDpf0gA6n9GAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAADpfkgA6X9IA+l/SADpf0hA6X9I/+l/SP3pf0j86X9I/+l/SLvpf0gA6X9I"+
                                "A+l/SADpf0gA6X9IAOl/SADpf0gA6X9IAOl/SADpf0gA6X9IAOl/SADpf0gA6X9IAOl/SADpf0gA"+
                                "6X9IAOl/SADpf0gA6X9IAOl/SAPpf0gA6X9Iu+l/SP/pf0j86X9I/el/SP/pf0hA6X9IAOl/SAPp"+
                                "fkcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAA6X9IAO96SgDpf0gD6X9IAOl/SELpf0j/6X9I/el/SPzpf0j/6X9Iu+l/SADpf0gD"+
                                "539JAOl/SADqf0kAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAA6YBIAOl/SADogEgA6X9IA+l/SADpf0i76X9I/+l/SPzpf0j96X9I/+l/SELpf0gA6X9IA+Z6"+
                                "PwDpf0kAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAOl/SADpf0gA6H9IAel/SAbpf0gA6X9IQOl/SP/pf0j96X9I/Ol/SP/pf0i76X9IAOl/SATp"+
                                "f0gC6YBIAOmASADnfUgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOt9"+
                                "RQDpf0gA6X9IAOl/SALpf0gE6X9IAOl/SLvpf0j/6X9I/Ol/SP3pf0j/6X9IQOl/SADpf0gG6X9I"+
                                "Ael/SADpf0gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADp"+
                                "gEgA6IBIAOmASADpf0gD6X9IAOl/SDbpf0i+6X9I/+l/SP7pf0j+6X9I/+l/SPHpf0h46H9JDOZ+"+
                                "SQDpf0gC6X9IAOl/SADqfEsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADrgEkA6YBJ"+
                                "AOmASQDpgEgC6H9HAOiASAvpf0h46X9I8el/SP/pf0j+6X9I/ul/SP/pf0i+6X9IN+l/SADpf0gD"+
                                "6X9IAOl/RwDpf0gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6oBJAOh/"+
                                "RwDpf0oA6X9HAumARgDpf0iB6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9I/el/SP/pf0jW6X9I"+
                                "KOl/SADpf0gC6YBIAOl/SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SADpf0gA"+
                                "6X9IAumASQDpgEgp6X9I1ul/SP/pf0j+6X9I/+l/SP/pf0j/6X9I/+l/SP/pf0j/6X9Igeh/SADo"+
                                "f0gC6n9IAOh/SADqgEcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpgEgA6IFI"+
                                "AOl/SAPpfkgA6X9Igul/SP/pf0j76X9I/Ol/SP/pgEn/6YBK/+l/Sf/pf0j+6X9I+ul/SP/pf0ji"+
                                "6X9IH+l/SADpf0gC6X9IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6oBIAOl/SALp"+
                                "f0gA6X9IH+l/SOLpf0j/6X9I+ul/SP7pf0n/6YBK/+mASf/pf0j/6X9I/Ol/SPvpf0j/6X9Igul/"+
                                "SADpf0gD6YBIAOl/RwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl+RwDpf0gD"+
                                "6X9IAOl/SD7pf0j/6X9I/Ol/SP7pf0j/6YBK/+h7Qv/oeD7/6X5H/+mASf/pf0j/6X9I+ul/SP/p"+
                                "f0iv6X9IAOl/RwHpf0gA6X9HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SQDpf0gA6X9IAemA"+
                                "SADpf0iw6X9I/+l/SPrpf0j/6YBJ/+l+R//oeD7/6HtC/+mASv/pf0j/6X9I/ul/SPzpf0j/6X9I"+
                                "Pul/SADpf0gD6H9IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6YBIAOl+SALp"+
                                "fkgA6X9IsOl/SP/pf0j76X9I/+l/SP/oeUD/7JJj/+6edf/pgkz/6HtC/+mASf/pf0j/6X9I/el/"+
                                "SP/pf0g56X9IAOl/SAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SAPpf0gA6X9I"+
                                "Oel/SP/pf0j96X9I/+mASf/oe0L/6oJM/+6edf/skmP/6HlA/+l/SP/pf0j/6X9I++l/SP/pf0iw"+
                                "6X9IAOl/SALpf0cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0gB6X9IAOl/"+
                                "SBfpf0ju6X9I/+l/SP7pgEr/6HlA//O8n/////////////vq4f/rjVz/6HxD/+mASf/pf0j76X9I"+
                                "/+l/SIPpf0gA6X9IBOl9SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADqfkgA6X9IBOl/SADpf0iD"+
                                "6X9I/+l/SPvpgEn/6HxD/+uNXP/76uH////////////zvJ//6HlA/+mASv/pf0j+6X9I/+l/SO7p"+
                                "f0gW6X9IAOl/SAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SAPpf0gA6X9I"+
                                "N+l/SP/pf0j+6YBJ/+h7Qv/sk2X///37/////////Pv///////bMt//odz3/6YFK/+l/SPzpf0j/"+
                                "6X9Irul/SADpf0gD6X9IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SADpf0gD6X9IAOl/SK/p"+
                                "f0j/6X9I/OmBSv/oeD3/9s23/////////Pv////////8+//sk2T/6HtC/+mASf/pf0j+6X9I/+l/"+
                                "SDfpf0gA6X9IAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X9IA+l/SADpf0g+"+
                                "6X9I/+l/SP3pgEr/6Hg+/+6fdf///////vz6//78+v//////+dzM/+h5P//pgEr/6X9I/Ol/SP/p"+
                                "f0i46X9IAOl/SAPpgEgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6X9IAOl/SAPpf0gA6X9Iuel/"+
                                "SP/pf0j86YBK/+h5P//53M3///////78+v/+/Pr//////+6fdf/oeD7/6YBK/+l/SP3pf0j/6X9I"+
                                "Pul/SADpf0gDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0gC6X9IAOl/SCnp"+
                                "f0j86X9I/+l/Sf7pfkb/6oNO//vq4P////////38///////ysZD/6Hg9/+mBSv/pf0j76X9I/+l/"+
                                "SJ3pf0gA6X9IA+mASAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0gA6X9IA+l/SADpf0id6X9I"+
                                "/+l/SPvpgUr/6Hg9//KxkP////////38///////76uD/6oNO/+l+Rv/pf0n+6X9I/+l/SPvpf0gp"+
                                "6X9IAOl/SAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SAHpgEgA6YBIBOl/"+
                                "SNjpf0j/6X9I/emASf/oe0L/7I9f//fRvf/64NL/8rGQ/+h7Q//pf0j/6X9I/+l/SPvpf0j/6X9I"+
                                "Yul/SADpf0gEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0gE6X9IAOl/SGPpf0j/"+
                                "6X9I++l/SP/pf0j/6HtD//KxkP/64NL/99G9/+yPXv/oe0L/6YBJ/+l/SP3pf0j/6X9I1+iARwTp"+
                                "gEcA6X9IAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6oBJAOl/SATpf0gA6X9I"+
                                "ful/SP/pf0j66X9I/+mASf/ofEP/6Hc9/+h5P//oeD7/6X9I/+l/SP/pf0j96X9I/+l/SOfpf0cU"+
                                "6X9HAOl/SAHgkE4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8YRFAOl/SAHpf0gA6YBIFel/SOjp"+
                                "f0j/6X9I/el/SP/pf0j/6Hg+/+h5P//odz3/6HxD/+mASf/pf0j/6X9I+ul/SP/pf0h+6X9IAOl/"+
                                "SAPpgkcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpf0cA6X9IAel/RwDpf0cO"+
                                "6X9I1ul/SP/pf0j66X9I/+mASf/pgUr/6YBK/+mBSv/pf0j/6X9I/el/SPrpf0j/6X9Iael/SADp"+
                                "f0gD6H9HAOx7RgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADnfkkA6H9IAOl/SAPpf0gA6X9Iael/"+
                                "SP/pf0j66X9I/el/SP/pgUr/6YBK/+mBSv/pgEn/6X9I/+l/SPrpf0j/6X9I1emASQ3pgEkA6X9I"+
                                "Aep+SQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOmASQDrgUgA6X9IAul/SADp"+
                                "f0gt6X9I6Ol/SP/pf0j96X9I/Ol/SP3pf0j96X9I/Ol/SP3pf0j96X9I/+l/SI/pf0gA6n9IAuh/"+
                                "SADqf0gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpgEgA6n5HAOl/SQLpf0kA6X9I"+
                                "j+l/SP/pf0j96X9I/el/SPzpf0j96X9I/el/SPzpf0j96X9I/+l/SOjpf0gt6X9IAOl/SALogEgA"+
                                "6IBIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/SADpf0gA6X9IAumA"+
                                "SADpgEgf6X9Itel/SP/pf0j/6X9I/+l/SP/pf0j+6X9I/+l/SOrpf0hl6IFIAOmASALpf0gA535G"+
                                "AOh/RwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl+SADofUcA6n9HAOh/SQLmgE0A"+
                                "6X9IZel/SOrpf0j/6X9I/ul/SP/pf0j/6X9I/+l/SP/pf0i16X5HH+l+SADpf0gC6X9IAOl/SAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA539IAOl/SADpf0gA6X9I"+
                                "AuiASQH/ZB8A6X9IPul/SJPpf0i/6X9IyOl/SK7pf0hs6YBIFel/SADpf0gD6X9IAel/SADpf0gA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOl/RwDpf0gA6X9IAel/SAPp"+
                                "f0gA6X9IFel/SGzpf0iu6X9IyOl/SL/pf0iT6X9IPv+uegDogEgB6X9IAumASADpgEgA6n9IAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////9IAAAAAA"+
                                "AAABL////////+kAAAAAAAAAAJf////////SAAAAAAAAAABL////////xAAAAAAAAAAAI///////"+
                                "/8gAAAAAAAAAABP///////+QAAAAAAAAAAAJ////////kAAAAAAAAAAACf///////6AAAAAAAAAA"+
                                "AAX///////+gAAAAAAAAAAAF////////oAAAAAAAAAAABf///////6AAAAAAAAAAAAX///////+g"+
                                "AAAAAAAAAAAF////////oAAAAAAAAAAABf///////6AAAAAAAAAAAAX///////+gAAAAAAAAAAAF"+
                                "////9C9CoAAAAAAAAAAABUL0L+kWiSAAAAAAAAAAAASRaJf0VqKgAAAAAAAAAAAFRWov6CZBIAAA"+
                                "AAAAAAAABIJkF8gWgSAAAAAAAAAAAASBaBPIFoEgAAAAAAAAAAAEgWgTyBaBIAAAAAAAAAAABIFo"+
                                "E8gWgSAAAAAAAAAAAASBaBPIEIEgAAAAAAAAAAAEgQgTyBCBIAAAAAAAAAAABIEIE8gQgSAAAAAA"+
                                "AAAAAASBCBPoCQEgAAAAAAAAAAAEgJAX6AABIAAAAAAAAAAABIAAF+QAAiAAAAAAAAAAAARAACfk"+
                                "AAAgAAAAAAAAAAAEAAAn6gAFIAAAAAAAAAAABKAAV/QAAqAAAAAAAAAAAAVAAC/6QCWgAAAAAAAA"+
                                "AAAFpAJf/SBLoAAAAAAAAAAABdIEv/4gR6AAAAAAAAAAAAXiBH//oF+gAAAAAAAAAAAF+gX//6Bf"+
                                "oAAAAAAAAAAABfoF//+gX6AAAAAAAAAAAAX6Bf//oF+gAAAAAAAAAAAF+gX//6BfoAAAAAAAAAAA"+
                                "BfoF//+gX6AAAAAAAAAAAAX6Bf//oF+gAAAAAAAAAAAF+gX//6BfoAAAAAAAAAAABfoF//+gX6AA"+
                                "AAAAAAAAAAX6Bf//oF+gAAAAAAAAAAAF+gX//6BfoAAAAAAAAAAABfoF//+gX6AAAAAAAAAAAAX6"+
                                "Bf/+oFegAAAAAAAAAAAF6gV//SBLoAAAAAAAAAAABdIEv/oABaAAAAAAAAAAAAWgAF/1AAqgAAAA"+
                                "AAAAAAAFUACv6gAFIAAAAAAAAAAABKAAV+QAAiAAAAAAAAAAAARAACfkAAIgAAAAAAAAAAAEQAAn"+
                                "6AABIAAAAAAAAAAABIAAF8gAAAAAAAAAAAAAAAAAABPIAAAAAAAAAAAAAAAAAAATyAAAAAAAAAAA"+
                                "AAAAAAAAE8gAAAAAAAAAAAAAAAAAABPIAAAAAAAAAAAAAAAAAAAT6AAAAAAAAAAAAAAAAAAAF+gA"+
                                "AX///+gAABf///6AABfkAAIAAAAIAAAQAAAAQAAn4gAEf//QCAAAEAv//iAAR/EACP//JegAABek"+
                                "//8QAI/0gBL//ogAAAAAEX//SAEv+gBF//0gAAAAAAS//6IAX/2Wm//9QAAAAAACv//Jab//QC//"+
                                "+oAAAAAAAV//9AL///////kAAAAAAACf///////////5AAAAAAAAn///////////8gAAAAAAAE//"+
                                "//////////IAAAAAAABP///////////yAAAAAAAAT//////////6AAAAAAAAAABf////////9LQA"+
                                "AAAAAAAtL////////+gAAAAAAAAAABf////////UAAAAAAAAAAAr////////yAAAAAAAAAAAE///"+
                                "/////8gAAAAAAAAAABP////////QAAAAAAAAAAAL////////0AAAAAAAAAAAC////////9AAAAAA"+
                                "AAAAAAv////////QAAAAAAAAAAAL////////0AAAAAAAAAAAC////////9AAAAAAAAAAAAv/////"+
                                "///QAAAAAAAAAAAL////////0AAAAAAAAAAAC////////9AAAAAAAAAAAAv////////QAAAAAAAA"+
                                "AAAL////////0AAAAAAAAAAAC////////9AAAAAAAAAAAAv////////QAAAAAAAAAAAL////////"+
                                "yAAAAAAAAAAAE////////8gAAAAAAAAAABP////////UAAAAAAAAAAAr////////6AAAAAAAAAAA"+
                                "F/////////S0AAAAAAAALS/////////6AAAAAAAAAABf//////////IAAAAAAABP///////////y"+
                                "AAAAAAAAT///////////8gAAAAAAAE////////////kAAAAAAACf///////////5AAAAAAAAn///"+
                                "////////+oAAAAAAAV////////////1AAAAAAAK////////////9IAAAAAAEv////////////ogA"+
                                "AAAAEX////////////8iBP//IET/////////////0gQAACBL//////////////oEAAAgX///////"+
                                "///////iBX/+oEf/////////////0gS//SBL/////////////6QBX/qAJf////////////+IAK/1"+
                                "ABH/////////////EABP8gAI/////////////yAAT/IABP////////////8gAC/0AAT/////////"+
                                "////QAAn5AAC/////////////0AAJ+QAAv////////////9AACfkAAL/////////////QAAn5AAC"+
                                "/////////////0AAL/QAAv////////////8gAC/0AAT/////////////IABP8gAE////////////"+
                                "/9AAj/EAC/////////////+oAS/0gBX/////////////0AJf+kAL//////8=")),0,$$.Length)))))
#endregion
$Form1.TransparencyKey = [System.Drawing.Color]::FromArgb(([System.Int32](([System.Byte](255)))), ([System.Int32](([System.Byte](128)))), ([System.Int32](([System.Byte](128)))))
$Form1.add_Load({Form1Load($Form1)})

#endregion

#region Custom Code
     # Site configuration
                $SiteCode = $SiteCode # Site code 
                $ProviderMachineName = $siteserver # SMS Provider machine name

                # Customizations
                $initParams = @{}
                #$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
                #$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

                # Do not change anything below this line

                # Import the ConfigurationManager.psd1 module 
                if((Get-Module ConfigurationManager) -eq $null) {
                    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
                }

                # Connect to the site's drive if it is not already present
                if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
                    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
                }

                # Set the current location to be the site code.
                Set-Location "$($SiteCode):\" @initParams

                 # email function below 

                        Function Send-Mail
                        {
                            Param (
                                [Parameter(Mandatory=$False, 
                                           ValueFromPipeline=$true,
                                           ValueFromPipelineByPropertyName=$true, 
                                           Position=0,
                                           ParameterSetName='Parameter Set 1')]
                                [ValidateNotNullOrEmpty()] 
                                [string[]]$To,

                                [Parameter(Mandatory=$False,
                                           Position=1,
                                           ParameterSetName='Parameter Set 1')]
                                           [Alias("Copy")]
                                [string[]]$CC,
                                [Parameter(Mandatory=$False,
                                           Position=1,
                                           ParameterSetName='Parameter Set 1')]
                                           [Alias("Black")]
                                [string[]]$BCC,
                                [Parameter(Mandatory=$false,
                                           Position=2,
                                           ParameterSetName='Parameter Set 1')]
                                $From = "$($env:username)@domain.com" ,
                                $subject = "Mail triggered from Script",
                                $body,
                                $Attachment,
                                [Alias("HTML")]
                                [Switch]$AsHtml,

                                $SMTPServer = $SMTP
                            )

                            Begin
                            {
                                $MailMessage = New-Object System.Net.Mail.MailMessage 
		                        $SMTPClient = New-Object System.Net.Mail.smtpClient

                                $MailMessage.Sender = $From
		                        $MailMessage.From = $From

                                Function Check-Format
                                {
                                    Param ($Data)
            
                                    If ($Data -contains ",")
                                    {
                                        $Data = $Data.Split(",")
                                    }
                                    ElseIf ($Data -contains ";")
                                    {
                                        $Data = $Data.Split(";")
                                    }

                                    Return $Data
                                }
                            }

                            Process
                            {

                                $SMTPClient.host = $SMTPServer
		        
                                If ($subject)
                                {
		                            $MailMessage.Subject = $subject
                                }

		                        If ($Attachment)
                                {
                                    Foreach ($File in $Attachment)
                                    {
                                        $MailMessage.Attachments.Add($File)
                                    }
                                }

                                If ($To)
                                {
                                    $To = Check-Format -Data $To
		                            $To | % {$MailMessage.To.add($_)}
                                }	
                                If ($CC)
                                {
                                    $CC = Check-Format -Data $CC
                                    $CC | % {$MailMessage.CC.add($_)}
                                }
                                If ($Bcc)
                                {
                                    $BCC = Check-Format -Data $BCC
		                            $BCC | % {  $MailMessage.BCC.add($_)}
                                }
		
                                If ($Body)
                                {
                                    $MailMessage.Body = $body
		                        }
        
                                If ($AsHtml)
                                {
                                    $MailMessage.IsBodyHtml = $true
		                        }
                            }

                            End
                            {
                                $SMTPClient.Send($MailMessage)
                            }
                        }
#endregion

#region Event Loop

function Main{
[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::Run($Form1)
}

#endregion

#endregion

#region Event Handlers

function Form1Load( $object ){

}

function exitmenuclicked($object){
$Form1.Close()
}

function aboutmenuclicked($Object){
  $aboutForm = New-Object System.Windows.Forms.Form
  $aboutForm.Text = "About"
  $aboutForm.Size = New-Object System.Drawing.Size(300,200)
  $aboutForm.StartPosition = "CenterScreen"
  $aboutForm.Topmost = $true

  $aboutTextBox = New-Object System.Windows.Forms.TextBox
  $aboutTextBox.Multiline = $true
  $aboutTextBox.ReadOnly = $true
  $aboutTextBox.Font = New-Object System.Drawing.Font("Verdana", 7.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
  $aboutTextBox.Text = @"
SCCM Application Deployment Tool
Copyright (c) 2024 by Praveen Kumar, Antony
Co-Authors: C H, Sunil

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
"@

  $aboutTextBox.Dock = "Fill"

  $aboutForm.Controls.Add($aboutTextBox)
  $aboutForm.Add_Shown({ $aboutForm.Activate() })
  $aboutForm.ShowDialog()
}

function helpmenuclicked($object){
  Start-Process "https://github.com/Praveenn-Ak/MECMDeploymentKit"
}

function Add_TextTXT_collId($object){
 
}

function ExitClick( $object ){
$Form1.Close()
}

function Add_TextChangedTxt_app_name( $object ){
           

           if($Combo_Tech.SelectedItem -eq "Package"){ 
            $PckgID = $Txt_app_name.Text
            $programs = (Get-CMProgram -PackageId $PckgID).Programname
            foreach ($prgrm in $programs) {$Comb_deploy_act.Items.Add($prgrm)}
            }

            elseif($Combo_Tech.SelectedItem -eq "Application"){ 
           
            
            }
            
            elseif($Combo_Tech.SelectedItem -eq "Task Sequence"){ 
           
           $TSID = $Txt_app_name.Text 
           $programs = (Get-CMTaskSequence -Fast -TaskSequencePackageId $TSID).Name
            foreach ($prgrm in $programs) {$Comb_deploy_act.Items.Add($prgrm)}
            
            
            }
}

function Comb_deploy_actSelectedIndexChanged( $object ){
    
    $Combo_Deploy_purpose.SelectedIndex = -1
    if($Comb_deploy_act.SelectedItem -eq "Uninstall" -and $Combo_Tech.SelectedItem -eq "Application"){
    $Combo_Deploy_purpose.Items.Clear()
    $Combo_Deploy_purpose.Items.AddRange([System.Object[]](@("Required")))
    
    }elseif($Comb_deploy_act.SelectedItem -eq "Install" -and $Combo_Tech.SelectedItem -eq "Application"){
    $Combo_Deploy_purpose.Items.Clear()
    $Combo_Deploy_purpose.Items.AddRange([System.Object[]](@("Available","Required")))
    
    }else{
    $Combo_Deploy_purpose.Items.Clear()
    $Combo_Deploy_purpose.Items.AddRange([System.Object[]](@("Available","Required")))
    }

}

function Combo_Deploy_purposeSelectedIndexChanged( $object ){

if($Combo_Tech.SelectedItem -eq "Application"){


                    $Form1.Controls.Remove($LBL_Notification_settings)
                    $Form1.Controls.Remove($CheckBox_TS_Progress)
                    $Form1.Controls.Remove($CheckBox_TS_software_install)

            if($Combo_Deploy_purpose.SelectedItem -eq "Available"){

                $Form1.Controls.Remove($time_expiry)
                $Form1.Controls.Remove($LBL_exp_tme)
                $Form1.Controls.Remove($checkBx_expryUTC)
                $form1.Controls.Remove($LBL_req_tme)
                $form1.Controls.Remove($Time_required)
                $form1.Controls.Remove($Checkbx_reqdUTC)

            }elseif($Combo_Deploy_purpose.SelectedItem -eq "Required"){

                $form1.Controls.Add($LBL_req_tme)
                $form1.Controls.Add($Time_required)
                $form1.Controls.Add($Checkbx_reqdUTC)                    
            }

}elseif($Combo_Tech.SelectedItem -eq "Package")
        {
        if($Combo_Deploy_purpose.SelectedItem -eq "Available")
        {

                             $form1.Controls.Remove($LBL_req_tme)
                             $form1.Controls.Remove($Time_required)
                             $form1.Controls.Remove($Checkbx_reqdUTC)

                             $Form1.Controls.Remove($LBL_Notification_settings)
                             $Form1.Controls.Remove($CheckBox_TS_software_install)

                             $Form1.Controls.Remove($time_expiry)
                             $Form1.Controls.Remove($LBL_exp_tme)
                             $Form1.Controls.Remove($checkBx_expryUTC)


                    }elseif($Combo_Deploy_purpose.SelectedItem -eq "Required")
                            {

                              $Form1.Controls.Add($LBL_Notification_settings)
                              $Form1.Controls.Add($CheckBox_TS_software_install)
                                                           
                             $form1.Controls.Add($LBL_req_tme)
                             $form1.Controls.Add($Time_required)
                             $form1.Controls.Add($Checkbx_reqdUTC)

                                 $Form1.Controls.Add($time_expiry)
                                 $Form1.Controls.Add($LBL_exp_tme)
                                 $Form1.Controls.Add($checkBx_expryUTC)

                            }

}

elseif($Combo_Tech.SelectedItem -eq "Task Sequence")
        {
        if($Combo_Deploy_purpose.SelectedItem -eq "Available")
                {
                    $Form1.Controls.Add($LBL_Notification_settings)
                    $Form1.Controls.Add($CheckBox_TS_Progress)
                    $form1.Controls.Remove($CheckBox_TS_software_install)
                    
                    $form1.Controls.Remove($LBL_req_tme)
                    $form1.Controls.Remove($Time_required)
                    $form1.Controls.Remove($Checkbx_reqdUTC)

                    $Form1.Controls.Remove($time_expiry)
                    $Form1.Controls.Remove($LBL_exp_tme)
                    $Form1.Controls.Remove($checkBx_expryUTC)


                    }elseif($Combo_Deploy_purpose.SelectedItem -eq "Required")
                            {

                                 $Form1.Controls.Add($LBL_Notification_settings)
                                 $Form1.Controls.Add($CheckBox_TS_software_install)
                                 $Form1.Controls.Add($CheckBox_TS_Progress)
                             
                                 $form1.Controls.Add($LBL_req_tme)
                                 $form1.Controls.Add($Time_required)
                                 $form1.Controls.Add($Checkbx_reqdUTC)

                                 $Form1.Controls.Add($time_expiry)
                                 $Form1.Controls.Add($LBL_exp_tme)
                                 $Form1.Controls.Add($checkBx_expryUTC)

                            }

            }

}

function Combo_TechSelectedIndexChanged( $object ){
    $Comb_deploy_act.Items.Clear()
    $Txt_app_name.Text = ""
    $TXT_collId.Text = ""
    $Combo_Deploy_purpose.SelectedIndex = -1
    $Comb_deploy_act.SelectedIndex = -1
    $technology = $Combo_Tech.SelectedItem
   
    Switch($technology){
"Package"{
        
        $Form1.Controls.Add($Checkbox_usercollection)
        $TXT_collId.Size = New-Object System.Drawing.Size(185, 23)

        $LBL_Deploy_action.Text = "Program Name"
        $Form1.Controls.Add($Txt_app_name)
        $LBL_App_name.Text = "Package ID"
        $Form1.Controls.Add($LBL_App_name)

        $Form1.Controls.Add($TXT_collId)
        $Form1.Controls.Add($LBL_CollID)

        $Form1.Controls.Add($Comb_deploy_act)
        $Form1.Controls.Add($LBL_Deploy_action)
        
        $Form1.Controls.Add($Combo_Deploy_purpose)
        $Form1.Controls.Add($LBL_Purpose)
        
        $Form1.Controls.Add($Time_available)
        $Form1.Controls.Add($LBL_Avlbl_tme)
        $Form1.Controls.Add($Checkbox_availableUTC)

        $LBL_req_tme.Text = "Assignment Schedule"
        $Form1.Controls.Add($Time_required)
        $Form1.Controls.Add($LBL_req_tme)
        $Form1.Controls.Add($Checkbx_reqdUTC)

        $Form1.Controls.Add($time_expiry)
        $Form1.Controls.Add($LBL_exp_tme)
        $Form1.Controls.Add($checkBx_expryUTC)

        $Form1.Controls.Add($Checkbx_MTW_Reboot)
        $Form1.Controls.Add($CHKBX_MTW_SW_install)
        $Form1.Controls.Add($LBL_mtw)
        }
"Task Sequence"{


                    $Form1.Controls.Remove($Checkbox_usercollection)
                    $TXT_collId.Size = New-Object System.Drawing.Size(284, 23)

            $LBL_Deploy_action.Text = "Task Sequence Name"
            $Form1.Controls.Add($Txt_app_name)
            $LBL_App_name.Text = "Task Sequene ID"
            $Form1.Controls.Add($LBL_App_name)

            $Form1.Controls.Add($TXT_collId)
            $Form1.Controls.Add($LBL_CollID)

            $Form1.Controls.Add($Comb_deploy_act)
            $Form1.Controls.Add($LBL_Deploy_action)
            
            $Form1.Controls.Add($Combo_Deploy_purpose)
            $Form1.Controls.Add($LBL_Purpose)
            
            $Form1.Controls.Add($Time_available)
            $Form1.Controls.Add($LBL_Avlbl_tme)
            $Form1.Controls.Add($Checkbox_availableUTC)

            $LBL_req_tme.Text = "Assignment Schedule"
            $Form1.Controls.Add($Time_required)
            $Form1.Controls.Add($LBL_req_tme)
            $Form1.Controls.Add($Checkbx_reqdUTC)

            $Form1.Controls.Add($time_expiry)
            $Form1.Controls.Add($LBL_exp_tme)
            $Form1.Controls.Add($checkBx_expryUTC)

            $Form1.Controls.Add($Checkbx_MTW_Reboot)
            $Form1.Controls.Add($CHKBX_MTW_SW_install)
            $Form1.Controls.Add($LBL_mtw)


            }
"Application"{

                    $Form1.Controls.Add($Checkbox_usercollection)
                    $TXT_collId.Size = New-Object System.Drawing.Size(185, 23)

            $LBL_Deploy_action.Text = "Deployment Action"
            $Comb_deploy_act.Items.AddRange([System.Object[]](@("Install", "Uninstall")))
            $Form1.Controls.Add($Txt_app_name)
            $LBL_App_name.Text = "Application Name"
            $Form1.Controls.Add($LBL_App_name)

            $Form1.Controls.Add($TXT_collId)
            $Form1.Controls.Add($LBL_CollID)

            $Form1.Controls.Add($Comb_deploy_act)
            $Form1.Controls.Add($LBL_Deploy_action)
            
            $Form1.Controls.Add($Combo_Deploy_purpose)
            $Form1.Controls.Add($LBL_Purpose)
            
            $Form1.Controls.Add($Time_available)
            $Form1.Controls.Add($LBL_Avlbl_tme)
            $Form1.Controls.Add($Checkbox_availableUTC)

            $LBL_req_tme.Text = "Installation Deadline"
            $Form1.Controls.Add($Time_required)
            $Form1.Controls.Add($LBL_req_tme)
            $Form1.Controls.Add($Checkbx_reqdUTC)

            $Form1.Controls.Add($Checkbx_MTW_Reboot)
            $Form1.Controls.Add($CHKBX_MTW_SW_install)
            $Form1.Controls.Add($LBL_mtw)

            $Form1.Controls.Remove($time_expiry)
            $Form1.Controls.Remove($LBL_exp_tme)
            $Form1.Controls.Remove($checkBx_expryUTC)
            

                         }

                       }

}

function ValidateClick( $object ){
$Displaylog.Clear()
$global:Flag = 'No'

        if(!($CMBO_email.SelectedItem -eq $null)){
        
        if($Combo_Tech.SelectedItem -eq "Application")
        {
                    $CM_App = Get-CMApplication -Name $Txt_app_name.Text

                    if($Checkbox_usercollection.CheckState -eq "Unchecked")
                   {
                   $CM_Col = Get-CMDeviceCollection -Id $TXT_collId.Text
                    }
                   elseif($Checkbox_usercollection.CheckState -eq "checked")
                   {
                    $CM_Col = Get-CMUserCollection -Id $TXT_collId.Text
                   }
                    
                    
                    if($CM_App){
                       
                        if(!($CM_Col.CollectionID.StartsWith('SMS'))){
                         if($CM_Col){
                            if($Comb_deploy_act.SelectedItem -eq "Install" -or $Comb_deploy_act.SelectedItem -eq "uninstall"){
                            
                            if($Combo_Deploy_purpose.SelectedItem -eq "Available" -or $Combo_Deploy_purpose.SelectedItem -eq "Required"){
                            
                            if($Combo_Deploy_purpose.SelectedItem -eq "Available"){
                            
                            If(!($Time_available.Value -lt $((Get-Date).AddMinutes(+5).DateTime) -or $Time_available.Value -lt $((Get-Date).DateTime) )){
                            
                                $global:Flag = 'yes'
                                $Displaylog.AppendText("`nThis section is displaying Info based on the given input")
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nApplication Name = $($CM_App.LocalizedDisplayName)")
                                $Displaylog.AppendText("`nApplication Version = $($CM_App.LocalizedDescription)")
                                $Displaylog.AppendText("`nCollection Name = $($CM_Col.Name)")
                                $Displaylog.AppendText("`nLimiting Collection = $($CM_Col.LimitToCollectionName)")
                                $Displaylog.AppendText("`nDeployment Action = $($Comb_deploy_act.SelectedItem)")
                                $Displaylog.AppendText("`nDeployment purpose = $($Combo_Deploy_purpose.SelectedItem)")
                                $Displaylog.AppendText("`nAvailable Time = $(($Time_available.Value).AddMinutes(30))") 
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nDeployment Will be created with 30 minutes Grace period, once email is received, approver has to approve it in the email.")
                                $Displaylog.AppendText("`n------------------------------------------------------")

                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Available time cannot be lesser than or equal current time")}
                       
                            }
                            
                            if($Combo_Deploy_purpose.SelectedItem -eq "Required"){
                            If($CM_Col.MemberCount -le "0"){

                            If(!($Time_available.Value -lt $((Get-Date).AddMinutes(+5).DateTime) -or $Time_available.Value -lt $((Get-Date).DateTime) )){
                            
                            If(!($Time_required.Value -lt $((Get-Date).AddMinutes(+5).DateTime) -or $Time_required.Value -lt $((Get-Date).DateTime) )){
                            
                            
                                $global:Flag = 'yes'
                                $Displaylog.AppendText("`nThis section is displaying Info based on the given input")
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nApplication Name = $($CM_App.LocalizedDisplayName)")
                                $Displaylog.AppendText("`nApplication Version = $($CM_App.LocalizedDescription)")
                                $Displaylog.AppendText("`nCollection Name = $($CM_Col.Name)")
                                $Displaylog.AppendText("`nLimiting Collection = $($CM_Col.LimitToCollectionName)")
                                $Displaylog.AppendText("`nDeployment Action = $($Comb_deploy_act.SelectedItem)")
                                $Displaylog.AppendText("`nDeployment purpose = $($Combo_Deploy_purpose.SelectedItem)")
                                $Displaylog.AppendText("`nAvailable Time = $(($Time_available.Value).AddMinutes(30))")
                                $Displaylog.AppendText("`nRequired Time = $(($Time_required.Value).AddMinutes(30))") 
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nDeployment Will be created with 30 minutes Grace period, once email is received, approver has to approve it in the email.")
                                $Displaylog.AppendText("`n------------------------------------------------------")
  
                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Required time cannot be lesser than or equal current time")}
                            
                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Available time cannot be lesser than or equal current time")}
                                                            
                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Required deployment should be deployed to empty collection, After validating you can add members!")}
                            
                            
      
                        }

                        }else{$Displaylog.Clear();$Displaylog.AppendText("`Select The Deployment Purpose")}
                        }else{$Displaylog.Clear();$Displaylog.AppendText("`Select The Deployment Action")}

                         }else{$Displaylog.Clear();$Displaylog.AppendText("` Enter the Collection ID")}

                        }else{$Displaylog.Clear();$Displaylog.AppendText("` Cannot use default collections")}            
                       
                        }else{$Displaylog.Clear();$Displaylog.AppendText("` Enter the application name")}



                    }
        elseif($Combo_Tech.SelectedItem -eq "Package")
        {
              $CM_Package = Get-CMPackage -Fast -Id $Txt_app_name.Text
              if($Checkbox_usercollection.CheckState -eq "Unchecked")
                   {
                   $CM_Collection = Get-CMDeviceCollection -Id $TXT_collId.Text
                    }
                   elseif($Checkbox_usercollection.CheckState -eq "checked")
                   {
                    $CM_Collection = Get-CMUserCollection -Id $TXT_collId.Text
                   }

             if($CM_Package){
             if(!($CM_Collection.CollectionID.StartsWith('SMS'))){
        
                    if($CM_Collection){
                            
                            
                            if($Combo_Deploy_purpose.SelectedItem -eq "Available" -or $Combo_Deploy_purpose.SelectedItem -eq "Required"){
                            
                            if($Combo_Deploy_purpose.SelectedItem -eq "Available"){
                            
                            If(!($Time_available.Value -lt $((Get-Date).AddMinutes(+5).DateTime) -or $Time_available.Value -lt $((Get-Date).DateTime) )){      
        
                                $global:Flag = 'yes'
                                $Displaylog.AppendText("`nThis section is displaying Info based on the given input")
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nPackage Name = $($CM_Package.Name)")
                                $Displaylog.AppendText("`nPackage Description = $($CM_Package.Description)")
                                $Displaylog.AppendText("`nCollection Name = $($CM_Collection.Name)")
                                $Displaylog.AppendText("`nLimiting Collection = $($CM_Collection.LimitToCollectionName)")
                                $Displaylog.AppendText("`nProgram Name = $($Comb_deploy_act.SelectedItem)")
                                $Displaylog.AppendText("`nDeployment purpose = $($Combo_Deploy_purpose.SelectedItem)")
                                $Displaylog.AppendText("`nAvailable Time = $(($Time_available.Value).AddMinutes(30))") 
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nDeployment Will be created with 30 minutes Grace period, once email is received, approver has to approve it in the email.")
                                $Displaylog.AppendText("`n------------------------------------------------------")

                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Available time cannot be lesser than or equal current time")}
                       
                            }
                            
                            if($Combo_Deploy_purpose.SelectedItem -eq "Required"){
                            If($CM_Collection.MemberCount -le "0"){

                            If(!($Time_available.Value -lt $((Get-Date).AddMinutes(+5).DateTime) -or $Time_available.Value -lt $((Get-Date).DateTime) )){
                            
                            If(!($Time_required.Value -lt $((Get-Date).AddMinutes(+5).DateTime) -or $Time_required.Value -lt $((Get-Date).DateTime) )){
                            
                            
                                $global:Flag = 'yes'
                                $Displaylog.AppendText("`nThis section is displaying Info based on the given input")
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nPackage Name = $($CM_Package.Name)")
                                $Displaylog.AppendText("`nPackage Description = $($CM_Package.Description)")
                                $Displaylog.AppendText("`nCollection Name = $($CM_Collection.Name)")
                                $Displaylog.AppendText("`nLimiting Collection = $($CM_Collection.LimitToCollectionName)")
                                $Displaylog.AppendText("`nProgram Name = $($Comb_deploy_act.SelectedItem)")
                                $Displaylog.AppendText("`nDeployment purpose = $($Combo_Deploy_purpose.SelectedItem)")
                                $Displaylog.AppendText("`nAvailable Time = $(($Time_available.Value).AddMinutes(30))")
                                $Displaylog.AppendText("`nRequired Time = $(($Time_required.Value).AddMinutes(30))") 
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nDeployment Will be created with 30 minutes Grace period, once email is received, approver has to approve it in the email.")
                                $Displaylog.AppendText("`n------------------------------------------------------")
  
                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Required time cannot be lesser than or equal current time")}
                            
                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Available time cannot be lesser than or equal current time")}
                                                            
                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Required deployment should be deployed to empty collection, After validating you can add members!")}
                            
                            
      
                        }
                        }else{$Displaylog.Clear();$Displaylog.AppendText("`Select The Deployment Purpose")}
                        

                         }else{$Displaylog.Clear();$Displaylog.AppendText("` Enter the Collection ID")}

                        }else{$Displaylog.Clear();$Displaylog.AppendText("` Cannot use default collections")} 
                         }else {$Displaylog.Clear();$Displaylog.AppendText("Enter Valid package ID")}
        
        
        
        }
        elseif($Combo_Tech.SelectedItem -eq "Task Sequence")
        {
              $CM_TS = Get-CMTaskSequence -Fast -TaskSequencePackageId $Txt_app_name.Text
              $CM_Collection = Get-CMDeviceCollection -Id $TXT_collId.Text
        if($CM_TS){
        if(!($CM_Collection.CollectionID.StartsWith('SMS'))){
        
             if($CM_Collection){
                            
                            
                            if($Combo_Deploy_purpose.SelectedItem -eq "Available" -or $Combo_Deploy_purpose.SelectedItem -eq "Required"){
                            
                            if($Combo_Deploy_purpose.SelectedItem -eq "Available"){
                            
                            If(!($Time_available.Value -lt $((Get-Date).AddMinutes(+5).DateTime) -or $Time_available.Value -lt $((Get-Date).DateTime) )){      
        
                                $global:Flag = 'yes'
                                $Displaylog.AppendText("`nThis section is displaying Info based on the given input")
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nTask Sequence Name = $($CM_TS.Name)")
                                $Displaylog.AppendText("`nTask Sequence Description = $($CM_TS.Description)")
                                $Displaylog.AppendText("`nCollection Name = $($CM_Collection.Name)")
                                $Displaylog.AppendText("`nLimiting Collection = $($CM_Collection.LimitToCollectionName)")
                                $Displaylog.AppendText("`nDeployment purpose = $($Combo_Deploy_purpose.SelectedItem)")
                                $Displaylog.AppendText("`nAvailable Time = $(($Time_available.Value).AddMinutes(30))") 
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nDeployment Will be created with 30 minutes Grace period, once email is received, approver has to approve it in the email.")
                                $Displaylog.AppendText("`n------------------------------------------------------")

                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Available time cannot be lesser than or equal current time")}
                       
                            }
                            
                            if($Combo_Deploy_purpose.SelectedItem -eq "Required"){
                            If($CM_Collection.MemberCount -le "0"){

                            If(!($Time_available.Value -lt $((Get-Date).AddMinutes(+5).DateTime) -or $Time_available.Value -lt $((Get-Date).DateTime) )){
                            
                            If(!($Time_required.Value -lt $((Get-Date).AddMinutes(+5).DateTime) -or $Time_required.Value -lt $((Get-Date).DateTime) )){
                            
                            
                                $global:Flag = 'yes'
                                $Displaylog.AppendText("`nThis section is displaying Info based on the given input")
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nTask Sequence Name = $($CM_TS.Name)")
                                $Displaylog.AppendText("`nTask Sequence Description = $($CM_TS.Description)")
                                $Displaylog.AppendText("`nCollection Name = $($CM_Collection.Name)")
                                $Displaylog.AppendText("`nLimiting Collection = $($CM_Collection.LimitToCollectionName)")
                                $Displaylog.AppendText("`nDeployment purpose = $($Combo_Deploy_purpose.SelectedItem)")
                                $Displaylog.AppendText("`nAvailable Time = $(($Time_available.Value).AddMinutes(30))")
                                $Displaylog.AppendText("`nRequired Time = $(($Time_required.Value).AddMinutes(30))") 
                                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                $Displaylog.AppendText("`nDeployment Will be created with 30 minutes Grace period, once email is received, approver has to approve it in the email.")
                                $Displaylog.AppendText("`n------------------------------------------------------")
  
                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Required time cannot be lesser than or equal current time")}
                            
                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Available time cannot be lesser than or equal current time")}
                                                            
                            }else{$Displaylog.Clear();$Displaylog.AppendText("`Required deployment should be deployed to empty collection, After validating you can add members!")}
                            
                            
      
                        }
                        }else{$Displaylog.Clear();$Displaylog.AppendText("`Select The Deployment Purpose")}
                        

                         }else{$Displaylog.Clear();$Displaylog.AppendText("` Enter the Collection ID")}

                        }else{$Displaylog.Clear();$Displaylog.AppendText("` Cannot use default collections")} 
                         }else {$Displaylog.Clear();$Displaylog.AppendText("Enter Valid package ID")}
        
        
        
        }
        
            }else {$Displaylog.Clear(); $Displaylog.AppendText("`Please select the email ID")}


}

function DeployClick( $object ){
if($Combo_Tech.SelectedItem -eq "Application"){
    Try{

      If ($Flag -eq 'Yes'){
                
        $de_CM_App = Get-CMApplication -Name $Txt_app_name.Text
        if($Checkbox_usercollection.CheckState -eq "Unchecked")
        {
        $de_CM_Col = Get-CMDeviceCollection -Id $TXT_collId.Text
        }
        elseif($Checkbox_usercollection.CheckState -eq "checked")
        {
        $de_CM_Col = Get-CMUserCollection -Id $TXT_collId.Text
        }
                    


        If ($Combo_Deploy_purpose.SelectedItem -eq "Available" )
        {
        $Displaylog.AppendText("`nCreating Available Deployment with Below details")
    
    If($Checkbox_availableUTC.CheckState -eq "UnChecked"){$cm_Utc = 'LocalTime'}elseif($Checkbox_availableUTC.CheckState -eq "Checked"){$cm_Utc = 'Utc'}
    $CM_GUID =$(New-Guid)
    $CM_time = $(Get-Date)
    $CM_comment = @"
CRQ_WO_REQ = $($TXT_CRQ.Text)
Tool_Guid = $CM_GUID
Creation_Time = $CM_time
User_ID = $($env:USERNAME)
"@ 
    $CM_newDeploy = New-CMApplicationDeployment -Name $de_CM_App.LocalizedDisplayName -DeployAction $($Comb_deploy_act.SelectedItem) -DeployPurpose Available -CollectionId $de_CM_Col.CollectionID -UserNotification DisplaySoftwareCenterOnly -TimeBaseOn $cm_Utc -AvailableDateTime $($Time_available.Value).AddMinutes(30) -PersistOnWriteFilterDevice $False -Comment $CM_comment
        
        
        $displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        $Displaylog.AppendText("`nDeployment Created")
        
        If($Checkbox_usercollection.CheckState -eq "Unchecked")
        {
        $mailRPTMembercount = $(Get-CMDeviceCollection -Id $($cm_newDeploy.TargetCollectionID)).MemberCount
        $mailRPTLimitColName = $(Get-CMDeviceCollection -Id $($CM_newDeploy.TargetCollectionID)).LimitToCollectionName
        }
        elseif($Checkbox_usercollection.CheckState -eq "checked")
        {
        $mailRPTMembercount = $(Get-CMUserCollection -Id $($cm_newDeploy.TargetCollectionID)).MemberCount
        $mailRPTLimitColName = $(Get-CMUserCollection -Id $($CM_newDeploy.TargetCollectionID)).LimitToCollectionName
        }


    $displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    $displaylog.AppendText("`nApplication Name = $($cm_newDeploy.ApplicationName)")
    $displaylog.AppendText("`nApplication Version = $($de_CM_App.LocalizedDescription)")
    $displaylog.AppendText("`nCollection Name = $($cm_newDeploy.CollectionName)")
    $displaylog.AppendText("`nLimiting Collection = $($mailRPTLimitColName)")
    $displaylog.AppendText("`nDeployment purpose=$($Combo_Deploy_purpose.SelectedItem)")
    $displaylog.AppendText("`nDeployment Action =$($Comb_deploy_act.SelectedItem)")
    $displaylog.AppendText("`nAvailable Time $($cm_newDeploy.StartTime)")
    $displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    
    }
    elseif($Combo_Deploy_purpose.SelectedItem -eq "Required")
    {
    $displaylog.AppendText("`nCreating Required/Push Deployment with Below details")

    If($Checkbx_reqdUTC.CheckState -eq "UnChecked"){$CM_Utc = 'LocalTime'}elseif($Checkbx_reqdUTC.CheckState -eq "Checked"){$cm_Utc = 'Utc'}
    If($CHKBX_MTW_SW_install.CheckState -eq "Unchecked"){$CM_mtwoverride = $False }elseif($CHKBX_MTW_SW_install.CheckState -eq "checked"){$CM_mtwoverride = $true}
    If($Checkbx_MTW_Reboot.CheckState -eq "Unchecked"){$CM_OutMTWReboot = $False }elseif($Checkbx_MTW_Reboot.CheckState -eq "checked"){$CM_OutMTWReboot = $true}

$CM_GUID =$(New-Guid)
$CM_time = $(Get-Date)
    $CM_comment = @"
CRQ_WO_REQ = $($TXT_CRQ.Text)
Tool_Guid = $CM_GUID
Creation_Time = $CM_time
User_ID = $($env:USERNAME)
"@  
    $cm_newDeploy = New-CMApplicationDeployment -Name $de_CM_App.LocalizedDisplayName -DeployAction $($Comb_deploy_act.SelectedItem) -DeployPurpose Required -CollectionId $de_CM_Col.CollectionID -UserNotification HideAll -TimeBaseOn $cm_Utc -AvailableDateTime $($Time_available.Value).AddMinutes(30) -DeadlineDateTime $($Time_required.Value).AddMinutes(30) -PersistOnWriteFilterDevice $False -OverrideServiceWindow $CM_mtwoverride -Comment $CM_comment -RebootOutsideServiceWindow $cm_OutMTWReboot

        If($Checkbox_usercollection.CheckState -eq "Unchecked")
        {
        $mailRPTMembercount = $(Get-CMDeviceCollection -Id $($cm_newDeploy.TargetCollectionID)).MemberCount
        $mailRPTLimitColName = $(Get-CMDeviceCollection -Id $($CM_newDeploy.TargetCollectionID)).LimitToCollectionName
        }
        elseif($Checkbox_usercollection.CheckState -eq "checked")
        {
        $mailRPTMembercount = $(Get-CMUserCollection -Id $($cm_newDeploy.TargetCollectionID)).MemberCount
        $mailRPTLimitColName = $(Get-CMUserCollection -Id $($CM_newDeploy.TargetCollectionID)).LimitToCollectionName
        }

    $displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    $displaylog.AppendText("`nApplication Name = $($cm_newDeploy.ApplicationName)")
    $displaylog.AppendText("`nApplication Version = $($de_CM_App.LocalizedDescription)")
    $displaylog.AppendText("`nCollection Name = $($cm_newDeploy.CollectionName)")
    $displaylog.AppendText("`nLimiting Collection = $($mailRPTLimitColName)")
    $displaylog.AppendText("`nDeployment Purpose = $($Combo_Deploy_purpose.SelectedItem)")
    $displaylog.AppendText("`nDeployment Action =$($Comb_deploy_act.SelectedItem)")
    $displaylog.AppendText("`nAvailable Time $($cm_newDeploy.StartTime)")
    $displaylog.AppendText("`nRequired Time $($cm_newDeploy.EnforcementDeadline)")
    $displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    
    }

    if($emailOptions -eq "Yes"){

     If ($Combo_Deploy_purpose.SelectedItem -eq "Available" )
     {
     $obj = @" 
<h4>Hi Team,</h4>
<h4>Deployment is created with 30 minutes Grace period, Approver has to approve it via email within next 30 minutes</h4>
<h3> SCCM Application Deployment summary</h3>

<table Border="1">
	<tr>
		<th>CRQ or REQ or WO</th>
		<td>$($TXT_CRQ.Text)</td>
	</tr>
	<tr>
		<th>Application Name</th>
		<td>$($cm_newDeploy.ApplicationName)</td>
	</tr>
    <tr>
		<th>Collection name</th>
		<td>$($cm_newDeploy.CollectionName)</td>    
	</tr>
    <tr>
		<th>Collection ID</th>
		<td>$($cm_newDeploy.TargetCollectionID)</td>    
    </tr>
     <tr>
		<th>Collection Member Count</th>
		<td>$mailRPTMembercount</td>    
    </tr>

     <tr>
		<th>Limiting Collection </th>
		<td>$mailRPTLimitColName</td>    
    </tr>

     <tr>
		<th>Deploy Action</th>
		<td>$($Comb_deploy_act.SelectedItem)</td>    
    </tr>
    <tr>
		<th>Deploy Purpose</th>
		<td>$($Combo_Deploy_purpose.SelectedItem)</td>    
    </tr>
     <tr>
		<th>Available Time</th>
		<td>$($cm_newDeploy.StartTime)</td>    
    </tr>
 
    <tr>
		<th>App Deployment Id</th>
		<td>$($cm_newDeploy.AssignmentID)</td>    
	</tr>

</table>
<p></p>
<p></p>
<p></p>

<h4>Tool Data </h4>
<p></p>
<p></p>
<p></p>

<table border="2" >
<tr>
	<th>Tool GUID</th>
	<th>Time</th>
	<th>UserID</th>
</tr>
<tr>
	<td>$CM_GUID</td>
	<td>$CM_time</td>
	<td>$($env:USERNAME)</td>
</tr>
</table>

<p>Thanks,</p>
<p>$($env:USERNAME)</p>
"@
        }
    elseif($Combo_Deploy_purpose.SelectedItem -eq "Required")
    {
    $obj = @" 
<h4>Hi Team,</h4>
<h4>Deployment is created with 30 minutes Grace period, Approver has to approve it via email within next 30 minutes</h4>
<h3> SCCM Application Deployment summary</h3>

<table Border="1">
	<tr>
		<th>CRQ or REQ or WO</th>
		<td>$($TXT_CRQ.Text)</td>
	</tr>
	<tr>
		<th>Application Name</th>
		<td>$($cm_newDeploy.ApplicationName)</td>
	</tr>
    <tr>
		<th>Collection name</th>
		<td>$($cm_newDeploy.CollectionName)</td>    
	</tr>
    <tr>
		<th>Collection ID</th>
		<td>$($cm_newDeploy.TargetCollectionID)</td>    
    </tr>
     <tr>
		<th>Collection Member Count</th>
		<td>$mailRPTMembercount</td>    
    </tr>
     <tr>
		<th>Limiting Collection </th>
		<td>$mailRPTLimitColName</td>    
    </tr>
     <tr>
		<th>Deploy Action</th>
		<td>$($Comb_deploy_act.SelectedItem)</td>    
    </tr>
    <tr>
		<th>Deploy Purpose</th>
		<td>$($Combo_Deploy_purpose.SelectedItem)</td>    
    </tr>
     <tr>
		<th>Available Time</th>
		<td>$($cm_newDeploy.StartTime)</td>    
    </tr>
 
     <tr>
		<th>Required Time</th>
		<td>$($cm_newDeploy.EnforcementDeadline)</td>       
    </tr>
    
    <tr>
		<th>App Deployment Id</th>
		<td>$($cm_newDeploy.AssignmentID)</td>    
	</tr>

</table>
<p></p>
<p></p>
<p></p>

<h4>Tool Data </h4>
<p></p>
<p></p>
<p></p>

<table border="2" >
<tr>
	<th>Tool GUID</th>
	<th>Time</th>
	<th>UserID</th>
</tr>
<tr>
	<td>$CM_GUID</td>
	<td>$CM_time</td>
	<td>$($env:USERNAME)</td>
</tr>
</table>

<p>Thanks,</p>
<p>$($env:USERNAME)</p>
"@
    }
                            
Send-Mail -To $($CMBO_email.SelectedItem) -CC $CCAddress -subject "Application Deployment Summary - $($cm_newDeploy.ApplicationName)" -body $obj -From $FromAddress -AsHtml
}

}else { $displaylog.clear(); $displaylog.AppendText("`nValidate Button should be Satisfied to Deploy.......!"); $displaylog.AppendText("`nOr Please Click the Exit button to Exit the App") }

}catch{ $displaylog.Clear(); $displaylog.AppendText( $($_.exception.message))
    }


    }
elseif($Combo_Tech.SelectedItem -eq "Package")
{
    Try{

      If ($Flag -eq 'Yes'){
                
                $CM_Package = Get-CMPackage -Fast -Id $Txt_app_name.Text
                if($Checkbox_usercollection.CheckState -eq "Unchecked")
                {
                $CM_Collection = Get-CMDeviceCollection -Id $TXT_collId.Text
                }
                elseif($Checkbox_usercollection.CheckState -eq "checked")
                {
                $CM_Collection = Get-CMUserCollection -Id $TXT_collId.Text
                }


        If ($Combo_Deploy_purpose.SelectedItem -eq "Available" )
        {
        $Displaylog.AppendText("`nCreating Available Deployment with Below details")
    
    If($Checkbox_availableUTC.CheckState -eq "UnChecked"){$cm_Utc = $False}elseif($Checkbox_availableUTC.CheckState -eq "Checked"){$cm_Utc = $true}
    If($CHKBX_MTW_SW_install.CheckState -eq "Unchecked"){$CM_mtwoverride = $False }elseif($CHKBX_MTW_SW_install.CheckState -eq "checked"){$CM_mtwoverride = $true}
    If($Checkbx_MTW_Reboot.CheckState -eq "Unchecked"){$CM_OutMTWReboot = $False }elseif($Checkbx_MTW_Reboot.CheckState -eq "checked"){$CM_OutMTWReboot = $true}
    $CM_GUID =$(New-Guid)
    $CM_time = $(Get-Date)
    $CM_comment = @"
CRQ_WO_REQ = $($TXT_CRQ.Text)
Tool_Guid = $CM_GUID
Creation_Time = $CM_time
User_ID = $($env:USERNAME)
"@ 
   
    $CM_newDeploy = New-CMPackageDeployment -StandardProgram -PackageId $($CM_Package.PackageID)  -ProgramName $($Comb_deploy_act.SelectedItem) -CollectionId $($CM_Collection.CollectionID) -DeployPurpose Available -AvailableDateTime $($Time_available.Value).AddMinutes(30) -UseUtcForAvailableSchedule $cm_Utc -PersistOnWriteFilterDevice $False -SoftwareInstallation $CM_mtwoverride -SystemRestart $CM_OutMTWReboot -Comment $CM_comment

        if($Checkbox_usercollection.CheckState -eq "Unchecked")
        {
        $mailRPTMembercount = $(Get-CMDeviceCollection -Id $($CM_newDeploy.CollectionID)).MemberCount
        $mailRPTLimitColName = $(Get-CMDeviceCollection -Id $($CM_newDeploy.CollectionID)).LimitToCollectionName 
        $mailRPTCoLName = $(Get-CMDeviceCollection -Id $($CM_newDeploy.CollectionID)).Name
        }
        elseif($Checkbox_usercollection.CheckState -eq "checked")
        {
        $mailRPTMembercount = $(Get-CMUserCollection -Id $($CM_newDeploy.CollectionID)).MemberCount
        $mailRPTLimitColName = $(Get-CMUserCollection -Id $($CM_newDeploy.CollectionID)).LimitToCollectionName
        $mailRPTCoLName = $(Get-CMUserCollection -Id $($CM_newDeploy.CollectionID)).Name
        }


                $displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                $Displaylog.AppendText("`nPackage Name = $($(Get-CMPackage -Fast -Id $($CM_newDeploy.PackageID)).Name)")
                $Displaylog.AppendText("`nProgram Name = $($CM_newDeploy.ProgramName)")
                $displaylog.AppendText("`nCollection Name = $($mailRPTCoLName)")
                $displaylog.AppendText("`nLimiting Collection = $($mailRPTLimitColName)")
                $Displaylog.AppendText("`nProgram Name = $($CM_newDeploy.ProgramName)")
                $Displaylog.AppendText("`nDeployment purpose = $($Combo_Deploy_purpose.SelectedItem)")
                $Displaylog.AppendText("`nAvailable Time = $($CM_newDeploy.PresentTime)") 
                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    
    }
    elseif($Combo_Deploy_purpose.SelectedItem -eq "Required")
    {
    $displaylog.AppendText("`nCreating Required/Push Deployment with Below details")

    If($Checkbox_availableUTC.CheckState -eq "UnChecked"){$CM_aUtc = $False} elseif($Checkbox_availableUTC.CheckState -eq "Checked"){$CM_aUtc = $true}

    If($checkBx_expryUTC.CheckState -eq "UnChecked"){$CM_eUtc = $False}elseif($checkBx_expryUTC.CheckState -eq "Checked"){$CM_eUtc = $true}

    If($CHKBX_MTW_SW_install.CheckState -eq "Unchecked"){$CM_mtwoverride = $False }elseif($CHKBX_MTW_SW_install.CheckState -eq "checked"){$CM_mtwoverride = $true}
    If($Checkbx_MTW_Reboot.CheckState -eq "Unchecked"){$CM_OutMTWReboot = $False }elseif($Checkbx_MTW_Reboot.CheckState -eq "checked"){$CM_OutMTWReboot = $true}
    if($CheckBox_TS_software_install.CheckState -eq "Unchecked"){$pckrunfromsoftwarecenter =$false }elseif($CheckBox_TS_software_install.CheckState -eq "checked"){$pckrunfromsoftwarecenter =$True}

$CM_GUID =$(New-Guid)
$CM_time = $(Get-Date)
    $CM_comment = @"
CRQ_WO_REQ = $($TXT_CRQ.Text)
Tool_Guid = $CM_GUID
Creation_Time = $CM_time
User_ID = $($env:USERNAME)
"@  
    If($Checkbx_reqdUTC.CheckState -eq "UnChecked")
    {
    $CMrequiredtime = New-CMSchedule -Start $($Time_required.Value).AddMinutes(30) -Nonrecurring
    }
    elseif($Checkbx_reqdUTC.CheckState -eq "Checked")
    {
    $CMrequiredtime = New-CMSchedule -Start $($Time_required.Value).AddMinutes(30) -Nonrecurring -IsUtc
    }

    
    $CM_newDeploy = New-CMPackageDeployment -StandardProgram -PackageId $($CM_Package.PackageID)  -ProgramName $($Comb_deploy_act.SelectedItem) -CollectionId $($CM_Collection.CollectionID) -DeployPurpose Required -AvailableDateTime $($Time_available.Value).AddMinutes(30) -UseUtcForAvailableSchedule $CM_aUtc -Schedule $CMrequiredtime -DeadlineDateTime $time_expiry.Value -UseUtcForExpireSchedule $CM_eUtc -PersistOnWriteFilterDevice $False -SoftwareInstallation $CM_mtwoverride -SystemRestart $CM_OutMTWReboot -RerunBehavior RerunIfFailedPreviousAttempt -Comment $CM_comment -RunFromSoftwareCenter $pckrunfromsoftwarecenter

        if($Checkbox_usercollection.CheckState -eq "Unchecked")
        {
        $mailRPTMembercount = $(Get-CMDeviceCollection -Id $($CM_newDeploy.CollectionID)).MemberCount
        $mailRPTLimitColName = $(Get-CMDeviceCollection -Id $($CM_newDeploy.CollectionID)).LimitToCollectionName 
        $mailRPTCoLName = $(Get-CMDeviceCollection -Id $($CM_newDeploy.CollectionID)).Name
        }
        elseif($Checkbox_usercollection.CheckState -eq "checked")
        {
        $mailRPTMembercount = $(Get-CMUserCollection -Id $($CM_newDeploy.CollectionID)).MemberCount
        $mailRPTLimitColName = $(Get-CMUserCollection -Id $($CM_newDeploy.CollectionID)).LimitToCollectionName
        $mailRPTCoLName = $(Get-CMUserCollection -Id $($CM_newDeploy.CollectionID)).Name
        }


                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                $Displaylog.AppendText("`nPackage Name = $($(Get-CMPackage -Fast -Id $($CM_newDeploy.PackageID)).Name)")
                $Displaylog.AppendText("`nProgram Name = $($CM_newDeploy.ProgramName)")
                $displaylog.AppendText("`nCollection Name = $($mailRPTCoLName)")
                $displaylog.AppendText("`nLimiting Collection = $($mailRPTLimitColName)")
                $Displaylog.AppendText("`nProgram Name = $($CM_newDeploy.ProgramName)")
                $Displaylog.AppendText("`nDeployment purpose = $($Combo_Deploy_purpose.SelectedItem)")
                $Displaylog.AppendText("`nAvailable Time = $($CM_newDeploy.PresentTime)")
                $Displaylog.AppendText("`nAssignment Time = $($($Time_required.Value).AddMinutes(30))")
                $Displaylog.AppendText("`nExpiry Time = $($CM_newDeploy.ExpirationTime)")
                $Displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    
    }
    if($emailOptions -eq "Yes"){
     If ($Combo_Deploy_purpose.SelectedItem -eq "Available" )
     {
     $obj = @" 
<h4>Hi Team,</h4>
<h4>Deployment is created with 30 minutes Grace period, Approver has to approve it via email within next 30 minutes</h4>
<h3> SCCM Package Deployment summary</h3>

<table Border="1">
	<tr>
		<th>CRQ or REQ or WO</th>
		<td>$($TXT_CRQ.Text)</td>
	</tr>
	<tr>
		<th>Package ID</th>
		<td>$($CM_newDeploy.PackageID)</td>
	</tr>
	<tr>
		<th>Package Name</th>
		<td>$($(Get-CMPackage -Fast -Id $($CM_newDeploy.PackageID)).Name)</td>
	</tr>
    <tr>
		<th>Collection name</th>
		<td>$($mailRPTCoLName)</td>    
	</tr>
    <tr>
		<th>Collection ID</th>
		<td>$($CM_newDeploy.CollectionID)</td>    
    </tr>

    <tr>
		<th>Limiting Collection </th>
		<td>$($mailRPTLimitColName)</td>    
    </tr>
     <tr>
		<th>Collection Member Count</th>
		<td>$($mailRPTMembercount)</td>    
    </tr>
     <tr>
		<th>Program Name</th>
		<td>$($CM_newDeploy.ProgramName)</td>    
    </tr>
    <tr>
		<th>Deploy Purpose</th>
		<td>$($Combo_Deploy_purpose.SelectedItem)</td>    
    </tr>
     <tr>
		<th>Available Time</th>
		<td>$($CM_newDeploy.PresentTime)</td>    
    </tr>
  
    <tr>
		<th>Package Advertisement ID</th>
		<td>$($CM_newDeploy.AdvertisementID)</td>    
	</tr>

</table>
<p></p>
<p></p>
<p></p>

<h4>Tool Data </h4>
<p></p>
<p></p>
<p></p>

<table border="2" >
<tr>
	<th>Tool GUID</th>
	<th>Time</th>
	<th>UserID</th>
</tr>
<tr>
	<td>$CM_GUID</td>
	<td>$CM_time</td>
	<td>$($env:USERNAME)</td>
</tr>
</table>

<p>Thanks,</p>
<p>$($env:USERNAME)</p>
"@
     } 
     elseif($Combo_Deploy_purpose.SelectedItem -eq "Required")
     {
     $obj = @" 
<h4>Hi Team,</h4>
<h4>Deployment is created with 30 minutes Grace period, Approver has to approve it via email within next 30 minutes</h4>
<h3> SCCM Package Deployment summary</h3>

<table Border="1">
		<tr>
		<th>CRQ or REQ or WO</th>
		<td>$($TXT_CRQ.Text)</td>
	</tr>
	<tr>
		<th>Package ID</th>
		<td>$($CM_newDeploy.PackageID)</td>
	</tr>
	<tr>
		<th>Package Name</th>
		<td>$($(Get-CMPackage -Fast -Id $($CM_newDeploy.PackageID)).Name)</td>
	</tr>
    <tr>
		<th>Collection name</th>
		<td>$($mailRPTCoLName)</td>    
	</tr>
    <tr>
		<th>Collection ID</th>
		<td>$($CM_newDeploy.CollectionID)</td>    
    </tr>
    <tr>
		<th>Limiting Collection </th>
		<td>$($mailRPTLimitColName)</td>    
    </tr>

     <tr>
		<th>Collection Member Count</th>
		<td>$($mailRPTMembercount)</td>    
    </tr>
     <tr>
		<th>Program Name</th>
		<td>$($CM_newDeploy.ProgramName)</td>    
    </tr>
     <tr>
		<th>Deploy Purpose</th>
		<td>$($Combo_Deploy_purpose.SelectedItem)</td>    
    </tr>
     <tr>
		<th>Available Time</th>
		<td>$($CM_newDeploy.PresentTime)</td>    
    </tr>
 
     <tr>
		<th>Required Time</th>
		<td>$($($Time_required.Value).AddMinutes(30))</td>       
    </tr>
     <tr>
		<th>Expiry Time</th>
		<td>$($CM_newDeploy.ExpirationTime)</td>       
    </tr>
    
    <tr>
		<th>Package Advertisement ID</th>
		<td>$($CM_newDeploy.AdvertisementID)</td>    
	</tr>

</table>
<p></p>
<p></p>
<p></p>

<h4>Tool Data </h4>
<p></p>
<p></p>
<p></p>

<table border="2" >
<tr>
	<th>Tool GUID</th>
	<th>Time</th>
	<th>UserID</th>
</tr>
<tr>
	<td>$CM_GUID</td>
	<td>$CM_time</td>
	<td>$($env:USERNAME)</td>
</tr>
</table>

<p>Thanks,</p>
<p>$($env:USERNAME)</p>
"@
     }

    
                            
Send-Mail -To $($CMBO_email.SelectedItem) -CC $CCAddress -subject "Package Deployment Summary - $($CM_Package.Name)" -body $obj -From $FromAddress -AsHtml
}

}else { $displaylog.clear(); $displaylog.AppendText("`nValidate Button should be Satisfied to Deploy.......!"); $displaylog.AppendText("`nOr Please Click the Exit button to Exit the App") }

}catch{ $displaylog.Clear(); $displaylog.AppendText( $($_.exception.message))
    }


    }
elseif($Combo_Tech.SelectedItem -eq "Task Sequence")
{
    Try{

      If ($Flag -eq 'Yes'){
                
              $CM_DTS = Get-CMTaskSequence -Fast -TaskSequencePackageId $Txt_app_name.Text
              $CM_DCollection = Get-CMDeviceCollection -Id $TXT_collId.Text


        If ($Combo_Deploy_purpose.SelectedItem -eq "Available" )
        {
        $displaylog.AppendText("`nCreating Available Deployment with Below details")
    
    If($Checkbox_availableUTC.CheckState -eq "UnChecked"){$cm_tsUtc = $False }elseif($Checkbox_availableUTC.CheckState -eq "Checked"){$cm_tsUtc = $true}

    If($CHKBX_MTW_SW_install.CheckState -eq "Unchecked"){$CM_tsmtwoverride = $False }elseif($CHKBX_MTW_SW_install.CheckState -eq "checked"){$CM_tsmtwoverride = $true}
    If($Checkbx_MTW_Reboot.CheckState -eq "Unchecked"){$CM_tsOutMTWReboot = $False }elseif($Checkbx_MTW_Reboot.CheckState -eq "checked"){$CM_tsOutMTWReboot = $true}

    if($CheckBox_TS_Progress.CheckState -eq "Unchecked"){$ProgressBar = $false}elseif($CheckBox_TS_Progress.CheckState -eq "Checked"){$ProgressBar = $true}

    $CM_GUID =$(New-Guid)
    $CM_time = $(Get-Date)
    $CM_TSAcomment = @"
CRQ_WO_REQ = $($TXT_CRQ.Text)
Tool_Guid = $CM_GUID
Creation_Time = $CM_time
User_ID = $($env:USERNAME)
"@ 
    $CM_TSDeploy = New-CMTaskSequenceDeployment -TaskSequencePackageId $CM_DTS.PackageID -CollectionId $CM_DCollection.collectionID -DeployPurpose Available -Availability Clients -AvailableDateTime $($Time_available.Value).AddMinutes(30) -UseUtcForAvailableSchedule $cm_tsUtc -PersistOnWriteFilterDevice $false -SystemRestart $CM_tsOutMTWReboot -SoftwareInstallation $CM_tsmtwoverride -ShowTaskSequenceProgress $ProgressBar -Comment $CM_TSAcomment
   
    $displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    $displaylog.AppendText("`nTask Sequence Name = $($(Get-CMTaskSequence -Fast -TaskSequencePackageId $($CM_TSDeploy.PackageID)).Name)")
    $displaylog.AppendText("`nTask Sequence ID = $($CM_TSDeploy.PackageID)")
    $displaylog.AppendText("`nCollection ID = $($CM_TSDeploy.CollectionID)")
    $displaylog.AppendText("`nCollection Name = $($(Get-CMDeviceCollection -Id $($CM_TSDeploy.CollectionID)).Name)")
    $displaylog.AppendText("`nLimiting Collection = $($(Get-CMDeviceCollection -Id $($CM_TSDeploy.CollectionID)).LimitToCollectionName)")
    $displaylog.AppendText("`nDeployment purpose=$($Combo_Deploy_purpose.SelectedItem)")
    $displaylog.AppendText("`nAvailable Time $($CM_TSDeploy.PresentTime)")
    $displaylog.AppendText("`nDeployment ID $($CM_TSDeploy.AdvertisementID)")
    $displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    
    }
    elseif($Combo_Deploy_purpose.SelectedItem -eq "Required")
    {
    $Displaylog.AppendText("`nCreating Required/Push Deployment with Below details")

    If($Checkbox_availableUTC.CheckState -eq "UnChecked"){$cm_tsaUtc = $False }elseif($Checkbox_availableUTC.CheckState -eq "Checked"){$cm_tsaUtc = $true}

    If($checkBx_expryUTC.CheckState -eq "UnChecked"){$CM_tseUtc = $False }elseif($checkBx_expryUTC.CheckState -eq "Checked"){$CM_tseUtc = $true }

    If($CHKBX_MTW_SW_install.CheckState -eq "Unchecked"){$CM_tsrmtwoverride = $False }elseif($CHKBX_MTW_SW_install.CheckState -eq "checked"){$CM_tsrmtwoverride = $true}
    If($Checkbx_MTW_Reboot.CheckState -eq "Unchecked"){$CM_tsrOutMTWReboot = $False }elseif($Checkbx_MTW_Reboot.CheckState -eq "checked"){$CM_tsrOutMTWReboot = $true}

    if($CheckBox_TS_Progress.CheckState -eq "Unchecked"){$tsRProgressBar = $false}elseif($CheckBox_TS_Progress.CheckState -eq "Checked"){$tsRProgressBar = $true}
    if($CheckBox_TS_software_install.CheckState -eq "Unchecked"){$installfromsoftwarecneter = $false}elseif($CheckBox_TS_software_install.CheckState -eq "Checked"){$installfromsoftwarecneter = $true}


$CM_GUID =$(New-Guid)
$CM_time = $(Get-Date)
    $CM_TSrcomment = @"
CRQ_WO_REQ = $($TXT_CRQ.Text)
Tool_Guid = $CM_GUID
Creation_Time = $CM_time
User_ID = $($env:USERNAME)
"@  
        If($Checkbx_reqdUTC.CheckState -eq "UnChecked")
        {
        $assignmentscheduletsr = New-CMSchedule -Start $($Time_required.Value).AddMinutes(30) -Nonrecurring 
        }
        elseif($Checkbx_reqdUTC.CheckState -eq "Checked")
        {
        $assignmentscheduletsr = New-CMSchedule -Start $($Time_required.Value).AddMinutes(30) -Nonrecurring -IsUtc 
        }

    
    $CM_TSDeploy = New-CMTaskSequenceDeployment -TaskSequencePackageId $CM_DTS.PackageID -DeployPurpose Required -AvailableDateTime $($Time_available.Value).AddMinutes(30) -UseUtcForAvailableSchedule $cm_tsaUtc -Schedule $assignmentscheduletsr -DeadlineDateTime $time_expiry.Value -UseUtcForExpireSchedule $CM_tseUtc -Availability Clients -RerunBehavior RerunIfFailedPreviousAttempt -CollectionId $CM_DCollection.collectionID -ShowTaskSequenceProgress $tsRProgressBar -RunFromSoftwareCenter $installfromsoftwarecneter -PersistOnWriteFilterDevice $false -Comment $CM_TSrcomment -SoftwareInstallation $CM_tsrmtwoverride -SystemRestart $CM_tsrOutMTWReboot


    $displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    $displaylog.AppendText("`nTask Sequence Name = $($(Get-CMTaskSequence -Fast -TaskSequencePackageId $($CM_TSDeploy.PackageID)).Name)")
    $displaylog.AppendText("`nTask Sequence ID = $($CM_TSDeploy.PackageID)")
    $displaylog.AppendText("`nCollection ID = $($CM_TSDeploy.CollectionID)")
    $displaylog.AppendText("`nCollection Name = $($(Get-CMDeviceCollection -Id $($CM_TSDeploy.CollectionID)).Name)")
    $displaylog.AppendText("`nLimiting Collection = $($(Get-CMDeviceCollection -Id $($CM_TSDeploy.CollectionID)).LimitToCollectionName)")
    $displaylog.AppendText("`nDeployment Purpose = $($Combo_Deploy_purpose.SelectedItem)")
    $displaylog.AppendText("`nAvailable Time $($CM_TSDeploy.PresentTime)")
    $displaylog.AppendText("`nRequired Time $($($Time_required.Value).AddMinutes(30))")
    $displaylog.AppendText("`nExpiry Time $($CM_TSDeploy.ExpirationTime)")  
    $displaylog.AppendText("`nDeployment ID $($CM_TSDeploy.AdvertisementID)")
    $displaylog.AppendText("`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    
    }
    if($emailOptions -eq "Yes"){
     If ($Combo_Deploy_purpose.SelectedItem -eq "Available" )
     {
     $obj = @" 
<h4>Hi Team,</h4>
<h4>Deployment is created with 30 minutes Grace period, Approver has to approve it via email within next 30 minutes</h4>
<h3> SCCM Task Sequence Deployment summary</h3>

<table Border="1">
	<tr>
		<th>CRQ or REQ or WO</th>
		<td>$($TXT_CRQ.Text)</td>
	</tr>
	<tr>
		<th>Task Sequence Name</th>
		<td>$($(Get-CMTaskSequence -Fast -TaskSequencePackageId $($CM_TSDeploy.PackageID)).Name)</td>
	</tr>
	<tr>
		<th>Task Sequence ID</th>
		<td>$($CM_TSDeploy.PackageID)</td>
	</tr>
    <tr>
		<th>Collection ID</th>
		<td>$($CM_TSDeploy.CollectionID)</td>    
    </tr>
    <tr>
		<th>Collection name</th>
		<td>$($(Get-CMDeviceCollection -Id $($CM_TSDeploy.CollectionID)).Name)</td>    
	</tr>

     <tr>
		<th>Collection Member Count</th>
		<td>$($(Get-CMDeviceCollection -Id $($CM_TSDeploy.CollectionID)).MemberCount)</td>    
    </tr>
     <tr>
		<th>Limiting Collection </th>
		<td>$($(Get-CMDeviceCollection -Id $($CM_TSDeploy.CollectionID)).LimitToCollectionName)</td>    
    </tr>
     <tr>
		<th>Deployment Purpose</th>
		<td>$($Combo_Deploy_purpose.SelectedItem)</td>    
    </tr>
     <tr>
		<th>Available Time</th>
		<td>$($CM_TSDeploy.PresentTime)</td>    
    </tr>
     </tr>
    <tr>
		<th>Task Sequence Deployment Id</th>
		<td>$($CM_TSDeploy.AdvertisementID)</td>    
	</tr>

</table>
<p></p>
<p></p>
<p></p>

<h4>Tool Data </h4>
<p></p>
<p></p>
<p></p>

<table border="2" >
<tr>
	<th>Tool GUID</th>
	<th>Time</th>
	<th>UserID</th>
</tr>
<tr>
	<td>$CM_GUID</td>
	<td>$CM_time</td>
	<td>$($env:USERNAME)</td>
</tr>
</table>

<p>Thanks,</p>
<p>$($env:USERNAME)</p>
"@
     }
     elseif($Combo_Deploy_purpose.SelectedItem -eq "Required")
     {
     $obj = @" 
<h4>Hi Team,</h4>
<h4>Deployment is created with 30 minutes Grace period, Approver has to approve it via email within next 30 minutes</h4>
<h3> SCCM Task Sequence Deployment summary</h3>

<table Border="1">
	<tr>
		<th>CRQ or REQ or WO</th>
		<td>$($TXT_CRQ.Text)</td>
	</tr>
	<tr>
		<th>Task Sequence Name</th>
		<td>$($(Get-CMTaskSequence -Fast -TaskSequencePackageId $($CM_TSDeploy.PackageID)).Name)</td>
	</tr>
	<tr>
		<th>Task Sequence ID</th>
		<td>$($CM_TSDeploy.PackageID)</td>
	</tr>
    <tr>
		<th>Collection ID</th>
		<td>$($CM_TSDeploy.CollectionID)</td>    
    </tr>
    <tr>
		<th>Collection name</th>
		<td>$($(Get-CMDeviceCollection -Id $($CM_TSDeploy.CollectionID)).Name)</td>    
	</tr>

     <tr>
		<th>Collection Member Count</th>
		<td>$($(Get-CMDeviceCollection -Id $($CM_TSDeploy.CollectionID)).MemberCount)</td>    
    </tr>
        
     <tr>
		<th>Limiting Collection </th>
		<td>$($(Get-CMDeviceCollection -Id $($CM_TSDeploy.CollectionID)).LimitToCollectionName)</td>    
    </tr>

    <tr>
		<th>Deployment Purpose</th>
		<td>$($Combo_Deploy_purpose.SelectedItem)</td>    
    </tr>
     <tr>
		<th>Available Time</th>
		<td>$($CM_TSDeploy.PresentTime)</td>    
    </tr>
 
     <tr>
		<th>Required Time</th>
		<td>$($($Time_required.Value).AddMinutes(30))</td>       
    </tr>
      <tr>
		<th>Expiry Time</th>
		<td>$($CM_TSDeploy.ExpirationTime)</td>       
    </tr>
    <tr>
		<th>Task Sequence Deployment Id</th>
		<td>$($CM_TSDeploy.AdvertisementID)</td>    
	</tr>

</table>
<p></p>
<p></p>
<p></p>

<h4>Tool Data </h4>
<p></p>
<p></p>
<p></p>

<table border="2" >
<tr>
	<th>Tool GUID</th>
	<th>Time</th>
	<th>UserID</th>
</tr>
<tr>
	<td>$CM_GUID</td>
	<td>$CM_time</td>
	<td>$($env:USERNAME)</td>
</tr>
</table>

<p>Thanks,</p>
<p>$($env:USERNAME)</p>
"@
    }
                            
Send-Mail -To $($CMBO_email.SelectedItem) -CC $CCAddress -subject "Task Sequence Deployment Summary - $($CM_DTS.Name)" -body $obj -From $FromAddress -AsHtml
}

}else { $displaylog.clear(); $displaylog.AppendText("`nValidate Button should be Satisfied to Deploy.......!"); $displaylog.AppendText("`nOr Please Click the Exit button to Exit the App") }

}catch{ $displaylog.Clear(); $displaylog.AppendText( $($_.exception.message))
    }


    }

}


Main # This call must remain below all other event functions

#endregion
# ========================================================
#
# Script Information
#
# Title:Application Deployment Tool
# Author: PERSONAL\master
# Originally created: 19-07-2024 - 09:30:54
# Original path: C:\Users\master\Documents\DeploymentTool.ps1
# Description: MECM Deployment Tool
# 
# ========================================================
