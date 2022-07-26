$content= Get-Content -Path 'C:\Users\sinha\Downloads\Input.txt'
$UpdateFile=$content.Replace('morning','afternoon')
$UpdateFile | Set-Content -Path 'C:\Users\sinha\Downloads\Output.txt'