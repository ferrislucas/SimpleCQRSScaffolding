[T4Scaffolding.Scaffolder(Description = "Enter a description of testthing here")][CmdletBinding()]
param(        
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
    [string]$SomeParam,
	[switch]$Force = $false
)

$outputPath = "ExampleOutput"  # The filename extension will be added based on the template's <#@ Output Extension="..." #> directive
$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value

foreach ($proj in get-project -all) {
      write-host "Project $($proj.Name) is in this solution. : " $proj.FullName -- $proj.Properties.Item("Assemblyname").Value :: $proj.Properties.Item("Startupobject").Value.Name
    }