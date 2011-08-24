[T4Scaffolding.Scaffolder(Description = "Scaffolds a SimpleCQRSAggregateRoot based on a model object")][CmdletBinding()]
param(        
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
    [string]$Model,
	[switch]$Force = $false
)

if (!$Model)
{
    Write-Host "Usage: Scaffold SimpleCQRSAggregateRoot -Model <name of your model type>"
    exit
}

$modelProjectType = Get-ProjectType $Model
$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value

Write-Host "Scaffolding AggregateRoot with $modelProjectType.Members.Count properties..."

Add-ProjectItemViaTemplate "Domain\$Model" -Template SimpleCQRSAggregateRootTemplate `
    -Model @{ Namespace = $namespace; Name = $modelProjectType.Name } `
	-SuccessMessage "complete {0}" `
	-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force


foreach ($member in $modelProjectType.Members)
{
    Write-Host "    Scaffolding property:" $member.Name
    #Add-ClassMemberViaTemplate -CodeClass $modelProjectType -Template "SimpleCQRSAggregateRootPropertyTemplate" -Model @{ PropertyName = $member.Name; Fullname = $member.FullName } -TemplateFolders $TemplateFolders
}

@'

$outputPath = "ExampleOutput"  # The filename extension will be added based on the template's <#@ Output Extension="..." #> directive
$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value


write "asdfs"

Add-ProjectItemViaTemplate $outputPath -Template SimpleCQRSAggregateRootTemplate3 `
	-Model @{ Namespace = $namespace; ExampleValue = "Hello, world!" } `
	-SuccessMessage "Added SimpleCQRSAggregateRoot output at {0}" `
	-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force

'@ > $null