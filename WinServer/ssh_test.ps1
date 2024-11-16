# Configuración
${User} = "USER"  # Cambia esto por tu usuario
${RpiHost} = "192.168.0.14"  # Cambia esto por la IP de tu Raspberry Pi
${LocalFile} = "archivo_de_prueba.txt"  # Archivo a enviar (ruta completa)
${RemoteFile} = "archivo_recibido.txt"  # Nombre del archivo recibido en la Raspberry Pi
${NumTests} = 5  # Número de pruebas a realizar
${LogFile} = "ssh_benchmark.log"  # Ruta del archivo de log

# Crear o limpiar el archivo de log
if (Test-Path ${LogFile}) {
    Clear-Content ${LogFile}
} else {
    New-Item -Path ${LogFile} -ItemType File
}

# Función para medir el tiempo de conexión SSH, modificar la contraseña despues de -p
function Measure-SSHConnection {
    $duration = Measure-Command {
        C:\cygwin64\bin\sshpass.exe -p K=X1]370gIs* C:\cygwin64\bin\ssh.exe ${User}@${RpiHost} exit
    }
    return $duration.TotalSeconds
}

# Función para copiar archivos y medir el tiempo
function Copy-Files {
    # Copiar archivo local a Raspberry Pi y medir tiempo, modificar la contraseña despues de -p
    $scpDurationToRemote = Measure-Command {
        C:\cygwin64\bin\sshpass.exe -p K=X1]370gIs* C:\cygwin64\bin\scp.exe ${LocalFile} "${User}@${RpiHost}:${RemoteFile}"
    }
    
    # Copiar archivo de Raspberry Pi a local y medir tiempo, modificar la contraseña despues de -p
    $scpDurationFromRemote = Measure-Command {
        C:\cygwin64\bin\sshpass.exe -p K=X1]370gIs* C:\cygwin64\bin\scp.exe "${User}@${RpiHost}:${RemoteFile}" "archivo_recibido_de_vuelta.txt"
    }

    return @($scpDurationToRemote.TotalSeconds, $scpDurationFromRemote.TotalSeconds)
}

# Bucle para realizar las pruebas
for (${i} = 1; ${i} -le ${NumTests}; ${i}++) {
    Write-Host "Prueba ${i}:"
    
    # Medir conexión SSH
    $connectionTime = Measure-SSHConnection
    Write-Host "Tiempo de conexion: $connectionTime segundos"
    
    # Copiar archivos y obtener tiempos de transferencia
    $transferTimes = Copy-Files
    Write-Host "Tiempo de transferencia SCP (local a remoto): $($transferTimes[0]) segundos"
    Write-Host "Tiempo de transferencia SCP (remoto a local): $($transferTimes[1]) segundos"
    
    # Registrar resultados en el archivo de log
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - Prueba ${i}: Tiempo de conexion: $connectionTime segundos, Tiempo SCP (local a remoto): $($transferTimes[0]) segundos, Tiempo SCP (remoto a local): $($transferTimes[1]) segundos" | Out-File -Append -FilePath ${LogFile}
    
    Write-Host "-----------------------------------"
}

Write-Host "Pruebas completadas. Resultados guardados en: ${LogFile}"