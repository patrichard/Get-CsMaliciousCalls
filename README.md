A little known feature in Skype for Business is the ability for a user to report a malicious call that they've received. This can be done by going to Settings>Tools>Report a Call...

At that point, the user is presented a dialog that allows them to report the just completed call.

If you don't see the 'Report a Call...' option in your client, ensure that the option is enabled in the appropriate voice policy. It can be enabled by setting EnableMaliciousCallTracing to $true, such as

Set-CsVoicePolicy -Identity Global -EnableMaliciousCallTracing $true

Clients will pick up that setting at the next policy refresh.

When the call is reported, info is inserted into the ErrorReportView table of the LcsCDR database. However, unless you're querying for it, you don't see it, and many don't even know where it is, or that it's even there. It doesn't do much good if your users are reporting the calls, but you have no way to view the data.

There are a couple of ways you can retrieve the data. The first is some custom reports in your Monitoring Server's reports. Next is a simple SQL query in SQL Server Management Studio against the LcsCDR database for records with a diagnostics ID of 51017. Just use the following:

SELECT * FROM [LcsCDR].[dbo].[ErrorReportView] WHERE [MsDiagId] = '51017'

The last option is to use PowerShell to make the query against the SQL server for the same info. SQL queries in PowerShell are nothing new. They're relatively fast, and you end up with an array that can be handled like any other object in PowerShell. If you're using the default instance of SQL server for the LcsCDR database, use the function like this:

Get-CsMaliciousCalls -Server [server name]

If you're using a named instance, you can just add the instance name to the command, such as this:

Get-CsMaliciousCalls -Server [server name] -Instance [instance name]

The function will return objects with plenty of info. Note that the FromUri field is the user reporting the malicious call (callee), and the ToUri is the caller. We see the MsDiagHeader notes the reason as "Call Identified as malicious by user".

Obviously, what you do with the information is up to you. You could use PowerShell to further filter the ToUri into an e.164 number and use that to block numbers at your gateways. Or, use an MSPL script on the front end/mediation servers to drop calls with that number. Quite a few possibilities. If you come up with more ways to use the data, drop me a line or post a comment below. For now, toss the function in your PowerShell profile and enjoy your new data view.
