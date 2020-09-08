# Hello World script

param(
    $Test,
    $Test2
)

Write-Host "Hello World!"
Write-Host "Parameter Test:  $Test"
Write-Host "Parameter Test2: $Test2"
Write-Host "Parameter Arg0:  $($args[0])" 
Write-Host "Variables Demo:  $Demo"
Read-Host "Click Enter to continue..." 
