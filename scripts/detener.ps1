$ErrorActionPreference = 'Stop'
$project = Split-Path $PSScriptRoot -Parent
$pidFile = Join-Path $project '.runtime/tomcat.pid'
if (Test-Path $pidFile) {
    $tomcatPid = [int](Get-Content $pidFile)
    $process = Get-CimInstance Win32_Process -Filter "ProcessId = $tomcatPid"
    if ($process -and $process.Name -eq 'java.exe' -and $process.CommandLine.Replace('/','\').Contains("$project\.runtime\apache-tomcat-9.0.123")) {
        Stop-Process -Id $tomcatPid
        Write-Host 'Tomcat del laboratorio detenido.'
    } elseif ($process) { throw 'El PID pertenece a otro proceso; no se detuvo.' }
    Remove-Item -LiteralPath $pidFile
}