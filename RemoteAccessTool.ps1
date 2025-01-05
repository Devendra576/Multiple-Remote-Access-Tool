# Add necessary assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Remote Access Tool"
$form.Size = New-Object System.Drawing.Size(420, 600)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::LightSteelBlue

# Set a custom font
$font = New-Object System.Drawing.Font("Arial", 10)

# Add title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Remote Access Tool"
$titleLabel.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(120, 20)
$form.Controls.Add($titleLabel)

# Hostname input field
$labelHostnames = New-Object System.Windows.Forms.Label
$labelHostnames.Text = "Hostnames (one per line):"
$labelHostnames.Font = $font
$labelHostnames.AutoSize = $true
$labelHostnames.Location = New-Object System.Drawing.Point(10, 60)
$form.Controls.Add($labelHostnames)

$textboxHostnames = New-Object System.Windows.Forms.TextBox
$textboxHostnames.Location = New-Object System.Drawing.Point(10, 110)
$textboxHostnames.Size = New-Object System.Drawing.Size(380, 80)
$textboxHostnames.Multiline = $true
$textboxHostnames.ScrollBars = "Vertical"
$form.Controls.Add($textboxHostnames)

# Username input field
$labelUsername = New-Object System.Windows.Forms.Label
$labelUsername.Text = "Username:"
$labelUsername.Font = $font
$labelUsername.Location = New-Object System.Drawing.Point(10, 200)
$form.Controls.Add($labelUsername)

$textboxUsername = New-Object System.Windows.Forms.TextBox
$textboxUsername.Location = New-Object System.Drawing.Point(10, 220)
$textboxUsername.Size = New-Object System.Drawing.Size(190, 20)  # Reduced width to half
$form.Controls.Add($textboxUsername)

# Password input field
$labelPassword = New-Object System.Windows.Forms.Label
$labelPassword.Text = "Password:"
$labelPassword.Font = $font
$labelPassword.Location = New-Object System.Drawing.Point(210, 200)  # Adjusted position
$form.Controls.Add($labelPassword)

$textboxPassword = New-Object System.Windows.Forms.TextBox
$textboxPassword.Location = New-Object System.Drawing.Point(210, 220)
$textboxPassword.Size = New-Object System.Drawing.Size(180, 20)  # Reduced width to half
$textboxPassword.UseSystemPasswordChar = $true
$form.Controls.Add($textboxPassword)

# Add button to launch remote sessions
$buttonLaunch = New-Object System.Windows.Forms.Button
$buttonLaunch.Text = "Launch Remote Sessions"
$buttonLaunch.Font = $font
$buttonLaunch.Location = New-Object System.Drawing.Point(10, 260)
$buttonLaunch.Size = New-Object System.Drawing.Size(380, 30)
$buttonLaunch.BackColor = [System.Drawing.Color]::LightBlue
$form.Controls.Add($buttonLaunch)

# Add output log area
$labelOutput = New-Object System.Windows.Forms.Label
$labelOutput.Text = "Output:" 
$labelOutput.Font = $font
$labelOutput.Location = New-Object System.Drawing.Point(10, 300)
$form.Controls.Add($labelOutput)

$textboxOutput = New-Object System.Windows.Forms.TextBox
$textboxOutput.Location = New-Object System.Drawing.Point(10, 320)
$textboxOutput.Size = New-Object System.Drawing.Size(380, 200)
$textboxOutput.Multiline = $true
$textboxOutput.ScrollBars = "Vertical"
$form.Controls.Add($textboxOutput)

# Add name label at the bottom left corner
$nameLabel = New-Object System.Windows.Forms.Label
$nameLabel.Text = "By - Devendra Tripathi"
$nameLabel.Font = $font
$nameLabel.AutoSize = $true
$nameLabel.Location = New-Object System.Drawing.Point(10, 540)
$form.Controls.Add($nameLabel)

# Add event handler for the button
$buttonLaunch.Add_Click({
    # Read inputs from the form
    $Hostnames = $textboxHostnames.Text -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    $Username = $textboxUsername.Text
    $Password = $textboxPassword.Text

    if ($Hostnames -and $Username -and $Password) {
        foreach ($Hostname in $Hostnames) {
            try {
                # Store the credentials
                Start-Process -FilePath "cmdkey.exe" -ArgumentList "/generic:$Hostname /user:$Username /pass:$Password"

                # Launch Remote Desktop
                Start-Process -FilePath "mstsc.exe" -ArgumentList "/f /v:$Hostname"

                # Log success
                $textboxOutput.AppendText("Launched Remote Desktop for ${Hostname}`r`n")
            } catch {
                # Log failure
                $textboxOutput.AppendText("Failed to launch Remote Desktop for ${Hostname}: ${$_.Exception.Message}`r`n")
            }
        }
    } else {
        $textboxOutput.AppendText("Please fill in all fields.`r`n")
    }
})

# Show the form
$form.ShowDialog()
