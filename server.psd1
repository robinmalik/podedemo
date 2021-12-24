@{
	Port        = 8091
	Url         = 'localhost'
	WebSiteName = 'My Website'
	Server      = @{
		FileMonitor = @{
			Enable  = $true
			Include = @("*.ps1")
			Exclude = @("logs/*", "public/*", "exampledata/*")
		}
	}
	Web         = @{
		ErrorPages = @{
			ShowExceptions = $true
		}
	}
}