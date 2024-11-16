@echo off
setlocal

:: Verifica si se ha pasado un argumento
if "%~1"=="" (
    echo Uso: copiar.bat [directorio_destino]
    exit /b 1
)

:: Establece la dirección del servidor y la ruta de origen - verificar la ruta a tu usuario
set SERVER=USER@192.168.0.14:/home/USER/performance/benchmark_logs/*
set DESTINATION=%~1

:: Crea el directorio de destino si no existe
if not exist "%DESTINATION%" (
    mkdir "%DESTINATION%"
    if errorlevel 1 (
        echo No se pudo crear el directorio %DESTINATION%.
        exit /b 1
    )
)

:: Ejecuta el comando scp para copiar los archivos
scp %SERVER% %DESTINATION%

:: Verifica si el comando se ejecutó correctamente
if %errorlevel% neq 0 (
    echo Error al copiar los archivos.
) else (
    echo Archivos copiados exitosamente a %DESTINATION%.
)

:: copia los logs generados por iperf3 y ssh_benchmark en el servidor windows

move D:\Development\iperf3\Server.log %DESTINATION%
move E:\benchmark\ssh_benchmark.log %DESTINATION%

endlocal