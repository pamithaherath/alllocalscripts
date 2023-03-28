
$subnames =@()
$Workspace = get-powerbiWorkspace | Where-Object Name -Eq 'PALtest' | Select-Object ID, Name
$Columns = @()
$ColumnMap = @{
    
    'Subscription Name'    = 'String'
    'Subscription ID'  = 'String'
    'MPNID' = 'Int64'
    'Registered on MPL' = 'String'
    'Customer' = 'String'
  }
  $ColumnMap.GetEnumerator() | ForEach-Object {
    $Columns += New-PowerBIColumn -Name $_.Key -DataType $_.Value
  }
 # $Table   = New-PowerBITable -Name "ExampleTable" -Columns $Columns
  #$DataSet = New-PowerBIDataSet -Name "ExampleDataSet" -Tables $Table
  $DataSet = Get-PowerBIDataSet -Name "ExampleDataSet" -WorkspaceId $Workspace.Id
  $Table   = Get-PowerBITable -Name "ExampleTable" -Dataset $DataSet
  #$DataSetResult = Add-PowerBIDataSet -DataSet $DataSet -WorkspaceId $Workspace.Id


  for ($i = 22; $i -lt 27; $i++) {
    $Rows += @(
  @{
    'Subscription Name'    = 'GSU POC Online'+$i.ToString()
    'Subscription ID'  = '8564403d-f731-4aa2-b8a9-138a4f45f8a0'
    'MPNID' = 510665
    'Registered on MPL' = 'Yes'
    'Customer' = 'WWWWBOQ'

  }
    )
  }
  
 <# $Rows = @(
  @{
    'Subscription Name'    = 'GSU POC Automation Sandbox'
    'Subscription ID'  = '8564403d-f731-4aa2-b8a9-138a4f45f8a0'
    'MPNID' = 510665
    'Registered on MPL' = 'Yes'
  }
  @{
    'Subscription Name'    = 'GSU POC Databox'
    'Subscription ID'  = '52d31501-6939-425a-b1f1-26905d37edca'
    'MPNID' = 510665
    'Registered on MPL' = 'Yes'
  }
  @{
    'Subscription Name'    = 'GSU POC Online'
    'Subscription ID'  = ' c6c900d6-50a6-4251-87a8-264388d0f01b'
    'MPNID' = 510665
    'Registered on MPL' = 'Yes'
  }
)#>
$Params = @{
  'DataSetId'   = $DataSet.Id
  'TableName'   = $Table.Name
  'Rows'        = $Rows
  'WorkspaceId' = $Workspace.Id
}
Add-PowerBIRow @Params
write-host $Table.Rows.Count