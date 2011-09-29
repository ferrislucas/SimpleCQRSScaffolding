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

#Write-Host "Scaffolding AggregateRoot with $modelProjectType.Members.Count properties..."

# Create Aggregate Root
Add-ProjectItemViaTemplate "Domain\$Model" -Template SimpleCQRSAggregateRootTemplate `
    -Model @{ Namespace = $namespace; Name = $modelProjectType.Name } `
	-SuccessMessage "{0} created succcessfully" `
	-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force

# Create AggregateRootCreatedEvent
Add-ProjectItemViaTemplate ("Events\$Model" + "CreatedEvent") -Template SimpleCQRSAggregateRootCreatedEventTemplate `
    -Model @{ Namespace = $namespace; Name = $modelProjectType.Name } `
	-SuccessMessage "{0} created succcessfully" `
	-TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force

# Create Aggregate Root property events
foreach ($member in $modelProjectType.Members)
{
    #Write-Host "    Scaffolding property:" $member.Type.AsFullName.ToString()
    #Add-ClassMemberViaTemplate -CodeClass $modelProjectType -Template "SimpleCQRSAggregateRootPropertySetEventTemplate" -Model @{ PropertyName = $member.Name; Fullname = $member.FullName } -TemplateFolders $TemplateFolders

    Add-ProjectItemViaTemplate ("Events\$Model" + $member.Name + "SetEvent") -Template SimpleCQRSAggregateRootPropertySetEventTemplate `
        -Model @{ Namespace = $namespace; Name = $modelProjectType.Name; PropertyName = $member.Name.ToString(); PropertyType = $member.Type.AsFullName.ToString() } `
	    -SuccessMessage "{0} created successfully" `
	    -TemplateFolders $TemplateFolders -Project $Project -CodeLanguage $CodeLanguage -Force:$Force

}