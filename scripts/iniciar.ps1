param([int]$Port = 8088)
$ErrorActionPreference = 'Stop'
$project = Split-Path $PSScriptRoot -Parent
Set-Location $project
$maven = (Get-Command mvn.cmd -ErrorAction SilentlyContinue).Source
if (!$maven) { $maven = 'C:\Program Files\NetBeans-12.0\netbeans\java\maven\bin\mvn.cmd' }
if (!(Test-Path $maven)) { throw 'Instala Maven y agrega mvn.cmd al PATH.' }
$tomcat = Join-Path $project '.runtime/apache-tomcat-9.0.123'
if (!(Test-Path $tomcat)) {
    $archive = Join-Path $project '.runtime/tomcat.zip'
    New-Item -ItemType Directory -Force (Split-Path $archive) | Out-Null
    $url = 'https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.123/bin/apache-tomcat-9.0.123.zip'
    Invoke-WebRequest $url -OutFile $archive -UseBasicParsing
    $checksum = (Invoke-WebRequest "$url.sha512" -UseBasicParsing).Content
    $expected = ($checksum.Trim() -split '\s+')[0]
    if ((Get-FileHash $archive -Algorithm SHA512).Hash -ne $expected) { throw 'La verificacion SHA512 de Tomcat fallo.' }
    Expand-Archive $archive -DestinationPath (Split-Path $tomcat) -Force
}
if (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue) { throw "El puerto $Port esta ocupado. Deten el laboratorio antes de volver a iniciarlo." }
$env:MAVEN_OPTS = ($env:MAVEN_OPTS + ' -Djavax.net.ssl.trustStoreType=Windows-ROOT -Djavax.net.ssl.trustStore=NONE').Trim()
& $maven '-B' 'package'
if ($LASTEXITCODE -ne 0) { throw 'No se pudo compilar el proyecto.' }
$server = Join-Path $tomcat 'conf/server.xml'
$xml = [xml](Get-Content $server -Raw)
$xml.Server.SetAttribute('port','-1')
$connector = $xml.SelectSingleNode('//Connector[@protocol="HTTP/1.1"]')
$connector.SetAttribute('port',"$Port")
$connector.SetAttribute('address','127.0.0.1')
$xml.Save($server)
Copy-Item 'target/taller-s12s23.war' (Join-Path $tomcat 'webapps/taller-s12s23.war') -Force
$java = (Get-Command java.exe).Source
$argsJava = @("-Dcatalina.home=$tomcat", "-Dcatalina.base=$tomcat", "-Djava.io.tmpdir=$tomcat/temp", '-Dfile.encoding=UTF-8', '-classpath', "$tomcat/bin/bootstrap.jar;$tomcat/bin/tomcat-juli.jar", 'org.apache.catalina.startup.Bootstrap', 'start')
$quoted = $argsJava | ForEach-Object { '"' + $_ + '"' }
$process = Start-Process $java -ArgumentList $quoted -WindowStyle Hidden -PassThru -RedirectStandardOutput "$project/.runtime/tomcat-out.log" -RedirectStandardError "$project/.runtime/tomcat-error.log"
$process.Id | Set-Content "$project/.runtime/tomcat.pid"
$url = "http://localhost:$Port/taller-s12s23/lista_empleados.xhtml"
for ($i=0; $i -lt 40; $i++) {
    Start-Sleep -Seconds 1
    try { $response = Invoke-WebRequest $url -UseBasicParsing; if ($response.StatusCode -eq 200) { Write-Host "Laboratorio disponible: $url"; exit 0 } } catch {}
    if ($process.HasExited) { throw 'Tomcat se detuvo. Revisa .runtime/tomcat-error.log.' }
}
throw 'Tomcat no respondio a tiempo. Revisa los logs en .runtime.'
