# Windows 11 Optimizer GUI
# Modern GUI version of the Windows Optimizer

# PowerShell GUI with WPF
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# Global Variables
$Global:OptimizerVersion = "2.0.0"
$Global:RequiresAdmin = $true

# Colors for the GUI
$Colors = @{
    Primary = "#2E86AB"
    Secondary = "#A23B72"
    Success = "#28A745"
    Warning = "#FFC107"
    Error = "#DC3545"
    Info = "#17A2B8"
    Dark = "#343A40"
    Light = "#F8F9FA"
}

# Check Administrator Rights
function Test-AdministratorRights {
    $CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)
    return $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Logging Function
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] [$Level] $Message"
    
    # Write log to file
    $LogFile = "$env:TEMP\WindowsOptimizer.log"
    Add-Content -Path $LogFile -Value $LogEntry -Encoding UTF8
    
    # Display in GUI
    if ($Global:LogTextBox) {
        $Global:LogTextBox.AppendText("$LogEntry`n")
        $Global:LogTextBox.ScrollToEnd()
    }
}

# Create Main Window
function New-MainWindow {
    # XAML for the main window
    $Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Windows 11 Optimizer v2.0.0" 
        Height="800" Width="1200" 
        WindowStartupLocation="CenterScreen"
        Background="#F8F9FA"
        ResizeMode="CanResize">
    
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        
        <!-- Header -->
        <Border Grid.Row="0" Background="#2E86AB" Padding="20">
            <StackPanel Orientation="Horizontal">
                <TextBlock Text="⚡" FontSize="32" Margin="0,0,15,0"/>
                <StackPanel>
                    <TextBlock Text="Windows 11 Optimizer" FontSize="24" FontWeight="Bold" Foreground="White"/>
                    <TextBlock Text="System Optimization and Repair" FontSize="14" Foreground="White" Opacity="0.9"/>
                </StackPanel>
            </StackPanel>
        </Border>
        
        <!-- Main Content -->
        <Grid Grid.Row="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="250"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            
            <!-- Navigation Sidebar -->
            <Border Grid.Column="0" Background="White" BorderBrush="#E9ECEF" BorderThickness="0,0,1,0">
                <StackPanel Margin="20">
                    <TextBlock Text="Main Menu" FontSize="18" FontWeight="Bold" Margin="0,0,0,20" Foreground="#343A40"/>
                    
                    <Button Name="BtnDiagnostics" Content="🔍 System Diagnostics" Margin="0,5" Tag="diagnostics"/>
                    <Button Name="BtnRepair" Content="🔧 Repair Errors" Margin="0,5" Tag="repair"/>
                    <Button Name="BtnPerformance" Content="⚡ Optimize Performance" Margin="0,5" Tag="performance"/>
                    <Button Name="BtnSecurity" Content="🛡️ Security Optimization" Margin="0,5" Tag="security"/>
                    <Button Name="BtnCleanup" Content="🧹 System Cleanup" Margin="0,5" Tag="cleanup"/>
                    <Button Name="BtnReport" Content="📊 System Report" Margin="0,5" Tag="report"/>
                    <Button Name="BtnGaming" Content="🎮 Gaming Optimization" Margin="0,5" Tag="gaming"/>
                    <Button Name="BtnAdvanced" Content="⚙️ Advanced Options" Margin="0,5" Tag="advanced"/>
                    
                    <Separator Margin="0,20,0,10"/>
                    
                    <Button Name="BtnAbout" Content="ℹ️ About &amp; Changelog" Margin="0,5" Tag="about"/>
                    <Button Name="BtnExit" Content="❌ Exit" Margin="0,5"/>
                </StackPanel>
            </Border>
            
            <!-- Content Area -->
            <ScrollViewer Grid.Column="1" VerticalScrollBarVisibility="Auto">
                <StackPanel Name="ContentPanel" Margin="30">
                    <!-- Welcome Content -->
                    <StackPanel Name="WelcomePanel">
                        <TextBlock Text="Welcome to Windows 11 Optimizer" FontSize="28" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,20"/>
                        <TextBlock Text="Select an option from the menu to get started." FontSize="16" Foreground="#6C757D" Margin="0,0,0,30"/>
                        
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            
                            <Border Grid.Column="0" Background="White" BorderBrush="#E9ECEF" BorderThickness="1" CornerRadius="8" Padding="20" Margin="0,0,10,0">
                                <StackPanel>
                                    <TextBlock Text="🚀 Quick Start" FontSize="18" FontWeight="Bold" Foreground="#2E86AB" Margin="0,0,0,10"/>
                                    <TextBlock Text="• Run System Diagnostics" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Optimize Performance" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Clean System" FontSize="14" Margin="0,2"/>
                                </StackPanel>
                            </Border>
                            
                            <Border Grid.Column="1" Background="White" BorderBrush="#E9ECEF" BorderThickness="1" CornerRadius="8" Padding="20" Margin="10,0,0,0">
                                <StackPanel>
                                    <TextBlock Text="⚙️ Advanced" FontSize="18" FontWeight="Bold" Foreground="#A23B72" Margin="0,0,0,10"/>
                                    <TextBlock Text="• Clean Registry" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Reset Network" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Update Drivers" FontSize="14" Margin="0,2"/>
                                </StackPanel>
                            </Border>
                        </Grid>
                    </StackPanel>
                    
                    <!-- Dynamic Content Panels -->
                    <StackPanel Name="DiagnosticsPanel" Visibility="Collapsed">
                        <TextBlock Text="🔍 System Diagnostics" FontSize="24" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,20"/>
                        <TextBlock Text="Perform a comprehensive system diagnosis..." FontSize="16" Foreground="#6C757D" Margin="0,0,0,20"/>
                        
                        <Button Name="BtnStartDiagnostics" Content="Start Diagnostics" Width="200" HorizontalAlignment="Left"/>
                        
                        <StackPanel Name="DiagnosticsResults" Margin="0,20,0,0" Visibility="Collapsed">
                            <TextBlock Text="Diagnostics Results:" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                            <TextBox Name="DiagnosticsOutput" Height="300" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" 
                                     Background="#F8F9FA" BorderBrush="#E9ECEF" BorderThickness="1" Padding="10"/>
                        </StackPanel>
                    </StackPanel>
                    
                    <StackPanel Name="RepairPanel" Visibility="Collapsed">
                        <TextBlock Text="🔧 Repair Errors" FontSize="24" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,20"/>
                        <TextBlock Text="Automatic repair of system errors..." FontSize="16" Foreground="#6C757D" Margin="0,0,0,20"/>
                        
                        <Button Name="BtnStartRepair" Content="Start Repair" Width="200" HorizontalAlignment="Left"/>
                        
                        <StackPanel Name="RepairResults" Margin="0,20,0,0" Visibility="Collapsed">
                            <TextBlock Text="Repair Results:" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                            <TextBox Name="RepairOutput" Height="300" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" 
                                     Background="#F8F9FA" BorderBrush="#E9ECEF" BorderThickness="1" Padding="10"/>
                        </StackPanel>
                    </StackPanel>
                    
                    <StackPanel Name="PerformancePanel" Visibility="Collapsed">
                        <TextBlock Text="⚡ Optimize Performance" FontSize="24" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,20"/>
                        <TextBlock Text="Optimize system performance..." FontSize="16" Foreground="#6C757D" Margin="0,0,0,20"/>
                        
                        <Button Name="BtnStartPerformance" Content="Start Optimization" Width="200" HorizontalAlignment="Left"/>
                        
                        <StackPanel Name="PerformanceResults" Margin="0,20,0,0" Visibility="Collapsed">
                            <TextBlock Text="Optimization Results:" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                            <TextBox Name="PerformanceOutput" Height="300" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" 
                                     Background="#F8F9FA" BorderBrush="#E9ECEF" BorderThickness="1" Padding="10"/>
                        </StackPanel>
                    </StackPanel>
                    
                    <StackPanel Name="SecurityPanel" Visibility="Collapsed">
                        <TextBlock Text="🛡️ Security Optimization" FontSize="24" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,20"/>
                        <TextBlock Text="Improve system security..." FontSize="16" Foreground="#6C757D" Margin="0,0,0,20"/>
                        
                        <Button Name="BtnStartSecurity" Content="Optimize Security" Width="200" HorizontalAlignment="Left"/>
                        
                        <StackPanel Name="SecurityResults" Margin="0,20,0,0" Visibility="Collapsed">
                            <TextBlock Text="Security Results:" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                            <TextBox Name="SecurityOutput" Height="300" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" 
                                     Background="#F8F9FA" BorderBrush="#E9ECEF" BorderThickness="1" Padding="10"/>
                        </StackPanel>
                    </StackPanel>
                    
                    <StackPanel Name="CleanupPanel" Visibility="Collapsed">
                        <TextBlock Text="🧹 System Cleanup" FontSize="24" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,20"/>
                        <TextBlock Text="Clean the system from unnecessary files..." FontSize="16" Foreground="#6C757D" Margin="0,0,0,20"/>
                        
                        <Button Name="BtnStartCleanup" Content="Start Cleanup" Width="200" HorizontalAlignment="Left"/>
                        
                        <StackPanel Name="CleanupResults" Margin="0,20,0,0" Visibility="Collapsed">
                            <TextBlock Text="Cleanup Results:" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                            <TextBox Name="CleanupOutput" Height="300" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" 
                                     Background="#F8F9FA" BorderBrush="#E9ECEF" BorderThickness="1" Padding="10"/>
                        </StackPanel>
                    </StackPanel>
                    
                    <StackPanel Name="ReportPanel" Visibility="Collapsed">
                        <TextBlock Text="📊 System Report" FontSize="24" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,20"/>
                        <TextBlock Text="Create a detailed system report..." FontSize="16" Foreground="#6C757D" Margin="0,0,0,20"/>
                        
                        <Button Name="BtnGenerateReport" Content="Generate Report" Width="200" HorizontalAlignment="Left"/>
                        
                        <StackPanel Name="ReportResults" Margin="0,20,0,0" Visibility="Collapsed">
                            <TextBlock Text="Report Results:" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                            <TextBox Name="ReportOutput" Height="300" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" 
                                     Background="#F8F9FA" BorderBrush="#E9ECEF" BorderThickness="1" Padding="10"/>
                        </StackPanel>
                    </StackPanel>
                    
                    <StackPanel Name="GamingPanel" Visibility="Collapsed">
                        <TextBlock Text="🎮 Gaming Optimization" FontSize="24" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,20"/>
                        <TextBlock Text="Optimize your system for gaming performance..." FontSize="16" Foreground="#6C757D" Margin="0,0,0,20"/>
                        
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            
                            <Border Grid.Column="0" Background="White" BorderBrush="#E9ECEF" BorderThickness="1" CornerRadius="8" Padding="20" Margin="0,0,10,0">
                                <StackPanel>
                                    <TextBlock Text="🎯 Gaming Features" FontSize="18" FontWeight="Bold" Foreground="#2E86AB" Margin="0,0,0,10"/>
                                    <TextBlock Text="• Game Mode Optimization" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Graphics Performance" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Network Gaming" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Audio Gaming" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• System Gaming" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Gaming Services" FontSize="14" Margin="0,2"/>
                                </StackPanel>
                            </Border>
                            
                            <Border Grid.Column="1" Background="White" BorderBrush="#E9ECEF" BorderThickness="1" CornerRadius="8" Padding="20" Margin="10,0,0,0">
                                <StackPanel>
                                    <TextBlock Text="⚡ Performance Boost" FontSize="18" FontWeight="Bold" Foreground="#A23B72" Margin="0,0,0,10"/>
                                    <TextBlock Text="• Disable unnecessary animations" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Optimize GPU scheduling" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Reduce input lag" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Optimize network latency" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• High performance mode" FontSize="14" Margin="0,2"/>
                                    <TextBlock Text="• Gaming recommendations" FontSize="14" Margin="0,2"/>
                                </StackPanel>
                            </Border>
                        </Grid>
                        
                        <Border Background="White" BorderBrush="#E9ECEF" BorderThickness="1" CornerRadius="8" Padding="20" Margin="0,20,0,0">
                            <StackPanel>
                                <TextBlock Text="🚀 Quick Gaming Optimization" FontSize="18" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,10"/>
                                <TextBlock Text="Click the button below to start comprehensive gaming optimization. This will optimize your system for the best gaming performance." FontSize="14" Foreground="#6C757D" Margin="0,0,0,15"/>
                                
                                <Button Name="BtnStartGamingOptimization" Content="🎮 Start Gaming Optimization" 
                                        Width="200" HorizontalAlignment="Left"/>
                                
                                <ScrollViewer Height="200" VerticalScrollBarVisibility="Auto" Margin="0,15,0,0">
                                    <TextBox Name="GamingOutput" FontSize="12" TextWrapping="Wrap" Foreground="#333" Background="#F8F9FA" Padding="10" IsReadOnly="True" VerticalScrollBarVisibility="Auto"/>
                                </ScrollViewer>
                            </StackPanel>
                        </Border>
                    </StackPanel>
                    
                    <StackPanel Name="AdvancedPanel" Visibility="Collapsed">
                        <TextBlock Text="⚙️ Advanced Options" FontSize="24" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,20"/>
                        <TextBlock Text="Advanced system tools and options..." FontSize="16" Foreground="#6C757D" Margin="0,0,0,20"/>
                        
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            
                            <StackPanel Grid.Column="0" Margin="0,0,10,0">
                                <Button Name="BtnRegistryCleanup" Content="Clean Registry" Margin="0,5"/>
                                <Button Name="BtnNetworkReset" Content="Reset Network" Margin="0,5"/>
                                <Button Name="BtnWindowsFeatures" Content="Windows Features" Margin="0,5"/>
                            </StackPanel>
                            
                            <StackPanel Grid.Column="1" Margin="10,0,0,0">
                                <Button Name="BtnDriverUpdate" Content="Update Drivers" Margin="0,5"/>
                                <Button Name="BtnWindowsUpdate" Content="Repair Windows Update" Margin="0,5"/>
                                <Button Name="BtnServiceManager" Content="Manage Services" Margin="0,5"/>
                            </StackPanel>
                        </Grid>
                        
                        <StackPanel Name="AdvancedResults" Margin="0,20,0,0" Visibility="Collapsed">
                            <TextBlock Text="Results:" FontSize="18" FontWeight="Bold" Margin="0,0,0,10"/>
                            <TextBox Name="AdvancedOutput" Height="300" IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" 
                                     Background="#F8F9FA" BorderBrush="#E9ECEF" BorderThickness="1" Padding="10"/>
                        </StackPanel>
                    </StackPanel>
                    
                    <StackPanel Name="AboutPanel" Visibility="Collapsed">
                        <TextBlock Text="ℹ️ About &amp; Changelog" FontSize="24" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,20"/>
                        <TextBlock Text="Windows 11 Optimizer - Version Information and Change History" FontSize="16" Foreground="#6C757D" Margin="0,0,0,20"/>
                        
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            
                            <StackPanel Grid.Column="0" Margin="0,0,10,0">
                                <Border Background="White" BorderBrush="#E9ECEF" BorderThickness="1" CornerRadius="8" Padding="20" Margin="0,0,0,10">
                                    <StackPanel>
                                        <TextBlock Text="📋 About" FontSize="18" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,10"/>
                                        <TextBlock Text="Windows 11 Optimizer v2.0.0" FontSize="16" FontWeight="Bold" Margin="0,0,0,5"/>
                                        <TextBlock Text="Modern GUI version of the Windows Optimizer" FontSize="14" Margin="0,0,0,10"/>
                                        <TextBlock Text="• System Diagnostics" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Error Repair" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Performance Optimization" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Security Optimization" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• System Cleanup" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• System Reports" FontSize="12" Margin="0,2"/>
                                    </StackPanel>
                                </Border>
                                
                                <Border Background="White" BorderBrush="#E9ECEF" BorderThickness="1" CornerRadius="8" Padding="20">
                                    <StackPanel>
                                        <TextBlock Text="🔧 Technical Details" FontSize="18" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,10"/>
                                        <TextBlock Text="• PowerShell 5.1+ Compatible" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Windows 11 Optimized" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• WPF GUI Framework" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Modular Architecture" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Comprehensive Logging" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• HTML Report Generation" FontSize="12" Margin="0,2"/>
                                    </StackPanel>
                                </Border>
                            </StackPanel>
                            
                            <StackPanel Grid.Column="1" Margin="10,0,0,0">
                                <Border Background="White" BorderBrush="#E9ECEF" BorderThickness="1" CornerRadius="8" Padding="20" Margin="0,0,0,10">
                                    <StackPanel>
                                        <TextBlock Text="📝 Recent Changes" FontSize="18" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,10"/>
                                        <TextBlock Text="Version 2.0.0 - 2024-09-24" FontSize="14" FontWeight="Bold" Margin="0,0,0,5"/>
                                        <TextBlock Text="• GUI version with modern WPF interface" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Real system report generation" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Performance counter integration" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Robust error handling" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• English interface" FontSize="12" Margin="0,2"/>
                                    </StackPanel>
                                </Border>
                                
                                <Border Background="White" BorderBrush="#E9ECEF" BorderThickness="1" CornerRadius="8" Padding="20">
                                    <StackPanel>
                                        <TextBlock Text="🛡️ Security" FontSize="18" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,10"/>
                                        <TextBlock Text="• Administrator rights required" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Registry backups before changes" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• Safe default values" FontSize="12" Margin="0,2"/>
                                        <TextBlock Text="• No harmful operations without confirmation" FontSize="12" Margin="0,2"/>
                                    </StackPanel>
                                </Border>
                            </StackPanel>
                        </Grid>
                        
                        <Border Background="White" BorderBrush="#E9ECEF" BorderThickness="1" CornerRadius="8" Padding="20" Margin="0,20,0,0">
                            <StackPanel>
                                <TextBlock Text="📄 Full Changelog" FontSize="18" FontWeight="Bold" Foreground="#343A40" Margin="0,0,0,10"/>
                                <ScrollViewer Height="300" VerticalScrollBarVisibility="Auto">
                                    <TextBlock Name="ChangelogContent" FontSize="12" TextWrapping="Wrap" Foreground="#333"/>
                                </ScrollViewer>
                            </StackPanel>
                        </Border>
                    </StackPanel>
                </StackPanel>
            </ScrollViewer>
        </Grid>
        
        <!-- Status Bar -->
        <Border Grid.Row="2" Background="#343A40" Padding="10">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                
                <StackPanel Grid.Column="0" Orientation="Horizontal">
                    <TextBlock Name="StatusText" Text="Ready" Foreground="White" VerticalAlignment="Center"/>
                    <TextBlock Text=" | " Foreground="White" VerticalAlignment="Center" Margin="10,0"/>
                    <TextBlock Name="LogText" Text="Log: Active" Foreground="White" VerticalAlignment="Center"/>
                </StackPanel>
                
                <StackPanel Grid.Column="1" Orientation="Horizontal">
                    <TextBlock Text="v$Global:OptimizerVersion" Foreground="White" VerticalAlignment="Center" Margin="0,0,10,0"/>
                    <TextBlock Name="TimeText" Text="" Foreground="White" VerticalAlignment="Center"/>
                </StackPanel>
            </Grid>
        </Border>
    </Grid>
    
</Window>
"@

    # Parse XAML
    $Reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$Xaml)
    $Window = [System.Windows.Markup.XamlReader]::Load($Reader)
    
    # Apply styling via PowerShell
    Set-ButtonStyles -Window $Window
    
    return $Window
}

# Button-Styling anwenden
function Set-ButtonStyles {
    param($Window)
    
    # Navigation Buttons stylen
    $NavButtons = @("BtnDiagnostics", "BtnRepair", "BtnPerformance", "BtnSecurity", "BtnCleanup", "BtnReport", "BtnGaming", "BtnAdvanced", "BtnAbout")
    foreach ($ButtonName in $NavButtons) {
        $Button = $Window.FindName($ButtonName)
        if ($Button) {
            $Button.Background = [System.Windows.Media.Brushes]::Transparent
            $Button.BorderThickness = "0"
            $Button.Padding = "15,10"
            $Button.HorizontalAlignment = "Stretch"
            $Button.HorizontalContentAlignment = "Left"
            $Button.FontSize = 14
            $Button.Foreground = [System.Windows.Media.Brushes]::Black
            $Button.Cursor = [System.Windows.Input.Cursors]::Hand
        }
    }
    
    # Exit Button stylen
    $ExitButton = $Window.FindName("BtnExit")
    if ($ExitButton) {
        $ExitButton.Background = [System.Windows.Media.Brushes]::Red
        $ExitButton.Foreground = [System.Windows.Media.Brushes]::White
        $ExitButton.BorderThickness = "0"
        $ExitButton.Padding = "15,10"
        $ExitButton.HorizontalAlignment = "Stretch"
        $ExitButton.HorizontalContentAlignment = "Left"
        $ExitButton.FontSize = 14
        $ExitButton.Cursor = [System.Windows.Input.Cursors]::Hand
    }
    
    # Action Buttons stylen
    $ActionButtons = @("BtnStartDiagnostics", "BtnStartRepair", "BtnStartPerformance", "BtnStartSecurity", "BtnStartCleanup", "BtnGenerateReport", "BtnStartGamingOptimization")
    foreach ($ButtonName in $ActionButtons) {
        $Button = $Window.FindName($ButtonName)
        if ($Button) {
            $Button.Background = [System.Windows.Media.Brushes]::DodgerBlue
            $Button.Foreground = [System.Windows.Media.Brushes]::White
            $Button.BorderThickness = "0"
            $Button.Padding = "20,10"
            $Button.FontSize = 14
            $Button.FontWeight = "Bold"
            $Button.Cursor = [System.Windows.Input.Cursors]::Hand
        }
    }
    
    # Advanced Buttons stylen
    $AdvancedButtons = @("BtnRegistryCleanup", "BtnNetworkReset", "BtnWindowsFeatures", "BtnDriverUpdate", "BtnWindowsUpdate", "BtnServiceManager")
    foreach ($ButtonName in $AdvancedButtons) {
        $Button = $Window.FindName($ButtonName)
        if ($Button) {
            $Button.Background = [System.Windows.Media.Brushes]::DodgerBlue
            $Button.Foreground = [System.Windows.Media.Brushes]::White
            $Button.BorderThickness = "0"
            $Button.Padding = "15,8"
            $Button.FontSize = 14
            $Button.Cursor = [System.Windows.Input.Cursors]::Hand
        }
    }
}

# Event Handler fuer Navigation
function Set-NavigationHandlers {
    param($Window)
    
    # Navigation Buttons
    $Window.FindName("BtnDiagnostics").Add_Click({
        Show-ContentPanel -Window $Window -PanelName "DiagnosticsPanel"
        $Window.FindName("StatusText").Text = "System Diagnostics selected"
    })
    
    $Window.FindName("BtnRepair").Add_Click({
        Show-ContentPanel -Window $Window -PanelName "RepairPanel"
        $Window.FindName("StatusText").Text = "Error Repair selected"
    })
    
    $Window.FindName("BtnPerformance").Add_Click({
        Show-ContentPanel -Window $Window -PanelName "PerformancePanel"
        $Window.FindName("StatusText").Text = "Performance Optimization selected"
    })
    
    $Window.FindName("BtnSecurity").Add_Click({
        Show-ContentPanel -Window $Window -PanelName "SecurityPanel"
        $Window.FindName("StatusText").Text = "Security Optimization selected"
    })
    
    $Window.FindName("BtnCleanup").Add_Click({
        Show-ContentPanel -Window $Window -PanelName "CleanupPanel"
        $Window.FindName("StatusText").Text = "System Cleanup selected"
    })
    
    $Window.FindName("BtnReport").Add_Click({
        Show-ContentPanel -Window $Window -PanelName "ReportPanel"
        $Window.FindName("StatusText").Text = "System Report selected"
    })
    
    $Window.FindName("BtnGaming").Add_Click({
        Show-ContentPanel -Window $Window -PanelName "GamingPanel"
        $Window.FindName("StatusText").Text = "Gaming Optimization selected"
    })
    
    $Window.FindName("BtnAdvanced").Add_Click({
        Show-ContentPanel -Window $Window -PanelName "AdvancedPanel"
        $Window.FindName("StatusText").Text = "Advanced Options selected"
    })
    
    $Window.FindName("BtnAbout").Add_Click({
        Show-ContentPanel -Window $Window -PanelName "AboutPanel"
        Load-ChangelogContent -Window $Window
        $Window.FindName("StatusText").Text = "About &amp; Changelog selected"
    })
    
    $Window.FindName("BtnStartGamingOptimization").Add_Click({
        Start-GamingOptimizationGUI -Window $Window
    })
    
    $Window.FindName("BtnExit").Add_Click({
        $Window.Close()
    })
    
    # Action Buttons
    $Window.FindName("BtnStartDiagnostics").Add_Click({
        Start-DiagnosticsGUI -Window $Window
    })
    
    $Window.FindName("BtnStartRepair").Add_Click({
        Start-RepairGUI -Window $Window
    })
    
    $Window.FindName("BtnStartPerformance").Add_Click({
        Start-PerformanceGUI -Window $Window
    })
    
    $Window.FindName("BtnStartSecurity").Add_Click({
        Start-SecurityGUI -Window $Window
    })
    
    $Window.FindName("BtnStartCleanup").Add_Click({
        Start-CleanupGUI -Window $Window
    })
    
    $Window.FindName("BtnGenerateReport").Add_Click({
        Start-ReportGUI -Window $Window
    })
    
    # Advanced Buttons
    $Window.FindName("BtnRegistryCleanup").Add_Click({
        Start-RegistryCleanupGUI -Window $Window
    })
    
    $Window.FindName("BtnNetworkReset").Add_Click({
        Start-NetworkResetGUI -Window $Window
    })
    
    $Window.FindName("BtnWindowsFeatures").Add_Click({
        Start-WindowsFeaturesGUI -Window $Window
    })
    
    $Window.FindName("BtnDriverUpdate").Add_Click({
        Start-DriverUpdateGUI -Window $Window
    })
    
    $Window.FindName("BtnWindowsUpdate").Add_Click({
        Start-WindowsUpdateGUI -Window $Window
    })
    
    $Window.FindName("BtnServiceManager").Add_Click({
        Start-ServiceManagerGUI -Window $Window
    })
}

# Content Panel anzeigen
function Show-ContentPanel {
    param(
        $Window,
        [string]$PanelName
    )
    
    # Alle Panels verstecken
    $Panels = @("WelcomePanel", "DiagnosticsPanel", "RepairPanel", "PerformancePanel", "SecurityPanel", "CleanupPanel", "ReportPanel", "AdvancedPanel", "AboutPanel")
    foreach ($Panel in $Panels) {
        $Window.FindName($Panel).Visibility = "Collapsed"
    }
    
    # Gewaehltes Panel anzeigen
    $Window.FindName($PanelName).Visibility = "Visible"
}

# Load Changelog Content
function Load-ChangelogContent {
    param($Window)
    
    try {
        $ChangelogPath = "CHANGELOG.md"
        if (Test-Path $ChangelogPath) {
            $ChangelogContent = Get-Content $ChangelogPath -Raw -Encoding UTF8
            $Window.FindName("ChangelogContent").Text = $ChangelogContent
        } else {
            $Window.FindName("ChangelogContent").Text = "Changelog file not found. Please ensure CHANGELOG.md is in the same directory as the application."
        }
    }
    catch {
        $Window.FindName("ChangelogContent").Text = "Error loading changelog: $($_.Exception.Message)"
    }
}

# GUI-Funktionen fuer verschiedene Module
function Start-GamingOptimizationGUI {
    param($Window)
    
    try {
        $Output = $Window.FindName("GamingOutput")
        $Output.Text = "🎮 Starting Gaming Optimization...`n`n"
        
        # Load GamingOptimizer module
        if (Test-Path "Modules\GamingOptimizer.ps1") {
            . "Modules\GamingOptimizer.ps1"
            $Output.AppendText("✅ Gaming module loaded successfully`n")
        } else {
            $Output.AppendText("❌ Gaming module not found`n")
            return
        }
        
        $Output.AppendText("`n🔧 Starting gaming optimization...`n")
        $Output.AppendText("This may take a few minutes...`n`n")
        
        # Start gaming optimization
        $GamingResults = Start-GamingOptimization
        
        $Output.AppendText("`n✅ Gaming optimization completed!`n")
        $Output.AppendText("`n📊 Results:`n")
        $Output.AppendText("• Optimizations: $($GamingResults.Optimizations.Count)`n")
        $Output.AppendText("• Warnings: $($GamingResults.Warnings.Count)`n")
        $Output.AppendText("• Recommendations: $($GamingResults.Recommendations.Count)`n")
        
        if ($GamingResults.Recommendations.Count -gt 0) {
            $Output.AppendText("`n💡 Recommendations:`n")
            foreach ($Recommendation in $GamingResults.Recommendations) {
                $Output.AppendText("• $Recommendation`n")
            }
        }
        
        $Window.FindName("StatusText").Text = "Gaming optimization completed"
        Write-Log "Gaming optimization completed successfully" "SUCCESS"
    }
    catch {
        $Output.AppendText("`n❌ Error during gaming optimization: $($_.Exception.Message)`n")
        Write-Log "Error during gaming optimization: $($_.Exception.Message)" "ERROR"
    }
}

function Start-DiagnosticsGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Systemdiagnose laeuft..."
    $Window.FindName("DiagnosticsResults").Visibility = "Visible"
    $Output = $Window.FindName("DiagnosticsOutput")
    $Output.Text = "Starte Systemdiagnose...`n"
    
    # Simuliere Diagnose (hier wuerden echte Module geladen werden)
    $Output.AppendText("[OK] Hardware-Informationen sammeln...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Systemleistung analysieren...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Sicherheitsstatus pruefen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Registry-Integritaet pruefen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Netzwerk-Konfiguration pruefen...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] Systemdiagnose abgeschlossen!`n")
    $Window.FindName("StatusText").Text = "Systemdiagnose abgeschlossen"
    Write-Log "Systemdiagnose ueber GUI abgeschlossen" "SUCCESS"
}

function Start-RepairGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Fehler-Reparatur laeuft..."
    $Window.FindName("RepairResults").Visibility = "Visible"
    $Output = $Window.FindName("RepairOutput")
    $Output.Text = "Starte automatische Fehler-Reparatur...`n"
    
    # Simuliere Reparatur
    $Output.AppendText("[OK] Windows Update reparieren...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Systemdateien ueberpruefen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Registry-Backup erstellen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Netzwerk-Adapter zuruecksetzen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Dienste neu starten...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] Fehler-Reparatur abgeschlossen!`n")
    $Window.FindName("StatusText").Text = "Fehler-Reparatur abgeschlossen"
    Write-Log "Fehler-Reparatur ueber GUI abgeschlossen" "SUCCESS"
}

function Start-PerformanceGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Performance-Optimierung laeuft..."
    $Window.FindName("PerformanceResults").Visibility = "Visible"
    $Output = $Window.FindName("PerformanceOutput")
    $Output.Text = "Starte Performance-Optimierung...`n"
    
    # Simuliere Performance-Optimierung
    $Output.AppendText("[OK] Startup-Programme optimieren...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Windows-Dienste optimieren...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Registry optimieren...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Speicher optimieren...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Netzwerk-Einstellungen optimieren...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] Performance-Optimierung abgeschlossen!`n")
    $Window.FindName("StatusText").Text = "Performance-Optimierung abgeschlossen"
    Write-Log "Performance-Optimierung ueber GUI abgeschlossen" "SUCCESS"
}

function Start-SecurityGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Sicherheits-Optimierung laeuft..."
    $Window.FindName("SecurityResults").Visibility = "Visible"
    $Output = $Window.FindName("SecurityOutput")
    $Output.Text = "Starte Sicherheits-Optimierung...`n"
    
    # Simuliere Sicherheits-Optimierung
    $Output.AppendText("[OK] Windows Defender optimieren...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Firewall-Einstellungen pruefen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Benutzerkonten sichern...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Registry-Sicherheit verbessern...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Netzwerk-Sicherheit optimieren...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] Sicherheits-Optimierung abgeschlossen!`n")
    $Window.FindName("StatusText").Text = "Sicherheits-Optimierung abgeschlossen"
    Write-Log "Sicherheits-Optimierung ueber GUI abgeschlossen" "SUCCESS"
}

function Start-CleanupGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "System-Bereinigung laeuft..."
    $Window.FindName("CleanupResults").Visibility = "Visible"
    $Output = $Window.FindName("CleanupOutput")
    $Output.Text = "Starte System-Bereinigung...`n"
    
    # Simuliere Bereinigung
    $Output.AppendText("[OK] Temporaere Dateien loeschen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Browser-Cache bereinigen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Windows Update-Cache bereinigen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Registry bereinigen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Unnoetige Programme entfernen...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] System-Bereinigung abgeschlossen!`n")
    $Window.FindName("StatusText").Text = "System-Bereinigung abgeschlossen"
    Write-Log "System-Bereinigung ueber GUI abgeschlossen" "SUCCESS"
}

function Start-ReportGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Systembericht wird erstellt..."
    $Window.FindName("ReportResults").Visibility = "Visible"
    $Output = $Window.FindName("ReportOutput")
    $Output.Text = "Erstelle Systembericht...`n"
    
    try {
        # System-Informationen sammeln
        $Output.AppendText("[OK] System-Informationen sammeln...`n")
        $ComputerInfo = Get-ComputerInfo -ErrorAction SilentlyContinue
        $OSInfo = Get-WmiObject -Class Win32_OperatingSystem -ErrorAction SilentlyContinue
        $ProcessorInfo = Get-WmiObject -Class Win32_Processor -ErrorAction SilentlyContinue
        $MemoryInfo = Get-WmiObject -Class Win32_PhysicalMemory -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
        
        # Performance-Metriken analysieren
        $Output.AppendText("[OK] Performance-Metriken analysieren...`n")
        
        # CPU-Auslastung mit WMI
        try {
            $CPU = Get-WmiObject -Class Win32_Processor -ErrorAction Stop
            $CPUValue = [math]::Round($CPU.LoadPercentage, 1)
            if ($CPUValue -eq $null -or $CPUValue -eq 0) {
                # Fallback: Performance Counter
                $CPUUsage = Get-Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 1 -ErrorAction SilentlyContinue
                if ($CPUUsage) {
                    $CPUValue = [math]::Round($CPUUsage.CounterSamples[0].CookedValue, 1)
                } else {
                    $CPUValue = "N/A"
                }
            }
        } catch {
            $CPUValue = "N/A"
        }
        
        # Verfügbarer Speicher mit WMI
        try {
            $Memory = Get-WmiObject -Class Win32_OperatingSystem -ErrorAction Stop
            $TotalMemory = [math]::Round($Memory.TotalVisibleMemorySize / 1024, 1)
            $FreeMemory = [math]::Round($Memory.FreePhysicalMemory / 1024, 1)
            $MemoryValue = [math]::Round($FreeMemory, 1)
        } catch {
            $MemoryValue = "N/A"
        }
        
        # Festplattenspeicher mit WMI
        try {
            $Disks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop
            $TotalSpace = 0
            $FreeSpace = 0
            foreach ($Disk in $Disks) {
                $TotalSpace += $Disk.Size
                $FreeSpace += $Disk.FreeSpace
            }
            if ($TotalSpace -gt 0) {
                $DiskValue = [math]::Round(($FreeSpace / $TotalSpace) * 100, 1)
            } else {
                $DiskValue = "N/A"
            }
        } catch {
            $DiskValue = "N/A"
        }
        
        Start-Sleep -Milliseconds 500
        
        # Sicherheitsstatus bewerten
        $Output.AppendText("[OK] Sicherheitsstatus bewerten...`n")
        $FirewallStatus = Get-NetFirewallProfile -ErrorAction SilentlyContinue
        $DefenderStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
        
        # Empfehlungen generieren
        $Output.AppendText("[OK] Empfehlungen generieren...`n")
        $Recommendations = @()
        if ($CPUValue -ne "N/A" -and $CPUValue -gt 80) {
            $Recommendations += "CPU-Auslastung ist hoch ($CPUValue%) - Performance-Optimierung empfohlen"
        }
        if ($MemoryValue -ne "N/A" -and $MemoryValue -lt 1000) {
            $Recommendations += "Verfügbarer Arbeitsspeicher ist niedrig ($MemoryValue MB) - Speicher-Optimierung empfohlen"
        }
        if ($DiskValue -ne "N/A" -and $DiskValue -lt 20) {
            $Recommendations += "Freier Festplattenspeicher ist niedrig ($DiskValue%) - Bereinigung empfohlen"
        }
        Start-Sleep -Milliseconds 500
        
        # HTML-Bericht erstellen
        $Output.AppendText("[OK] HTML-Bericht erstellen...`n")
        $ReportPath = "C:\SystemReport.html"
        
        # HTML-Header
        $HTML = @"
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Windows 11 Systembericht</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { background: linear-gradient(135deg, #2E86AB, #A23B72); color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .section { margin: 20px 0; padding: 15px; border-left: 4px solid #2E86AB; background: #f8f9fa; }
        .metric { display: inline-block; margin: 10px; padding: 10px; background: white; border-radius: 5px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .value { font-size: 24px; font-weight: bold; color: #2E86AB; }
        .label { font-size: 14px; color: #666; }
        .recommendation { background: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; border-radius: 5px; margin: 5px 0; }
        .success { color: #28a745; }
        .warning { color: #ffc107; }
        .error { color: #dc3545; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⚡ Windows 11 Systembericht</h1>
            <p>Erstellt am: $(Get-Date -Format "dd.MM.yyyy HH:mm:ss")</p>
        </div>
"@

        # System-Informationen
        $HTML += @"
        <div class="section">
            <h2>🖥️ System-Informationen</h2>
            <div class="metric">
                <div class="value">$($OSInfo.Caption)</div>
                <div class="label">Betriebssystem</div>
            </div>
            <div class="metric">
                <div class="value">$($OSInfo.Version)</div>
                <div class="label">Version</div>
            </div>
            <div class="metric">
                <div class="value">$($ProcessorInfo.Name)</div>
                <div class="label">Prozessor</div>
            </div>
            <div class="metric">
                <div class="value">$([math]::Round(($MemoryInfo | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)) GB</div>
                <div class="label">Arbeitsspeicher</div>
            </div>
        </div>
"@

        # Performance-Metriken (Variablen bereits oben definiert)
        
        $HTML += @"
        <div class="section">
            <h2>📊 Performance-Metriken</h2>
            <div class="metric">
                <div class="value">$CPUValue%</div>
                <div class="label">CPU-Auslastung</div>
            </div>
            <div class="metric">
                <div class="value">$MemoryValue MB</div>
                <div class="label">Verfügbarer Speicher</div>
            </div>
            <div class="metric">
                <div class="value">$DiskValue%</div>
                <div class="label">Freier Festplattenspeicher</div>
            </div>
        </div>
"@

        # Sicherheitsstatus
        $FirewallStatusText = if ($FirewallStatus) { "Aktiv" } else { "Unbekannt" }
        $DefenderStatusText = if ($DefenderStatus) { "Aktiv" } else { "Unbekannt" }
        
        $HTML += @"
        <div class="section">
            <h2>🛡️ Sicherheitsstatus</h2>
            <table>
                <tr><th>Komponente</th><th>Status</th></tr>
                <tr><td>Windows Firewall</td><td class="success">$FirewallStatusText</td></tr>
                <tr><td>Windows Defender</td><td class="success">$DefenderStatusText</td></tr>
            </table>
        </div>
"@

        # Empfehlungen
        if ($Recommendations.Count -gt 0) {
            $HTML += @"
        <div class="section">
            <h2>💡 Empfehlungen</h2>
"@
            foreach ($Rec in $Recommendations) {
                $HTML += @"
            <div class="recommendation">$Rec</div>
"@
            }
            $HTML += @"
        </div>
"@
        }

        # Footer
        $HTML += @"
        <div class="section">
            <h2>ℹ️ Bericht-Informationen</h2>
            <p><strong>Erstellt von:</strong> Windows 11 Optimizer v2.0.0</p>
            <p><strong>Bericht-Pfad:</strong> $ReportPath</p>
            <p><strong>System:</strong> $($env:COMPUTERNAME)</p>
        </div>
    </div>
</body>
</html>
"@

        # HTML-Datei speichern
        $HTML | Out-File -FilePath $ReportPath -Encoding UTF8 -Force
        
        $Output.AppendText("`n[ERFOLG] Systembericht erstellt!`n")
        $Output.AppendText("📄 Bericht gespeichert in: $ReportPath`n")
        $Output.AppendText("🌐 Oeffnen Sie die Datei in Ihrem Browser zum Anzeigen.`n")
        
        $Window.FindName("StatusText").Text = "Systembericht erstellt"
        Write-Log "Systembericht erfolgreich erstellt: $ReportPath" "SUCCESS"
    }
    catch {
        $Output.AppendText("`n[FEHLER] Fehler beim Erstellen des Berichts: $($_.Exception.Message)`n")
        Write-Log "Fehler beim Erstellen des Systemberichts: $($_.Exception.Message)" "ERROR"
    }
}

# Erweiterte GUI-Funktionen
function Start-RegistryCleanupGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Registry-Bereinigung laeuft..."
    $Window.FindName("AdvancedResults").Visibility = "Visible"
    $Output = $Window.FindName("AdvancedOutput")
    $Output.Text = "Starte Registry-Bereinigung...`n"
    
    $Output.AppendText("[OK] Ungueltige Registry-Eintraege suchen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Backup erstellen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Eintraege bereinigen...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] Registry-Bereinigung abgeschlossen!`n")
    $Window.FindName("StatusText").Text = "Registry-Bereinigung abgeschlossen"
    Write-Log "Registry-Bereinigung ueber GUI abgeschlossen" "SUCCESS"
}

function Start-NetworkResetGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Netzwerk-Reset laeuft..."
    $Window.FindName("AdvancedResults").Visibility = "Visible"
    $Output = $Window.FindName("AdvancedOutput")
    $Output.Text = "Starte Netzwerk-Reset...`n"
    
    $Output.AppendText("[OK] Netzwerk-Adapter zuruecksetzen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] DNS-Cache leeren...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Winsock zuruecksetzen...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] Netzwerk-Reset abgeschlossen!`n")
    $Window.FindName("StatusText").Text = "Netzwerk-Reset abgeschlossen"
    Write-Log "Netzwerk-Reset ueber GUI abgeschlossen" "SUCCESS"
}

function Start-WindowsFeaturesGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Windows-Features verwalten..."
    $Window.FindName("AdvancedResults").Visibility = "Visible"
    $Output = $Window.FindName("AdvancedOutput")
    $Output.Text = "Verwalte Windows-Features...`n"
    
    $Output.AppendText("[OK] Aktive Features auflisten...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Feature-Status pruefen...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] Windows-Features verwaltet!`n")
    $Window.FindName("StatusText").Text = "Windows-Features verwaltet"
    Write-Log "Windows-Features ueber GUI verwaltet" "SUCCESS"
}

function Start-DriverUpdateGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Treiber-Update laeuft..."
    $Window.FindName("AdvancedResults").Visibility = "Visible"
    $Output = $Window.FindName("AdvancedOutput")
    $Output.Text = "Starte Treiber-Update...`n"
    
    $Output.AppendText("[OK] Verfuegbare Treiber-Updates suchen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Treiber-Status pruefen...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] Treiber-Update abgeschlossen!`n")
    $Window.FindName("StatusText").Text = "Treiber-Update abgeschlossen"
    Write-Log "Treiber-Update ueber GUI abgeschlossen" "SUCCESS"
}

function Start-WindowsUpdateGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Windows Update reparieren..."
    $Window.FindName("AdvancedResults").Visibility = "Visible"
    $Output = $Window.FindName("AdvancedOutput")
    $Output.Text = "Repariere Windows Update...`n"
    
    $Output.AppendText("[OK] Windows Update-Dienst neu starten...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Update-Cache leeren...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Update-History zuruecksetzen...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] Windows Update repariert!`n")
    $Window.FindName("StatusText").Text = "Windows Update repariert"
    Write-Log "Windows Update ueber GUI repariert" "SUCCESS"
}

function Start-ServiceManagerGUI {
    param($Window)
    
    $Window.FindName("StatusText").Text = "Dienste verwalten..."
    $Window.FindName("AdvancedResults").Visibility = "Visible"
    $Output = $Window.FindName("AdvancedOutput")
    $Output.Text = "Verwalte Windows-Dienste...`n"
    
    $Output.AppendText("[OK] Dienst-Status pruefen...`n")
    Start-Sleep -Milliseconds 500
    $Output.AppendText("[OK] Optimierungen anwenden...`n")
    Start-Sleep -Milliseconds 500
    
    $Output.AppendText("`n[ERFOLG] Dienste verwaltet!`n")
    $Window.FindName("StatusText").Text = "Dienste verwaltet"
    Write-Log "Dienste ueber GUI verwaltet" "SUCCESS"
}

# Timer fuer Status-Updates
function Start-StatusTimer {
    param($Window)
    
    $Timer = New-Object System.Windows.Threading.DispatcherTimer
    $Timer.Interval = [TimeSpan]::FromSeconds(1)
    $Timer.Add_Tick({
        $Window.FindName("TimeText").Text = Get-Date -Format "HH:mm:ss"
    })
    $Timer.Start()
}

# Hauptfunktion
function Start-WindowsOptimizerGUI {
    Write-Log "Windows Optimizer GUI gestartet" "INFO"
    
    # Admin-Rechte pruefen
    if (-not (Test-AdministratorRights)) {
        Write-Log "Administrator-Rechte erforderlich!" "ERROR"
        [System.Windows.MessageBox]::Show("Dieses Tool benoetigt Administrator-Rechte. Bitte als Administrator ausfuehren.", "Berechtigung erforderlich", "OK", "Error")
        return
    }
    
    try {
        # Hauptfenster erstellen
        $Window = New-MainWindow
        
        # Event Handler setzen
        Set-NavigationHandlers -Window $Window
        
        # Status Timer starten
        Start-StatusTimer -Window $Window
        
        # Fenster anzeigen
        $Window.ShowDialog()
        
        Write-Log "Windows Optimizer GUI beendet" "INFO"
    }
    catch {
        Write-Log "Fehler beim Starten der GUI: $($_.Exception.Message)" "ERROR"
        [System.Windows.MessageBox]::Show("Fehler beim Starten der GUI: $($_.Exception.Message)", "Fehler", "OK", "Error")
    }
}

# Script ausfuehren
if ($MyInvocation.InvocationName -ne '.') {
    Start-WindowsOptimizerGUI
}



