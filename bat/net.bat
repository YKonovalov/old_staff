@Echo Off
Set PcTcpDisk=F:

Set PcTcp=%PcTcpDisk%\Net\PcTcp\Install\PcTcp01.ini

c:\qemm\loadhi /rf OdiPkt

rem Set Path=%PcTcpDisk%\Net\PcTcp;%Path%

c:\qemm\loadhi /rf EthDrv
