#& "C:\Users\aisha\Desktop\cmd\copy_paste_folder.ps1"
$Copy_Path = "C:\Tha5133m\Card\DCIM\anafa_pics"; 
#$Paste_Path = "C:\Users\aisha\Desktop\iphone_copy";
$Paste_Path = "E:"; #Some local path or USB

$Folder_List = $Paste_Path+"\"+"folder_list_1.txt";
$Folder_List1 = $Paste_Path+"\"+"folder_list.txt";

#Get the Folder List
Get-ChildItem $Copy_Path -directory | Select Name | Out-File $Folder_List

#Skip the Header and Empty Lines
Get-Content $Folder_List | Select-Object -Skip 3 | ? {$_.trim() -ne "" } | Out-File $Folder_List1

foreach($line in [System.IO.File]::ReadLines($Folder_List1))
{
Write-Host "Folder $line - Started" -ForegroundColor Magenta #-BackgroundColor Gray
$New_Path = $Paste_Path + "\" + $line
If(!(test-path $New_Path))
{
      New-Item -ItemType Directory -Force -Path $New_Path | Out-Null
	  Write-Host "Folder $line - Created" -ForegroundColor White #-BackgroundColor Gray
}

Get-ChildItem $Copy_Path"/"$line | Select Name | Out-File $New_Path/$line"_1".txt
Get-Content $New_Path/$line"_1".txt | Select-Object -Skip 3 | ? {$_.trim() -ne "" } | Out-File $New_Path/$line.txt

$File_List_Number = Get-Content $New_Path/$line.txt | Measure-Object -Line | Select Lines
$Get_Count = $File_List_Number.Lines
$i = 1
$File_List = $New_Path+"\"+$line+".txt"

foreach($file_line in [System.IO.File]::ReadLines($File_List)) {
  
$Copy_Path1 = $Copy_Path+"\"+$line+"\"+$file_line
$Paste_Path1 = $Paste_Path+"\"+$line+"\"+$file_line
  
Copy-Item $Copy_Path1 -Destination $Paste_Path1

If($i -le $File_List_Number.Lines){
$percentComplete = ($i / $File_List_Number.Lines) * 100
Write-Progress -Activity "Folder $line - Copy in Progess!!!" -Status "$i File(s) Copied out of $Get_Count " -PercentComplete $percentComplete;
 $i++
}

}
Write-Host "Folder $line - Complete, $Get_Count Files got Copied" -ForegroundColor blue #-BackgroundColor Gray
}