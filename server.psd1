@{
	Port        = 8091
	Url         = 'localhost'
	WebSiteName = 'My Website'
	Server      = @{
		FileMonitor = @{
			Enable  = $true
			Include = @("*.ps1")
			Exclude = @("logs/*", "public/*", "exampledata/*", "structure-buildtaskpage.ps1")
		}
	}
	Web         = @{
		ErrorPages = @{
			ShowExceptions = $true
		}
	}
}